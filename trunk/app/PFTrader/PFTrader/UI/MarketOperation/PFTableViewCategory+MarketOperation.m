#import "PFTableViewCategory+MarketOperation.h"

#import "PFTableViewItem+MarketOperation.h"
#import "PFMarketOperationViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (MarketOperation)

+(double)offsetForMarketOperation:( id< PFMarketOperation > )market_operation_
                       withSLMode:( BOOL )sl_mode_
                        orderView:(BOOL)order_view_
{
   double absolute_price_ = sl_mode_ ? market_operation_.stopLossPrice : market_operation_.takeProfitPrice;
   
   if ( absolute_price_ == 0.0 )
   {
      return 0.0;
   }
   else
   {
      // http://tp.pfsoft.lan/tp2/entity/25862
      double operation_price_;
      
      if (order_view_)
      {
         operation_price_ = ( [ market_operation_ conformsToProtocol: @protocol(PFOrder) ] &&
                             ((id< PFOrder >)market_operation_).orderType == PFOrderStopLimit &&
                             sl_mode_ ) ?
         ((id< PFOrder >)market_operation_).stopPrice :
         ( market_operation_.price);
      }
      else
      {
         operation_price_ = market_operation_.operationType == PFMarketOperationBuy ?
            market_operation_.symbol.quote.bid :
            market_operation_.symbol.quote.ask ;
      }
      
      return fabs( ( float ) ( absolute_price_ - operation_price_ ) );
   }
}

+(id)stopLossCategoryWithController:( PFMarketOperationViewController* )controller_
                    marketOperation:( id< PFMarketOperation > )market_operation_
                          orderView:(BOOL)order_view_
{
   double sl_price_ = controller_.useOffsetMode ?
   [ PFTableViewCategory offsetForMarketOperation: market_operation_ withSLMode: YES orderView: order_view_ ] :
   market_operation_.stopLossPrice;
   
   return [ self categoryWithTitle: NSLocalizedString( @"CLOSING_ORDERS", nil )
                             items: [ NSArray arrayWithStopLossItemsWithPrice: sl_price_
                                                                     slOffset: market_operation_.slTrailingOffset
                                                                   controller: controller_ ] ];
}

+(id)takeProfitCategoryWithController:( PFMarketOperationViewController* )controller_
                      marketOperation:( id< PFMarketOperation > )market_operation_
                            orderView:(BOOL)order_view_
{
   double tp_price_ = controller_.useOffsetMode ?
   [ PFTableViewCategory offsetForMarketOperation: market_operation_ withSLMode: NO orderView: order_view_ ] :
   market_operation_.takeProfitPrice;
   
   return [ self categoryWithTitle: nil
                             items: [ NSArray arrayWithTakeProfitItemsForPrice: tp_price_
                                                                    controller: controller_ ] ];
}

@end
