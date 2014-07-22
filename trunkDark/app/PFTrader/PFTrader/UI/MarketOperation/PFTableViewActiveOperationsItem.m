#import "PFTableViewActiveOperationsItem.h"
#import "PFTableViewActiveOprerationItemCell.h"
#import "PFTableViewSelectedActiveOprerationItemCell.h"
#import "PFMarketOperationsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewActiveOperationsItem ()

@property ( nonatomic, strong ) id< PFOrder > order;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewActiveOperationsItem

@synthesize order;
@synthesize currentController;

+(id)itemWithOrder:( id< PFOrder > )order_
        controller:( UIViewController* )controller_
{
   PFTableViewActiveOperationsItem* item_ = [ self itemWithAction: nil
                                                            title: nil ];
   item_.order = order_;
   item_.currentController = controller_;
   
   return item_;
}

-(PFMarketOperationsViewController*)operationsController
{
   return (PFMarketOperationsViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.order == self.operationsController.selectedOrder;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.operationsController.selectedOrder = self.order;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.operationsController.selectedOrder = nil;
   }
}

-(Class)cellClass
{
   return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || ![ self isSelected ] ) ?
   [ PFTableViewActiveOprerationItemCell class ] :
   [ PFTableViewSelectedActiveOprerationItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ![ self isSelected ]) ? 55.0f : 406.0f;
}

@end
