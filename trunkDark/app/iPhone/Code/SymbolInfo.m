#import "SymbolInfo.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation SymbolInfo
@synthesize 
		OrderBy,
		isExt,
		Symbol, 
		Desc,
		GroupId,
		Digits,
		TradeMode,
		ProfitMode,
		ContractSize,
		TickValue,
		TickSize,
		DepositCurrency,
		StopsLevel,
		ExecMode,		
		Conv1,
		Conv2,
		Lot_Min,
		Lot_Max,
		Lot_Step;

@synthesize routeName = _routeName;
@synthesize instrumentId;
@synthesize routeId;

-(id) init
{
	self = [super init];
	OrderBy = -1;
	isExt = NO;
	Symbol = nil; 
	Desc = nil;
	GroupId = -1;
	Digits = -1;
	TradeMode = -1;
	ProfitMode = -1;
	ContractSize = -1;
	TickValue = -1;
	TickSize = -1;
	DepositCurrency = nil;
	StopsLevel = -1;
	ExecMode = -1;
	Conv1=nil;
	Conv2=nil;
	return self;

}

- (void)dealloc 
{
   [Symbol release];
   [Desc release];
   [DepositCurrency autorelease];
   [Conv1 release];
   [Conv2 release];
   [ _routeName release ];

	[super dealloc];

}

@end

@implementation SymbolInfo (PFInstrument)

+(id)symbolInfoWithSymbol:( id< PFSymbol > )pf_symbol_
{
   SymbolInfo* symbol_ = [ self new ];
   
   symbol_.OrderBy = 0;
   symbol_.routeName = pf_symbol_.routeName;
   symbol_.Symbol = pf_symbol_.name;
   
   symbol_.instrumentId = pf_symbol_.instrumentId;
   symbol_.routeId = pf_symbol_.routeId;
   
   symbol_.Desc = pf_symbol_.overview;
   
   symbol_.GroupId = pf_symbol_.groupId;
   symbol_.Digits = pf_symbol_.precision;
   symbol_.TradeMode = 2;
   symbol_.ProfitMode = 0;
   symbol_.StopsLevel = 1;
   symbol_.ContractSize = 0.1;
   symbol_.TickValue = pf_symbol_.pointSize * pf_symbol_.lotSize;
   symbol_.TickSize = pf_symbol_.pointSize;
   symbol_.ExecMode = 0;
   symbol_.Lot_Min = 0;
   symbol_.Lot_Max = 10;
   symbol_.Lot_Step = 1;

   return [ symbol_ autorelease ];
}

@end

