#import "PFTableViewCategory+Order.h"

#import "PFTableViewItem+Order.h"
#import "PFTableViewItem+MarketOperation.h"
#import "PFTableViewOrderTypeItem.h"
#import "PFTableViewTifItem.h"
#import "PFMarketOperationViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (Order)

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                                type:( PFOrderType )order_type_
{
   PFTableViewCategory* category_ = [ self new ];

   NSMutableArray* items_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: controller_
                                                                                                       type: order_type_ ] ];

   [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_type_
                                                           controller: controller_ ] ];

   category_.items = items_;

   return category_;
}

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                         level2Quote:( id< PFLevel2Quote > )level2_quote_
{
   PFTableViewCategory* category_ = [ self new ];
   
   PFTableViewOrderTypeItem* item_ = [ PFTableViewItem orderTypeItemWithController: controller_
                                                                              type: PFOrderLimit ];
   
   NSMutableArray* items_ = [ NSMutableArray arrayWithObject: item_ ];
   
   if ( item_.types.count > 0 )
   {
      [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: PFOrderLimit
                                                                   price: level2_quote_.price
                                                               stopPrice: level2_quote_.price
                                                             priceOffset: controller_.symbol.instrument.pointSize
                                                              controller: controller_ ] ];
   }

   category_.items = items_;

   return category_;
}

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                                type:( PFOrderType )order_type_
                        defaultPrice:( double )default_price_
{
   PFTableViewCategory* category_ = [ self new ];
   
   NSMutableArray* items_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: controller_
                                                                                                       type: order_type_ ] ];
   
   [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: PFOrderLimit
                                                                price: default_price_
                                                            stopPrice: default_price_
                                                          priceOffset: controller_.symbol.instrument.pointSize
                                                           controller: controller_ ] ];
   
   category_.items = items_;
   
   return category_;
}

+(id)quantityCategoryWithController:( PFMarketOperationViewController* )controller_
                               lots:( PFDouble )lots_
{
   return [ self categoryWithTitle: nil
                             items: @[[ PFTableViewItem quantityItemWithController: controller_ lots: lots_ ]] ];
}

+(id)categoryWithValidity:( PFOrderValidityType )validity_
     andAllowedValidities:( NSArray* )allowed_validities_
               controller:( PFMarketOperationViewController* )controller_
{
    PFTableViewCategory* category_ = [ self new ];
    PFTableViewTifItem* validity_item_ = [ PFTableViewItem validityItemWithValidity: validity_
                                                               andAllowedValidities: allowed_validities_
                                                                         controller: controller_ ];
    
    NSMutableArray* items_ = [ NSMutableArray arrayWithObject: validity_item_ ];
    
    [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForValidity: validity_item_.currentValidity
                                                           controller: controller_ ] ];
    
    category_.items = items_;
    
    return category_;
}

+(id)stopLossCategoryWithController:( PFMarketOperationViewController* )controller_
{
   return [ self categoryWithTitle: NSLocalizedString( @"CLOSING_ORDERS", nil )
                             items: [ NSArray arrayWithStopLossItemsWithPrice: 0.0 slOffset: 0.0 controller: controller_ marketOperation: nil ] ];
}

+(id)takeProfitCategoryWithController:( PFMarketOperationViewController* )controller_
{
   return [ self categoryWithTitle: nil
                             items: [ NSArray arrayWithTakeProfitItemsForPrice: 0.0 controller: controller_ ] ];
}

+(id)accountCategoryWithController:( PFMarketOperationViewController* )controller_
                              type:( PFOrderType )order_type_
                       level2Quote:( id< PFLevel2Quote > )level2_quote_
                      isLevel4Mode:( BOOL )is_level4_mode_
{
   return [ self categoryWithTitle: nil
                             items: @[[ PFTableViewItem accountItemWithController: controller_
                                                                                                      type: order_type_
                                                                                               level2Quote: level2_quote_
                                                                                              isLevel4Mode: is_level4_mode_]] ];
}

@end

@implementation PFTableViewCategory (ModifyOrder)

+(id)orderTypeCategoryWithController:( PFMarketOperationViewController* )controller_
                               order:( id< PFOrder > )order_
{
   PFTableViewCategory* category_ = [ self new ];

   category_.items = [ NSArray arrayWithItemsForOrderType: order_.orderType
                                                    price: order_.price
                                                stopPrice: order_.stopPrice
                                              priceOffset: order_.trailingOffset
                                               controller: controller_ ];

   return category_;
}

+(id)quantityCategoryWithController:( PFMarketOperationViewController* )controller_
                              order:( id< PFOrder > )order_
{
   return [ self quantityCategoryWithController: controller_
                                           lots: order_.amount ];
}

+(id)validityCategoryWithOrder:( id< PFOrder > )order_
                    controller:( PFMarketOperationViewController* )controller_
{
   return [ self categoryWithValidity: order_.validity
                 andAllowedValidities: [ order_.symbol allowedValiditiesForOrderType: order_.orderType ]
                           controller: controller_ ];
}

@end
