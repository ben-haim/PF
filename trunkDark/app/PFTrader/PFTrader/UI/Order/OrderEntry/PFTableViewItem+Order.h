#import "PFTableViewItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@class PFMarketOperationViewController;

@interface PFTableViewItem (Order)

+(id)orderTypeItemWithController:( PFMarketOperationViewController* )controller_
                            type:( PFOrderType )order_type_;

+(id)quantityItemWithController:( PFMarketOperationViewController* )controller_
                           lots:( double )lots_;

+(id)validityItemWithValidity:( PFOrderValidityType )validity_type_
         andAllowedValidities:( NSArray* )allowed_validities_
                   controller:( PFMarketOperationViewController* )controller_;

+(id)accountItemWithController:( PFMarketOperationViewController* )controller_
                          type:( PFOrderType )order_type_
                   level2Quote:( id< PFLevel2Quote > )level2_quote_
                  isLevel4Mode:( BOOL )is_level4_mode_;

+(id)dateItemWithController:( PFMarketOperationViewController* )controller_;

@end

@interface NSArray (PFTableViewItem_Order)

+(id)arrayWithItemsForOrderType:( PFOrderType )order_type_
                          price:( double )price_
                      stopPrice:( double )stop_price_
                    priceOffset:( double )price_offset_
                     controller:( PFMarketOperationViewController* )controller_;

+(id)arrayWithItemsForOrderType:( PFOrderType )order_type_
                     controller:( PFMarketOperationViewController* )controller_;

+(id)arrayWithItemsForValidity:( PFOrderValidityType )validity_
                    controller:( PFMarketOperationViewController* )controller_;

@end
