
#import <Foundation/Foundation.h>
#import "../../Code/ServerConnection.h"
#import "BarItem.h"
#import "../../Code/TickData.h"
#import "SymbolInfo.h"
#import <XiPFramework/HLOCDataSource.h>

@interface SymbolChart : NSObject 
{
	NSString* symbol;
	int digits;
	NSMutableDictionary *range_charts;
	NSString * lastRange;
	id serverConn;	
	id chartConn;
}
@property (nonatomic, retain) NSMutableDictionary *range_charts;
@property (nonatomic, retain) NSString *symbol;
@property ( assign) int digits;
@property (nonatomic, assign) id serverConn;
@property (nonatomic, assign) id chartConn;

-(BOOL)GetChart:(NSString*)RangeType;
-(void)OnChartReceived:(NSString*)RangeType 
                  data:(NSArray *)cmdArgs;

-(void)addQuotes:( NSArray* )quotes_
        forRange:( NSString* )range_;

-(void)priceUpdated:(TickData*)dat 
withCurrentRatesSymbol:(NSString *)ratesSymbol 
andCurrentFavoritesSymbol:(NSString *)favoritesSymbol;

@end
