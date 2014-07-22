
#import <Foundation/Foundation.h>
#import "OpenPosGridCell.h"

#define ORDER (NSLocalizedString(@"ORDER_ORDER", nil))
#define TYPE (NSLocalizedString(@"ORDER_TYPE", nil))
#define VOLUME (NSLocalizedString(@"ORDER_VOLUME", nil))
#define PROFIT_LOSS (NSLocalizedString(@"ORDER_PL", nil))
#define SWAP (NSLocalizedString(@"ORDER_SWAP", nil))
#define COMMISSION (NSLocalizedString(@"ORDER_COMM", nil))

@interface AggrOpenPosGridCell : GridCell {
	ParamsStorage *storage;
	id watch;
}
@property (assign) ParamsStorage *storage;
@property (nonatomic, retain)  id watch;
-(void)Draw:(CGRect)rect;
@end

