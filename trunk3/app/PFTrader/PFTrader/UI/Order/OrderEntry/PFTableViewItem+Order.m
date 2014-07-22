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
   NSArray* trade_session_allowed_types_ = [ [ PFSession sharedSession ] tradeSessionContainerForInstrument: controller_.symbol.instrument ].currentTradeSession.allowedOrderTypes;
  
   NSMutableSet* intersection_ = [ NSMutableSet setWithArray: trade_session_allowed_types_ ];
   [ intersection_ intersectSet: [ NSSet setWithArray: server_allowed_types_ ] ];
   
   NSArray* allowed_types_ = [ intersection_ allObjects ];

   NSArray* client_allowed_types_ = ( [ PFSession sharedSession ].accounts.defaultAccount.allowsOCO
                                     && [ allowed_types_ containsObject: @(PFOrderStop) ]
                                     && [ allowed_types_ containsObject: @(PFOrderLimit) ] ) ? [ allowed_types_ arrayByAddingObject: @(PFOrderOCO) ] : allowed_types_;
   
   PFTableViewOrderTypeItem* type_item_ = [ [ PFTableViewOrderTypeItem alloc ] initWithType: order_type_ andAllowedTypes: client_allowed_types_ ];
   
   type_item_.hiddenDoneButton = YES;
   type_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewOrderTypeItem* order_item_ = ( PFTableViewOrderTypeItem* )picker_item_;

      if ( order_item_.oldType != order_item_.currentType)
      {
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
            if ( unsafe_controller_.slCategory.items )
            {
               unsafe_controller_.slCategory.items = [ NSArray arrayWithStopLossItemsWithPrice: 0.0 slOffset: 0.0 controller: unsafe_controller_ marketOperation: nil ];
               [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.slCategory
                                            withRowAnimation: UITableViewRowAnimationFade ];
            }
            
            if ( unsafe_controller_.tpCategory.items )
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

            if (! [ tif_item_ isEqual: validity_item_ ])
            {
                NSMutableArray* items_ = [ NSMutableArray arrayWithObject: validity_item_ ];
                [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForValidity: validity_item_.currentValidity
                                                                       controller: unsafe_controller_ ] ];

                validity_item_.category.items = items_;

               unsafe_controller_.validityCategory.items = items_;
               [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.validityCategory
                                            withRowAnimation: UITableViewRowAnimationFade ];
            }
         }
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
   __weak PFMarketOperationViewController* unsafe_controller_ = controller_;
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
      if ( (( PFAccountPickerItem* )picker_item_).selectedAccount != [ PFSession sharedSession ].accounts.defaultAccount )
      {
         [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.accountCategory
                                      withRowAnimation: UITableViewRowAnimationFade ];

         [ [ PFSession sharedSession ] selectDefaultAccount: ( ( PFAccountPickerItem* )picker_item_ ).selectedAccount ];

         NSMutableArray* order_type_items1_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: unsafe_controller_
                                                                                                              type: order_type_ ] ];

         [ order_type_items1_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_type_
                                                                       price: level2_quote_.price
                                                                   stopPrice: level2_quote_.price
                                                                 priceOffset: unsafe_controller_.symbol.pointSize
                                                                  controller: unsafe_controller_ ] ];

         NSMutableArray* order_type_items2_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem orderTypeItemWithController: unsafe_controller_
                                                                                                              type: order_type_ ] ];

         [ order_type_items2_ addObjectsFromArray: [ NSArray arrayWithItemsForOrderType: order_type_
                                                                  controller: unsafe_controller_ ] ];

         NSMutableArray *sl_items_, *tp_items_;

         if (! is_level4_mode_ && [(( PFAccountPickerItem* )picker_item_).selectedAccount  allowsSLTP])
         {
            sl_items_ = [NSMutableArray new];
            [ sl_items_ addObjectsFromArray: [ NSArray arrayWithStopLossItemsWithPrice: 0.0 slOffset: 0.0 controller: unsafe_controller_ marketOperation: nil ] ];

            tp_items_ = [NSMutableArray new];
            [ tp_items_ addObjectsFromArray: [ NSArray arrayWithTakeProfitItemsForPrice: 0.0 controller: unsafe_controller_ ] ];
         }

         unsafe_controller_.orderTypeCategory.items = (level2_quote_) ? (order_type_items1_) : ( is_level4_mode_ ? nil : order_type_items2_ );
         [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.orderTypeCategory
                                      withRowAnimation: UITableViewRowAnimationFade ];

         PFOrderType current_order_type_ = ((PFTableViewOrderTypeItem*)[ unsafe_controller_.orderTypeCategory.items objectAtIndex: 0 ]).currentType;
         BOOL old_OCO_mode_ = unsafe_controller_.OCOMode;
         unsafe_controller_.OCOMode = (current_order_type_ == PFOrderOCO);

         if ( (!! sl_items_ != !! unsafe_controller_.slCategory.items) || (!! tp_items_ != !! unsafe_controller_.tpCategory.items) || (unsafe_controller_.OCOMode != old_OCO_mode_))
         {
            if (!sl_items_)
            {
               unsafe_controller_.slCategory.title = nil;
               unsafe_controller_.slCategory.items = nil;
               [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.slCategory
                                            withRowAnimation: UITableViewRowAnimationFade ];
            }

            unsafe_controller_.tpCategory.items = tp_items_;
            [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.tpCategory
                                         withRowAnimation: UITableViewRowAnimationFade ];

            if (sl_items_)
            {
               unsafe_controller_.slCategory.title = NSLocalizedString( @"CLOSING_ORDERS", nil );
               unsafe_controller_.slCategory.items = sl_items_;
               [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.slCategory
                                            withRowAnimation: UITableViewRowAnimationFade ];
            }
         }

         if ( unsafe_controller_.validityCategory )
         {
            PFTableViewTifItem* tif_item_ = (PFTableViewTifItem*)[ unsafe_controller_.validityCategory.items objectAtIndex: 0 ];


            PFTableViewTifItem* validity_item_ = [ PFTableViewItem validityItemWithValidity: [ tif_item_ currentValidity ]
                                                                       andAllowedValidities: [ unsafe_controller_.symbol allowedValiditiesForOrderType: order_type_ ]
                                                                                 controller: unsafe_controller_ ];

            if (! [ tif_item_ isEqual: validity_item_ ])
            {
               NSMutableArray* items_ = [ NSMutableArray arrayWithObject: validity_item_ ];
               [ items_ addObjectsFromArray: [ NSArray arrayWithItemsForValidity: validity_item_.currentValidity
                                                                      controller: unsafe_controller_ ] ];

               validity_item_.category.items = items_;

               unsafe_controller_.validityCategory.items = items_;
               [ unsafe_controller_.tableView reloadCategory: unsafe_controller_.validityCategory
                                            withRowAnimation: UITableViewRowAnimationFade ];
            }
         }

         [ unsafe_controller_ updateButtonsVisibility ];
      }
   };
   
   return account_item_;
}

+(id)dateItemWithController:( PFMarketOperationViewController* )controller_
{
    PFTableViewDatePickerItem* date_item_ = [ PFTableViewDatePickerItem new ];
    date_item_.dateMode = UIDatePickerModeDate;
    date_item_.fromTodayMode = YES;
    date_item_.title = NSLocalizedString( @"GTD_TO", nil );

    date_item_.date = [ NSDate date ];

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
                                   priceOffset: controller_.symbol.instrument.pointSize
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
