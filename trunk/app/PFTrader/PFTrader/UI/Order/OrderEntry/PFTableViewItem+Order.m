#import "PFTableViewItem+Order.h"

#import "PFTableViewItem+MarketOperation.h"
#import "PFMarketOperationViewController.h"
#import "PFModifyOrderViewController.h"

#import "PFTableView.h"
#import "PFTableViewCategory.h"

#import "PFTableViewQuantityPadItem.h"
#import "PFTableViewQuantityItem.h"
#import "PFTableViewOrderTypeItem.h"
#import "PFTableViewPriceItem.h"
#import "PFTableViewTifItem.h"
#import "PFTableViewPricePadItem.h"
#import "PFAccountPickerItem.h"
#import "PFTableViewDatePickerItem.h"

#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewItem (OrderEntry)

+(id)itemWithController:( PFMarketOperationViewController* )controller_
                  price:( PFDouble )price_
                   title:( NSString* )title_
{
   PFTableViewItem* price_item_ = [ PFTableViewPricePadItem itemWithTitle: title_
                                                                   symbol: controller_.symbol
                                                                    price: price_ ];
   /*
   [ PFTableViewPriceItem itemWithTitle: title_
                                 symbol: controller_.symbol
                                  price: price_ ];*/
   
   price_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      
      if ( order_.orderType == PFOrderTrailingStop )
      {
         [ order_ setTrailingOffset: [ item_ price ] ];
      }
      else
      {
         [ order_ setPrice: [ item_ price ] ];
      }
   };

   return price_item_;
}

+(id)itemWithController:( PFMarketOperationViewController* )controller_
              stopPrice:( PFDouble )stop_price_
{
   PFTableViewItem* price_item_ = [ PFTableViewPricePadItem itemWithTitle: NSLocalizedString( @"STOP_PRICE", nil )
                                                                   symbol: controller_.symbol
                                                                    price: stop_price_ ];
   /*
   [ PFTableViewPriceItem itemWithTitle: NSLocalizedString( @"STOP_PRICE", nil )
                                 symbol: controller_.symbol
                                  price: stop_price_ ];*/
   
   price_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      [ order_ setStopPrice: [ item_ price ] ];
   };

   return price_item_;
}

+(id)orderTypeItemWithController:( PFMarketOperationViewController* )controller_
                            type:( PFOrderType )order_type_
{
   __weak PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   NSArray* server_allowed_types_ = controller_.symbol.allowedOrderTypes;
   NSArray* client_allowed_types_ = ( [ PFSession sharedSession ].accounts.defaultAccount.allowsOCO
                                     && [ server_allowed_types_ containsObject: @(PFOrderStop) ]
                                     && [ server_allowed_types_ containsObject: @(PFOrderLimit) ] ) ? [ server_allowed_types_ arrayByAddingObject: @(PFOrderOCO) ] : server_allowed_types_;
   
   PFTableViewOrderTypeItem* type_item_ = [ [ PFTableViewOrderTypeItem alloc ] initWithType: order_type_ andAllowedTypes: client_allowed_types_ ];
   type_item_.hiddenDoneButton = YES;
   
   type_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewOrderTypeItem* order_item_ = ( PFTableViewOrderTypeItem* )picker_item_;
      
      NSMutableArray* items_ = [ NSMutableArray arrayWithObject: order_item_ ];
      
      [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_item_.currentType
                                                              controller: unsafe_controller_ ] ];
      
      order_item_.category.items = items_;
      
      [ unsafe_controller_.tableView reloadCategory: order_item_.category
                                   withRowAnimation: UITableViewRowAnimationFade ];
      
      BOOL old_OCO_mode_ = unsafe_controller_.OCOMode;
      unsafe_controller_.OCOMode = order_item_.currentType == PFOrderOCO;
      
      if ( old_OCO_mode_ != unsafe_controller_.OCOMode )
      {
         if ( unsafe_controller_.slCategory )
         {
            unsafe_controller_.slCategory.items = [ NSArray arrayWithStopLossItemsWithPrice: 0.0 slOffset: 0.0 controller: unsafe_controller_ ];
            [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.slCategory
                                         withRowAnimation: UITableViewRowAnimationFade ];
         }
         
         if ( unsafe_controller_.tpCategory )
         {
            unsafe_controller_.tpCategory.items = [ NSArray arrayWithTakeProfitItemsForPrice: 0.0 controller: unsafe_controller_ ];
            [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.tpCategory
                                         withRowAnimation: UITableViewRowAnimationFade ];
         }
      }
      
      if ( unsafe_controller_.validityCategory )
      {
         PFTableViewTifItem* tif_item_ = (PFTableViewTifItem*)[ unsafe_controller_.validityCategory.items objectAtIndex: 0 ];

         PFTableViewTifItem* validity_item_ = [ PFTableViewItem validityItemWithValidity: [ tif_item_ currentValidity ]
                                                                    andAllowedValidities: [ unsafe_controller_.symbol allowedValiditiesForOrderType: order_item_.currentType ]
                                                                              controller: unsafe_controller_ ];

         NSMutableArray* items_ = [ NSMutableArray arrayWithObject: validity_item_ ];
         [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForValidity: validity_item_.currentValidity
                                                                controller: unsafe_controller_ ] ];
         validity_item_.category.items = items_;

         unsafe_controller_.validityCategory.items = items_;
         [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.validityCategory
                                      withRowAnimation: UITableViewRowAnimationFade ];
      }
   };

   type_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      order_.orderType = [ item_ currentType ];
   };

   return type_item_;
}

+(id)quantityItemWithController:( PFMarketOperationViewController* )controller_
                           lots:( double )lots_
{
   PFTableViewItem* quantity_item_ = [ [ PFTableViewQuantityPadItem alloc ] initWithSymbol: controller_.symbol lots: lots_ ];
   //[ [ PFTableViewQuantityItem alloc ] initWithSymbol: controller_.symbol lots: lots_ ];
   
   quantity_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      [ order_ setAmount: [ item_ lots ] ];
   };

   return quantity_item_;
}

+(id)validityItemWithValidity:( PFOrderValidityType )validity_type_
         andAllowedValidities:( NSArray* )allowed_validities_
                   controller:( PFMarketOperationViewController* )controller_
{
   __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
   PFTableViewTifItem* tif_item_ = [ [ PFTableViewTifItem alloc ] initWithValidity: validity_type_ andAllowedValidities: allowed_validities_ ];

   tif_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewTifItem* validity_item_ = ( PFTableViewTifItem* )picker_item_;

      NSMutableArray* items_ = [ NSMutableArray arrayWithObject: validity_item_ ];

      [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForValidity: validity_item_.currentValidity
                                                             controller: unsafe_controller_ ] ];

      validity_item_.category.items = items_;

      [ unsafe_controller_.tableView reloadCategory: validity_item_.category
                                   withRowAnimation: UITableViewRowAnimationFade ];
   };

   tif_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      [ order_ setValidity: [ item_ currentValidity ] ];
   };
   
   return tif_item_;
}

+(id)accountItemWithController:( PFMarketOperationViewController* )controller_
                          type:( PFOrderType )order_type_
                   level2Quote:( id< PFLevel2Quote > )level2_quote_
                  isLevel4Mode:( BOOL )is_level4_mode_
{
   __weak PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   PFAccountPickerItem* account_item_ = [ [ PFAccountPickerItem alloc ] initWithAccount: [ PFSession sharedSession ].accounts.defaultAccount
                                                                      andNonusedAccount: nil ];
   
   account_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      [ [PFSession sharedSession] selectDefaultAccount: ( ( PFAccountPickerItem* )picker_item_ ).selectedAccount ];

      NSMutableArray* items1_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: unsafe_controller_
                                                                                                           type: order_type_ ] ];
      [ items1_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_type_
                                                                    price: level2_quote_.price
                                                                stopPrice: level2_quote_.price
                                                              priceOffset: unsafe_controller_.symbol.pointSize
                                                               controller: unsafe_controller_ ] ];

      NSMutableArray* items2_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: unsafe_controller_
                                                                                                           type: order_type_ ] ];

      [ items2_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_type_
                                                              controller: unsafe_controller_ ] ];

      unsafe_controller_.orderTypeCategory.items = (level2_quote_) ? (items1_) : ( is_level4_mode_ ? nil : items2_ );

      [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.orderTypeCategory
                                   withRowAnimation: UITableViewRowAnimationFade ];
   };
   
   return account_item_;
}

+(id)dateItemWithController:( PFMarketOperationViewController* )controller_
{
   PFTableViewDatePickerItem* date_item_ = [ PFTableViewDatePickerItem new ];
   date_item_.dateMode = UIDatePickerModeDate;
   date_item_.fromTodayMode = YES;
   date_item_.title = NSLocalizedString( @"GTD_TO", nil );

   date_item_.date = [ [NSDate date] dateByAddingTimeInterval: 60*60*24 ];

   date_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableOrder > order_ = ( id< PFMutableOrder > )object_;
      [ order_ setExpireAtDate: [ item_ date ] ];
   };

   return date_item_;
}

@end

@implementation NSArray (PFTableViewItem_Order)

+(id)arrayWithItemsForOrderType:( PFOrderType )order_type_
                          price:( double )price_
                      stopPrice:( double )stop_price_
                    priceOffset:( double )price_offset_
                     controller:( PFMarketOperationViewController* )controller_
{
   NSMutableArray* items_ = [ NSMutableArray new ];

   if ( order_type_ == PFOrderLimit )
   {
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ price: price_ title: NSLocalizedString( @"LIMIT_PRICE", nil ) ] ];
   }
   else if ( order_type_ == PFOrderStop )
   {
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ price: price_ title: NSLocalizedString( @"STOP_PRICE", nil ) ] ];
   }
   else if ( order_type_ == PFOrderStopLimit )
   {
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ price: price_ title: NSLocalizedString( @"LIMIT_PRICE", nil ) ] ];
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ stopPrice: stop_price_ ] ];
   }
   else if ( order_type_ == PFOrderTrailingStop )
   {
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ price: price_offset_ title: NSLocalizedString( @"PRICE_OFFSET", nil ) ] ];
   }
   else if ( order_type_ == PFOrderOCO )
   {
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ price: price_ title: NSLocalizedString( @"LIMIT_PRICE", nil ) ] ];
      [ items_ addObject: [ PFTableViewItem itemWithController: controller_ stopPrice: stop_price_ ] ];
   }

   return items_;
}

+(id)arrayWithItemsForOrderType:( PFOrderType )order_type_
                     controller:( PFMarketOperationViewController* )controller_
{
   PFDouble default_price_ = controller_.defaultPrice;

   return [ NSArray arrayWithItemsForOrderType: order_type_
                                         price: default_price_
                                     stopPrice: default_price_
                                   priceOffset: controller_.symbol.pointSize
                                    controller: controller_ ];
}

+(id)arrayWithItemsForValidity:( PFOrderValidityType )validity_
                    controller:( PFMarketOperationViewController* )controller_
{
   NSMutableArray* items_ = [ NSMutableArray new ];

   if ( validity_ == PFOrderValidityGtd )
   {
      [ items_ addObject: [ PFTableViewItem dateItemWithController: controller_ ] ];
   }

   return items_;
}

@end
