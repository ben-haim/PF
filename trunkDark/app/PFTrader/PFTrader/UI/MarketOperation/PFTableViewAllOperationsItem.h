#import "PFTableViewItem.h"

@protocol PFMarketOperation;

@interface PFTableViewAllOperationsItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFMarketOperation > operation;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithOperation:( id< PFMarketOperation > )operation_
            controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

@end

