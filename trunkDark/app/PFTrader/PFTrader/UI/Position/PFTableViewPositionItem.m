#import "PFTableViewPositionItem.h"
#import "PFTableViewPositionItemCell.h"
#import "PFTableViewSelectedPositionItemCell.h"
#import "PFPositionsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewPositionItem ()

@property ( nonatomic, strong ) id< PFPosition > position;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewPositionItem

@synthesize position;
@synthesize currentController;

+(id)itemWithPosition:( id< PFPosition > )position_
           controller:( UIViewController* )controller_
{
   PFTableViewPositionItem* position_item_ = [ self itemWithAction: nil
                                                             title: nil ];
   position_item_.position = position_;
   position_item_.currentController = controller_;
   
   return position_item_;
}

-(PFPositionsViewController*)positionsController
{
   return (PFPositionsViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.position == self.positionsController.selectedPosition;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.positionsController.selectedPosition = self.position;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.positionsController.selectedPosition = nil;
   }
}

-(Class)cellClass
{
   return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || ![ self isSelected ] ) ? [ PFTableViewPositionItemCell class ] : [ PFTableViewSelectedPositionItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ![ self isSelected ]) ? 55.0f : 371.0f;
}

@end
