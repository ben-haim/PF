
#import "ChartStorage.h"
#import "ChartRequest.h"
#import "Queue.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation ChartStorage
@synthesize symbol_charts, serverConn, lastRange, chartRequests, requestInProgress, currentRatesSymbol, currentFavoritesSymbol;

-(id) init
{
	self = [super init];
	symbol_charts = [[NSMutableDictionary alloc] init];
	chartRequests = [[NSMutableArray alloc] init];
	requestInProgress = NO;
	return self;
}

-(void)dealloc
{
	if(symbol_charts!=nil)
		[symbol_charts release];
	symbol_charts = nil;
	[super dealloc];
}

-(void)RequestChartForSymbol:(NSString*)symbol andRange:(NSString*)rangeType
{
	requestInProgress = YES;
	if(lastRange!=nil)
	{
		[lastRange release];
	}
	lastRange = [[NSString alloc] initWithFormat:@"%@", rangeType];
	
	ServerConnection *s = (ServerConnection*)serverConn;
	[s SendChartRequest:symbol  AndRange:rangeType];	
	//NSLog(@"SymbolChart SendChartRequest Call for Symbol: %@ at Range: %@", symbol, rangeType);
}

-(void)QueueChartRequestforSymbol:(NSString*)symbol andRange:(NSString*)rangeType
{
	//NSLog(@"ChartStorage QueueChartRequestforSymbol for symbol: %@", symbol);
	ChartRequest *chartRequest = [[ChartRequest alloc] init];
	[chartRequest setSymbol:symbol];
	[chartRequest setRangeType:rangeType];
	
	[chartRequests enqueue:chartRequest];
	[chartRequest release];
	
	if (!requestInProgress)
	{
		[self RequestChartForSymbol:symbol andRange:rangeType];
	}
}

-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType
{

	//NSLog(@"ChartStorage GetChart for symbol: %@", symbol.Symbol);
	SymbolChart *sym_chart = [symbol_charts objectForKey:symbol.Symbol];
	if(sym_chart==nil)
	{
		//NSLog(@"ChartStorage GetChart, symbol: %@, range: %@", symbol.Symbol, RangeType);
		
		NSArray* keys = [symbol_charts allKeys];
		
		if ([keys count] > 5)
		{
			BOOL chartRemoved = NO;
			for (NSString *symbolKey in keys)
			{
				if (chartRemoved)
				{
					break;
				}
				if (![symbolKey isEqualToString:[self currentRatesSymbol]] && ![symbolKey isEqualToString:[self currentFavoritesSymbol]]) 
				{
					if ([chartRequests count] > 0)
					{
						for (ChartRequest *chartRequest in chartRequests)
						{
							if (![[chartRequest symbol] isEqualToString:symbolKey]) 
							{
								[symbol_charts removeObjectForKey:symbolKey];
								chartRemoved = YES;
								break;
							}
						}
					}
					else 
					{
						[symbol_charts removeObjectForKey:symbolKey];
						chartRemoved = YES;
						break;
					}
				}
			}
		}
		
		sym_chart = [[SymbolChart alloc] init];
		sym_chart.symbol = symbol.Symbol;
		sym_chart.digits = symbol.Digits;
		sym_chart.serverConn = serverConn;
		[symbol_charts setObject:sym_chart forKey:symbol.Symbol]; 
		[sym_chart release];
	}
	else
	{
		//sym_chart<>nil		
		if ([sym_chart GetChart:RangeType])
			return;
	}
	[self QueueChartRequestforSymbol:symbol.Symbol andRange:RangeType];
   
   [ [ PFSession sharedSession ] historyForInstrumentWithId: symbol.instrumentId
                                                  routeName: symbol.routeName
                                                     period: PFChartPeriodDay
                                                   fromDate: [ [ NSDate date ] dateByAddingTimeInterval: -10*24*60*60 ]
                                                     toDate: [ NSDate date ]
                                                  doneBlock: ^( NSArray* quotes_, NSError* error_ )
    {
       [ sym_chart addQuotes: quotes_ forRange: RangeType ];
    }];

}

-(void)OnChartReceived:(NSString*)symbol data:(NSArray *)cmdArgs
{
	requestInProgress = NO;
	//NSLog(@"ChartStorage onChartReceived for symbol: %@", symbol);
	SymbolChart *sym_chart = [symbol_charts objectForKey:symbol];
	if(sym_chart==nil)
		sym_chart = [[SymbolChart new]autorelease];
	if(lastRange!=nil)
		[sym_chart OnChartReceived:lastRange data:cmdArgs];	
	
	[chartRequests dequeue];
	if ([chartRequests count] > 0)
	{
		ChartRequest *chartRequest = [chartRequests objectAtIndex:0];
		SymbolChart *sym_chart = [symbol_charts objectForKey:[chartRequest symbol]];
		if (![sym_chart GetChart:[chartRequest rangeType]] && !requestInProgress)
		{
			[self RequestChartForSymbol:sym_chart.symbol andRange:[chartRequest rangeType]];
		}
	}
} 

-(void)priceUpdated:(TickData*)dat
{
	SymbolChart *sym_chart = [symbol_charts objectForKey:dat.Symbol];
	if(sym_chart!=nil)
	{
		//NSLog(@"ChartStorage priceUpdated for symbol: %@", dat.Symbol);
		[sym_chart priceUpdated:dat withCurrentRatesSymbol:self.currentRatesSymbol andCurrentFavoritesSymbol:currentFavoritesSymbol];
	}
}

-(void)setCurrentSymbol:(NSString *)symbol ForScreen:(TradePaneType)type
{
	if (type == TRADE_PANE_RATES)
	{
		[self setCurrentRatesSymbol:symbol];
	}
	else if (type == TRADE_PANE_FAVORITES)
	{
		[self setCurrentFavoritesSymbol:symbol];
	}
}

@end
