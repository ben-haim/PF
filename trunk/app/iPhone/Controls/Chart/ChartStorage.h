
#import <Foundation/Foundation.h>
#import "SymbolChart.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"
#import "TradePaneType.h"

@interface ChartStorage : NSObject 
{
	NSMutableDictionary *symbol_charts;
	id serverConn;
	NSString * lastRange;
	NSMutableArray *chartRequests;
	BOOL requestInProgress;
	NSString *currentFavoritesSymbol;
	NSString *currentRatesSymbol;
}

@property (retain) NSMutableDictionary *symbol_charts;
@property (nonatomic, retain) NSString *lastRange;
@property (nonatomic, assign) id serverConn;
@property (nonatomic, retain) NSMutableArray *chartRequests;
@property BOOL requestInProgress;

@property (nonatomic, retain) NSString *currentFavoritesSymbol;
@property (nonatomic, retain) NSString *currentRatesSymbol;

-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType;
-(void)OnChartReceived:(NSString*)symbol data:(NSArray *)cmdArgs;
-(void)priceUpdated:(TickData*)dat;

-(void)setCurrentSymbol:(NSString *)symbol ForScreen:(TradePaneType)type;

@end
