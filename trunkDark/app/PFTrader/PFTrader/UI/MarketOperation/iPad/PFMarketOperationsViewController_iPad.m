#import "PFMarketOperationsViewController_iPad.h"
#import "PFMarketOperationsViewController.h"

#import "PFOrdersChartViewController_iPad.h"
#import "PFTradesChartViewController_iPad.h"
#import "PFOperationsChartViewController_iPad.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import "PFActiveOrdersInfoView.h"
#import "PFFilledOrdersInfoView.h"
#import "PFAllOrdersInfoView.h"

@interface PFMarketOperationsViewController_iPad () < PFMarketOperationsViewControllerDelegate >

@end

@implementation PFMarketOperationsViewController_iPad

-(id)init
{
   PFMarketOperationsViewController* operations_controller_ = [ PFMarketOperationsViewController new ];
   operations_controller_.delegate = self;
   
   self = [ super initWithMasterController: operations_controller_ ];
   
   if ( self )
   {
      
   }
   
   return self;
}

#pragma mark - PFMarketOperationsViewControllerDelegate

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
                       didSelectOrder:( id< PFOrder > )order_
{
   if ( order_ )
   {
      [ self showDetailController: [ [ PFOrdersChartViewController_iPad alloc ] initWithOrder: order_
                                                                                  andInfoView: [ PFActiveOrdersInfoView activeOrdersInfoViewWithOrder: order_ ] ] ];
   }
   else
   {
      [ self showDetailController: nil ];
   }
}

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
                       didSelectTrade:( id< PFTrade > )trade_
{
   if ( trade_ )
   {
      [ self showDetailController: [ [ PFTradesChartViewController_iPad alloc ] initWithTrade: trade_
                                                                                  andInfoView: [ PFFilledOrdersInfoView filledOrdersInfoViewWithTrade: trade_ ] ] ];
   }
   else
   {
      [ self showDetailController: nil ];
   }
}

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
             didSelectMarketOperation:( id< PFMarketOperation > )market_operation_
{
   if ( market_operation_ )
   {
      [ self showDetailController: [ [ PFOperationsChartViewController_iPad alloc ] initWithOperation: market_operation_
                                                                                          andInfoView: [ PFAllOrdersInfoView marketOperationsInfoViewWithMarketOperation: market_operation_ ] ] ];
   }
   else
   {
      [ self showDetailController: nil ];
   }
}

@end
