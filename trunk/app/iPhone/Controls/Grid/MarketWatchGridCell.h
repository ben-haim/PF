
#import <Foundation/Foundation.h>
#import <math.h>
#import "GridCell.h"
#import "MarketWatchCell.h"
#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"

@interface MarketWatchGridCell : GridCell 
{
	ParamsStorage *storage;
	NSString *Symbol;
}
@property (assign) ParamsStorage *storage;
@property (nonatomic, assign) NSString *Symbol;

-(void)Draw:(CGRect)rect;
-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3 Sym:(SymbolInfo *)sym;
-(NSString*)CalculateSpreadOf:(SymbolInfo *)sym withAsk:(NSString *)ask withBid:(NSString *)bid;

@end
