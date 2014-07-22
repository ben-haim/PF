#import <ProFinanceApi/PFTypes.h>

#import <Foundation/Foundation.h>

@class Conversion;

@interface SymbolInfo : NSObject 
{
	int			OrderBy;
	BOOL		isExt;
	NSString *	Symbol;
	NSString *	Desc;
	int			GroupId;
	int			Digits;
	int			TradeMode;
	int			ProfitMode;
	double		ContractSize;
	double		TickValue;
	double		TickSize;
	NSString *	DepositCurrency;
	int			StopsLevel;
	int			ExecMode;
	Conversion *Conv1;
	Conversion *Conv2;
	
	double		Lot_Min;
	double		Lot_Max;
	double		Lot_Step;
}
@property( assign) int OrderBy;
@property( assign) BOOL isExt;
@property( nonatomic, retain) NSString *Symbol;
@property( nonatomic, retain) NSString *Desc;

@property( assign) int GroupId;
@property( assign) int Digits;
@property( assign) int TradeMode;
@property( assign) int ProfitMode;
@property( assign) double ContractSize;
@property( assign) double TickValue;
@property( assign) double TickSize;
@property( nonatomic, retain) NSString *DepositCurrency;
@property( assign) int StopsLevel;
@property( assign) int ExecMode;
@property( nonatomic, retain) Conversion *Conv1;
@property( nonatomic, retain) Conversion *Conv2;

@property( assign) double Lot_Min;
@property( assign) double Lot_Max;
@property( assign) double Lot_Step;

@property ( nonatomic, strong ) NSString* routeName;
@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic, assign ) PFInteger routeId;

@end

@protocol PFSymbol;

@interface SymbolInfo (PFInstrument)

+(id)symbolInfoWithSymbol:( id< PFSymbol > )pf_symbol_;

@end

