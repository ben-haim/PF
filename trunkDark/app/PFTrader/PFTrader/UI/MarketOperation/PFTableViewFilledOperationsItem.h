#import "PFTableViewItem.h"

@protocol PFTrade;

@interface PFTableViewFilledOperationsItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFTrade > trade;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithTrade:( id< PFTrade > )trade_
        controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

@end
