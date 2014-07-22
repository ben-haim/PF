#import "PFTableViewCategory+MarketOperation.h"

#import "PFTableViewItem+MarketOperation.h"
#import "PFMarketOperationViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (MarketOperation)

+(double)offsetForMarketOperation:( id< PFMarketOperation > )market_operation_
                       withSLMode:( BOOL )sl_mode_
{
   double absolute_price_ = sl_mode_ ? market_operation_.stopLossPrice : market_operation_.takeProfitPrice;
   
   if ( absolute_price_ == 0.0 )
   {
      return 0.0;
   }
   else
   {
      double operation_price_ = ( [ market_operation_ conformsToProtocol: @protocol(PFOrder) ] &&
                                 ((id< PFOrder >)market_operation_).orderType == PFOrderStopLimit &&
                                 sl_mode_ ) ?
      ((id< PFOrder >)market_operation_).stopPrice :
      market_operation_.price;
      
      return fabs( ( float ) ( absolute_price_ - operation_price_ ) );
   }
}

+(id)stopLossCategoryWithController:( PFMarketOperationViewController* )controller_
                    marketOperation:( id< PFMarketOperation > )market_operation_
{
   double sl_price_ = controller_.useOffsetMode ? [ PFTableViewCategory offsetForMarketOperation: market_operation_ withSLMode: YES ] : market_operation_.stopLossPrice;
  
   return [ self categoryWithTitle: [ [ market_operation_ account ] allowsSLTP ] ? NSLocalizedString( @"CLOSING_ORDERS", nil ):nil
                             items: [[ market_operation_ account ] allowsSLTP ] ? [ NSArray arrayWithStopLossItemsWithPrice: sl_price_
                                                                                                               slOffset: market_operation_.slTrailingOffset
                                                                                                             controller: controller_
                                                                                                        marketOperation: market_operation_ ] : nil ];
}

+(id)takeProfitCategoryWithController:( PFMarketOperationViewController* )controller_
                      marketOperation:( id< PFMarketOperation > )market_operation_
{
   double tp_price_ = controller_.useOffsetMode ?
   [ PFTableViewCategory offsetForMarketOperation: market_operation_ withSLMode: NO ] :
   market_operation_.takeProfitPrice;
   
   return [ self categoryWithTitle: nil
                             items:[[market_operation_ account ]allowsSLTP]?  [ NSArray arrayWithTakeProfitItemsForPrice: tp_price_
                                                                                                              controller: controller_ ] :nil];
}

@end
