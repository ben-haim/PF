

#import <Foundation/Foundation.h>
#import "GridCell.h"
#import "ParamsStorage.h"

#define VOLUME (NSLocalizedString(@"ORDER_VOLUME", nil))
#define ASKSTRING (NSLocalizedString(@"RATES_ASK", nil))
#define BIDSTRING (NSLocalizedString(@"RATES_BID", nil))

@interface AggrPendingPosGridCell : GridCell {
	ParamsStorage *storage;
	id watch;
}
@property (assign) ParamsStorage *storage;
@property (nonatomic, retain)  id watch;
-(void)Draw:(CGRect)rect;
@end
