#import "PFTableViewItem.h"

@protocol PFOrder;

@interface PFTableViewActiveOperationsItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFOrder > order;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithOrder:( id< PFOrder > )order_
        controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

@end
