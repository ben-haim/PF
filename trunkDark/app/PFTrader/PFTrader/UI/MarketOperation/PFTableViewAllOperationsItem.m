#import "PFTableViewAllOperationsItem.h"
#import "PFTableViewAllOprerationItemCell.h"
#import "PFTableViewSelectedAllOprerationItemCell.h"
#import "PFMarketOperationsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewAllOperationsItem ()

@property ( nonatomic, strong ) id< PFMarketOperation > operation;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewAllOperationsItem

@synthesize operation;
@synthesize currentController;

+(id)itemWithOperation:( id< PFMarketOperation > )operation_
            controller:( UIViewController* )controller_
{
   PFTableViewAllOperationsItem* item_ = [ self itemWithAction: nil
                                                            title: nil ];
   item_.operation = operation_;
   item_.currentController = controller_;
   
   return item_;
}

-(PFMarketOperationsViewController*)operationsController
{
   return (PFMarketOperationsViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.operation == self.operationsController.selectedOperation;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.operationsController.selectedOperation = self.operation;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.operationsController.selectedOperation = nil;
   }
}

-(Class)cellClass
{
   return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || ![ self isSelected ] ) ?
   [ PFTableViewAllOprerationItemCell class ] :
   [ PFTableViewSelectedAllOprerationItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ![ self isSelected ]) ? 55.0f : 219.0f;
}

@end
