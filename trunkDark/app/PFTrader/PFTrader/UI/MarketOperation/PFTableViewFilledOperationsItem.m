#import "PFTableViewFilledOperationsItem.h"
#import "PFTableViewFilledOprerationItemCell.h"
#import "PFTableViewSelectedFilledOprerationItemCell.h"
#import "PFMarketOperationsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFTableViewFilledOperationsItem ()

@property ( nonatomic, strong ) id< PFTrade > trade;
@property ( nonatomic, weak ) UIViewController* currentController;

@end

@implementation PFTableViewFilledOperationsItem

@synthesize trade;
@synthesize currentController;

+(id)itemWithTrade:( id< PFTrade > )trade_
        controller:( UIViewController* )controller_
{
   PFTableViewFilledOperationsItem* item_ = [ self itemWithAction: nil
                                                            title: nil ];
   item_.trade = trade_;
   item_.currentController = controller_;
   
   return item_;
}

-(PFMarketOperationsViewController*)operationsController
{
   return (PFMarketOperationsViewController*)self.currentController;
}

-(BOOL)isSelected
{
   return self.trade == self.operationsController.selectedTrade;
}

-(void)selectCurrentItem
{
   if ( ![ self isSelected ] )
   {
      self.operationsController.selectedTrade = self.trade;
   }
}

-(void)deselectCurrentItem
{
   if ( [ self isSelected ] )
   {
      self.operationsController.selectedTrade = nil;
   }
}

-(Class)cellClass
{
   return ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || ![ self isSelected ] ) ?
   [ PFTableViewFilledOprerationItemCell class ] :
   [ PFTableViewSelectedFilledOprerationItemCell class ];
}

-(CGFloat)cellHeightForTableView:( UITableView* )table_view_
{
   return ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) || ![ self isSelected ]) ? 55.0f : 261.0f;
}

@end
