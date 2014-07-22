
#import <Foundation/Foundation.h>
#import "GridCell.h"

#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"

@interface PendingPosGridCell : GridCell 
{
	ParamsStorage *storage;
	id watch;
}
@property ( assign) ParamsStorage *storage;
@property (nonatomic, retain)  id watch;
-(void)Draw:(CGRect)rect;
@end
