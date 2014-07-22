
#import "SymbolChart.h"
#import "../../Code/ServerConnection.h"
#import "../../Classes/iTraderAppDelegate.h"
#import "ChartRequest.h"
#import "Queue.h"
#import "IncomingChartInfo.h"
#import <XiPFramework/ArrayMath.h>

#import <ProFinanceApi/Detail/Chart/PFQuoteInfo.h>

@implementation SymbolChart
@synthesize range_charts, serverConn, chartConn, symbol, digits;
-(id) init
{
	self = [super init];
	range_charts = [[NSMutableDictionary alloc] init];
	return self;
}
-(void)dealloc
{
	if(range_charts!=nil)
	{
		[range_charts removeAllObjects];
		[range_charts release];
	}
	range_charts = nil;
	[super dealloc];
}

-(BOOL)hasChartForRangeType:(NSString*)RangeType
{
	NSMutableArray *chart = [range_charts objectForKey:RangeType];
	if(chart==nil)
	{
		return NO;
	}
	else 
	{
		return YES;
	}
}
/**
 * If the chart range exists for this symbol then, the chart for the given range is send to the UI,
 * if not then this method returns NO, to notify the ChartStorage to send a chart request to the server
 */
-(BOOL)GetChart:(NSString*)RangeType
{
	//NSString *key = [[NSString alloc] initWithFormat:@"%d", RangeType];
	if(lastRange!=nil)
		[lastRange release];
	lastRange = [[NSString alloc] initWithFormat:@"%@", RangeType];
	
	HLOCDataSource *chart = [range_charts objectForKey:RangeType];
	if(chart==nil)
	{
		return NO;
	}
	else
	{
		IncomingChartInfo *incomingChartInfo = [[IncomingChartInfo alloc] init];
		[incomingChartInfo setSymbol:symbol];
		[incomingChartInfo setChart:chart];
		NSLog(@"IncomingChartInfo sent 1\n");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"chart" object:incomingChartInfo];
		[incomingChartInfo release];
		return YES;
	}
}

-(void)addQuotes:( NSArray* )quotes_
        forRange:( NSString* )range_
{
	HLOCDataSource *chart = [range_charts objectForKey:range_];
	if(chart!=nil)
		[range_charts removeObjectForKey:range_];

   //TODO: capacity should come from the cmdArgs
	int capacity = [ quotes_ count ];
	int iRangeType = [range_ intValue];
   chart = [[HLOCDataSource alloc] initWithRangeType:iRangeType AndDigits:5];
   ArrayMath *v_open  = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_close = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_high  = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_low   = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_vol   = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_time  = [[ArrayMath alloc] initWithLength:capacity];
   //basic derivatives
   ArrayMath *v_hl2   = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_hlc3  = [[ArrayMath alloc] initWithLength:capacity];
   ArrayMath *v_hlcc4 = [[ArrayMath alloc] initWithLength:capacity];
   
	int c = 0;
   
	for ( PFLotsQuote* quote_ in quotes_ )
	{
      //TODO: change: open, hight, low, close, vol and time_temp with actual values from args
		double open     = quote_.bidInfo.open;
		double high     = quote_.bidInfo.high;
		double low      = quote_.bidInfo.low;
		double close    = quote_.bidInfo.close;
		double vol      = quote_.bidInfo.volume;
		int time_temp   = [ quote_.date timeIntervalSince1970 ];

      //basic derivatives
      double hl2      = (high + low) / 2.0;
      double hlc3     = (high + low + close) / 3.0;
      double hlcc4    = (high + low + 2*close) / 4.0;
      
      [v_open getData][c] = open;
      [v_close getData][c] = close;
      [v_high getData][c] = high;
      [v_low getData][c] = low;
      [v_vol getData][c] = vol;
      [v_time getData][c] = time_temp;
      
      [v_hl2 getData][c] = hl2;
      [v_hlc3 getData][c] = hlc3;
      [v_hlcc4 getData][c] = hlcc4;
		c++;
	}
   [chart SetVector:v_high forKey:@"highData"];
   [chart SetVector:v_low forKey:@"lowData"];
   [chart SetVector:v_open forKey:@"openData"];
   [chart SetVector:v_close forKey:@"closeData"];
   [chart SetVector:v_vol forKey:@"volData"];
   [chart SetVector:v_time forKey:@"timeStamps"];
   
   [chart SetVector:v_hl2 forKey:@"hl2Data"];
   [chart SetVector:v_hlc3 forKey:@"hlc3Data"];
   [chart SetVector:v_hlcc4 forKey:@"hlcc4Data"];
   
   chart.last_bid = chart.last_ask = [v_close getData][[v_close getLength]-1];

   [v_open release];
   [v_close release];
   [v_low release];
   [v_high release];
   [v_vol release];
   [v_time release];
   [v_hl2 release];
   [v_hlc3 release];
   [v_hlcc4 release];
   
	[range_charts setObject:chart forKey:range_];
	[chart release];
	IncomingChartInfo *incomingChartInfo = [[IncomingChartInfo alloc] init];
	[incomingChartInfo setSymbol:symbol];
	[incomingChartInfo setChart:[range_charts objectForKey:range_]];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"chart" object:incomingChartInfo];

	[incomingChartInfo release];
}

-(void)OnChartReceived:(NSString*)RangeType
                  data:(NSArray *)cmdArgs
{
	HLOCDataSource *chart = [range_charts objectForKey:RangeType];
	if(chart!=nil)
		[range_charts removeObjectForKey:RangeType];
	
	double powered = pow(10, digits);
    
    //TODO: capacity should come from the cmdArgs
	int capacity = 200;
	int iRangeType = [RangeType intValue];
    chart = [[HLOCDataSource alloc] initWithRangeType:iRangeType AndDigits:digits];    
    ArrayMath *v_open  = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_close = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_high  = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_low   = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_vol   = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_time  = [[ArrayMath alloc] initWithLength:capacity];    
    //basic derivatives
    ArrayMath *v_hl2   = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_hlc3  = [[ArrayMath alloc] initWithLength:capacity];
    ArrayMath *v_hlcc4 = [[ArrayMath alloc] initWithLength:capacity]; 
    
	int c = 0;
    
	for(int i=0; i<capacity; i++)
	{		
        //TODO: change: open, hight, low, close, vol and time_temp with actual values from args
		double open     = 1/powered;
		double high     = open + 5/powered;
		double low      = open + 1/powered;
		double close    = open + 3/powered;
		double vol      = 1;
		int time_temp   = 0;
        int dateDaylightSaving = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[[[NSDate alloc] initWithTimeIntervalSince1970:time_temp] autorelease]];
        
        int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];// - dateDaylightSaving;
        if (dateDaylightSaving == 0) 
        {
            gmt_delta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
        }
        
        time_temp-=gmt_delta;
        //basic derivatives
        double hl2      = (high + low) / 2.0;
        double hlc3     = (high + low + close) / 3.0;
        double hlcc4    = (high + low + 2*close) / 4.0;
        
        [v_open getData][c] = open;
        [v_close getData][c] = close;
        [v_high getData][c] = high;
        [v_low getData][c] = low;
        [v_vol getData][c] = vol;
        [v_time getData][c] = time_temp;   
        
        [v_hl2 getData][c] = hl2;
        [v_hlc3 getData][c] = hlc3;
        [v_hlcc4 getData][c] = hlcc4;
		c++;
	}
    if([cmdArgs count]==3)//empty data
    {
        [v_open getData][c] = 0;
        [v_close getData][c] = 0;
        [v_high getData][c] = 0;
        [v_low getData][c] = 0;
        [v_vol getData][c] = 0;
        [v_time getData][c] = 0;   
        
        [v_hl2 getData][c] = 0;
        [v_hlc3 getData][c] = 0;
        [v_hlcc4 getData][c] = 0;        
    }
    [chart SetVector:v_high forKey:@"highData"];
    [chart SetVector:v_low forKey:@"lowData"];
    [chart SetVector:v_open forKey:@"openData"];
    [chart SetVector:v_close forKey:@"closeData"];
    [chart SetVector:v_vol forKey:@"volData"];
    [chart SetVector:v_time forKey:@"timeStamps"];    
    
    [chart SetVector:v_hl2 forKey:@"hl2Data"];    
    [chart SetVector:v_hlc3 forKey:@"hlc3Data"];    
    [chart SetVector:v_hlcc4 forKey:@"hlcc4Data"];    
    
    chart.last_bid = chart.last_ask = [v_close getData][[v_close getLength]-1];
    
    [v_open release];
    [v_close release];
    [v_low release];
    [v_high release];
    [v_vol release];
    [v_time release];
    [v_hl2 release];
    [v_hlc3 release];
    [v_hlcc4 release]; 
    
	[range_charts setObject:chart forKey:RangeType];
	[chart release];
	IncomingChartInfo *incomingChartInfo = [[IncomingChartInfo alloc] init];
	[incomingChartInfo setSymbol:symbol];
	[incomingChartInfo setChart:[range_charts objectForKey:RangeType]];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"chart" object:incomingChartInfo];
	
	[incomingChartInfo release];
	
	if(chartConn!=nil)
	{
		ServerConnection *sc = (ServerConnection*)chartConn;
		[sc Disconnect];
		[sc release];
		chartConn = nil;
	}
}

-(void)priceUpdated:(TickData*)dat 
withCurrentRatesSymbol:(NSString *)ratesSymbol 
andCurrentFavoritesSymbol:(NSString *)favoritesSymbol
{	
	
	NSEnumerator *enumerator = [[range_charts allKeys] objectEnumerator];
	id value;	
	BOOL NewBarAdded = NO;
	while ((value = [enumerator nextObject])) 
	{
		NSString *key = (NSString *)value;	
		HLOCDataSource *chart = (HLOCDataSource*)[range_charts objectForKey:key];
        //NSLog(@"chart %@, key=%@", chart, key);
		BOOL AddNewBar = [chart MergePriceWithBid:[dat.Bid doubleValue] 
                                           AndAsk:[dat.Ask doubleValue]
                                           AtTime:dat.lastUpdate];
        if(AddNewBar)
			NewBarAdded = YES;
	}
	if([ratesSymbol isEqualToString:self.symbol] || [favoritesSymbol isEqualToString:self.symbol])
	{
        if(NewBarAdded)
        {
            NSLog(@"SymbolChart new BAR for symbol: %@", dat.Symbol);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chart_newbar" object:dat.Symbol];
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"priceChangedChart" object:dat.Symbol];
    }
    
}
@end














