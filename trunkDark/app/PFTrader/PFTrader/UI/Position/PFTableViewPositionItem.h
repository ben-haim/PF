#import "PFTableViewItem.h"

@protocol PFPosition;

@interface PFTableViewPositionItem : PFTableViewItem

@property ( nonatomic, strong, readonly ) id< PFPosition > position;
@property ( nonatomic, weak, readonly ) UIViewController* currentController;
@property ( nonatomic, assign, readonly ) BOOL isSelected;

+(id)itemWithPosition:( id< PFPosition > )position_
           controller:( UIViewController* )controller_;

-(void)selectCurrentItem;
-(void)deselectCurrentItem;

@end
