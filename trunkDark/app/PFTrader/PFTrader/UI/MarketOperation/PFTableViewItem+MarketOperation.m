#import "PFTableViewItem+MarketOperation.h"

#import "PFMarketOperationViewController.h"
#import "PFTableView.h"

#import "PFTableViewCategory.h"
#import "PFTableViewPricePadItem.h"
#import "PFTableViewPriceItem.h"
#import "PFTableViewSwitchItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewItem (MarketOperation)

+(id)stopLossItemWithController:( PFMarketOperationViewController* )controller_
                          price:( PFDouble )price_
                       slOffset: (PFDouble)sl_offset_
{
   __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   NSString* title_ = ( sl_offset_ > 0.0 || unsafe_controller_.useOffsetMode ) ?
   NSLocalizedString( @"SL_OFFSET", nil ) :
   NSLocalizedString( @"S_L_PRICE", nil );
   
   PFTableViewPricePadItem* sl_item_ = [ PFTableViewPricePadItem itemWithTitle: title_
                                                                        symbol: controller_.symbol
                                                                         price: sl_offset_ > 0.0 ? sl_offset_ : price_ ];
   sl_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableMarketOperation > market_operation_ = ( id< PFMutableMarketOperation > )object_;
      
      if ( unsafe_controller_.useOffsetMode )
      {
         BOOL is_buy_ = market_operation_.operationType == PFMarketOperationBuy;
         double sl_price_limit_ = [ unsafe_controller_ priceLimitForOperation: market_operation_ andSLMode: YES ];
         
         [ market_operation_ setStopLossPrice: sl_price_limit_ + ( is_buy_ ? ( - [ item_ price ] ) : [ item_ price ] ) ];
      }
      else
      {
         [ market_operation_ setStopLossPrice: [ item_ price ] ];
      }
   };
   
   return sl_item_;
}

+(id)stopLossItemWithController:( PFMarketOperationViewController* )controller_
                       switchOn:( BOOL )switch_on_
                marketOperation:( id< PFMarketOperation > )market_operation_
{
   __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   PFTableViewSwitchItemAction switch_action_ = ^( PFTableViewSwitchItem* switch_item_ )
   {
      NSMutableArray* items_ = [ NSMutableArray arrayWithObject: switch_item_ ];
      
      if ( switch_item_.on )
      {
         PFTableViewPricePadItem* sl_item_ = [ self stopLossItemWithController: unsafe_controller_
                                                                 price: unsafe_controller_.defaultSLTPPrice
                                                              slOffset: 0.0 ];
         
         [ items_ addObject: sl_item_ ];
          
        id < PFAccount > current_account_ = market_operation_ ? market_operation_.account : [ PFSession sharedSession ].accounts.defaultAccount;
        if ( current_account_.allowsTrailingStop )
        {
           PFTableViewSwitchItem* tralling_switch_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"TRAILING", nil )
                                                                                                 isOn: NO
                                                                                         switchAction: ^( PFTableViewSwitchItem* item_ )
                                                           {
                                                              NSString* title_ = ( item_.on || unsafe_controller_.useOffsetMode ) ?
                                                              NSLocalizedString( @"SL_OFFSET", nil ) :
                                                              NSLocalizedString( @"S_L_PRICE", nil );
                                                              
                                                              sl_item_.title = title_;
                                                              
                                                              sl_item_.value = [ @( item_.on ?
                                                                                unsafe_controller_.symbol.instrument.pointSize :
                                                                                unsafe_controller_.defaultSLTPPrice ) stringValue ];
                                                              
                                                              
                                                              [ unsafe_controller_.tableView reloadCategory: sl_item_.category withRowAnimation: UITableViewRowAnimationNone ];
                                                           }];
           
           tralling_switch_item_.onText = NSLocalizedString( @"ENABLE", nil );
           tralling_switch_item_.offText = NSLocalizedString( @"DISABLE", nil );
           
           tralling_switch_item_.applier = ^( id item_, id object_ )
           {
              if ( [ item_ on ] )
              {
                 id< PFMutableMarketOperation > operation_ = ( id< PFMutableMarketOperation > )object_;
                 
                 [ operation_ setSlTrailingOffset: [ sl_item_ price ] ];
                 [ operation_ setStopLossPrice: 0.0 ];
              }
           };
           
           [ items_ addObject: tralling_switch_item_ ];
        }
      }
      
      switch_item_.category.items = items_;
      
      [ unsafe_controller_.tableView reloadCategory: switch_item_.category
                                   withRowAnimation: UITableViewRowAnimationFade ];
   };
   
   PFTableViewSwitchItem* sl_switch_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"STOP_LOSS", nil )
                                                                                   isOn: switch_on_
                                                                           switchAction: switch_action_ ];
   
   sl_switch_item_.onText = NSLocalizedString( @"ENABLE", nil );
   sl_switch_item_.offText = NSLocalizedString( @"DISABLE", nil );

   sl_switch_item_.applier = ^( id item_, id object_ )
   {
      if ( ![ item_ on ] )
      {
         id< PFMutableMarketOperation > market_operation_ = ( id< PFMutableMarketOperation > )object_;
         [ market_operation_ setStopLossPrice: 0.0 ];
         [ market_operation_ setSlTrailingOffset: 0.0 ];
      }
   };

   return sl_switch_item_;
}

+(id)stopLossItemWithController:( PFMarketOperationViewController* )controller_
{
   return [ self stopLossItemWithController: controller_ switchOn: NO marketOperation: nil ];
}

+(id)takeProfitItemWithController:( PFMarketOperationViewController* )controller_
                            price:( PFDouble )price_
{
   __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   NSString* title_ = unsafe_controller_.useOffsetMode ? NSLocalizedString( @"TP_OFFSET", nil ) : NSLocalizedString( @"T_P_PRICE", nil );
   
   PFTableViewPricePadItem* tp_item_ = [ PFTableViewPricePadItem itemWithTitle: title_
                                                                        symbol: controller_.symbol
                                                                         price: price_ ];
   
   tp_item_.applier = ^( id item_, id object_ )
   {
      id< PFMutableMarketOperation > market_operation_ = (  id< PFMutableMarketOperation > )object_;
      
      if ( unsafe_controller_.useOffsetMode )
      {
         BOOL is_buy_ = market_operation_.operationType == PFMarketOperationBuy;
         double tp_price_limit_ = [ unsafe_controller_ priceLimitForOperation: market_operation_ andSLMode: NO ];
         
         [ market_operation_ setTakeProfitPrice: tp_price_limit_ + ( is_buy_ ? [ item_ price ] : ( - [ item_ price ] ) ) ];
      }
      else
      {
         [ market_operation_ setTakeProfitPrice: [ item_ price ] ];
      }
   };
   
   return tp_item_;
}

+(id)takeProfitItemWithController:( PFMarketOperationViewController* )controller_
                         switchOn:( BOOL )switch_on_
{
   __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
   
   PFTableViewSwitchItemAction switch_action_ = ^( PFTableViewSwitchItem* switch_item_ )
   {
      NSMutableArray* items_ = [ NSMutableArray arrayWithObject: switch_item_ ];
      
      if ( switch_item_.on )
      {
         [ items_ addObject: [ self takeProfitItemWithController: unsafe_controller_
                                                           price: unsafe_controller_.defaultSLTPPrice ] ];
      }
      
      switch_item_.category.items = items_;
      
      [ unsafe_controller_.tableView reloadCategory: switch_item_.category
                                   withRowAnimation: UITableViewRowAnimationFade ];
   };
   
   PFTableViewSwitchItem* tp_switch_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"TAKE_PROFIT", nil )
                                                                                   isOn: switch_on_
                                                                           switchAction: switch_action_ ];

   tp_switch_item_.onText = NSLocalizedString( @"ENABLE", nil );
   tp_switch_item_.offText = NSLocalizedString( @"DISABLE", nil );

   tp_switch_item_.applier = ^( id item_, id object_ )
   {
      if ( ![ item_ on ] )
      {
         id< PFMutableMarketOperation > market_operation_ = ( id< PFMutableMarketOperation > )object_;
         [ market_operation_ setTakeProfitPrice: 0.0 ];
      }
   };

   return tp_switch_item_;
}

+(id)takeProfitItemWithController:( PFMarketOperationViewController* )controller_
{
   return [ self takeProfitItemWithController: controller_ switchOn: NO ];
}

@end

@implementation NSArray (PFTableViewItem_Order)

+(id)arrayWithStopLossItemsWithPrice:( double )price_
                            slOffset:( double )sl_offset_
                          controller:( PFMarketOperationViewController* )controller_
                     marketOperation:( id< PFMarketOperation > )market_operation_
{
   BOOL on_ = price_ > 0.0 || sl_offset_ > 0.0;
   
   NSMutableArray* items_ = [ NSMutableArray arrayWithObject: [ PFTableViewSwitchItem stopLossItemWithController: controller_ switchOn: on_ marketOperation: market_operation_ ] ];
   
   if ( on_ )
   {
      PFTableViewPricePadItem* sl_item_ = [ PFTableViewItem stopLossItemWithController: controller_  price: price_ slOffset: sl_offset_ ];
      
      [ items_ addObject: sl_item_ ];
      
      id < PFAccount > current_account_ = market_operation_ ? market_operation_.account : [ PFSession sharedSession ].accounts.defaultAccount;
      if ( current_account_.allowsTrailingStop )
      {
         __unsafe_unretained PFMarketOperationViewController* unsafe_controller_ = controller_;
         
         PFTableViewSwitchItem* tralling_switch_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"TRAILING", nil )
                                                                                               isOn: sl_offset_ > 0.0
                                                                                       switchAction: ^( PFTableViewSwitchItem* item_ )
                                                         {
                                                            sl_item_.title = item_.on ? NSLocalizedString( @"SL_OFFSET", nil ) : NSLocalizedString( @"S_L_PRICE", nil );
                                                            sl_item_.value = [ @( item_.on ?
                                                                              unsafe_controller_.symbol.instrument.pointSize :
                                                                              ( sl_offset_ > 0.0 ? sl_offset_ : price_ ) ) stringValue ];

                                                            [ unsafe_controller_.tableView reloadCategory: sl_item_.category withRowAnimation: UITableViewRowAnimationNone ];
                                                            
                                                         }];
         
         
         tralling_switch_item_.onText = NSLocalizedString( @"ENABLE", nil );
         tralling_switch_item_.offText = NSLocalizedString( @"DISABLE", nil );
         
         tralling_switch_item_.applier = ^( id item_, id object_ )
         {
            if ( [ item_ on ] )
            {
               id< PFMutableMarketOperation > operation_ = ( id< PFMutableMarketOperation > )object_;
               
               [ operation_ setSlTrailingOffset: [ sl_item_ price ] ];
               [ operation_ setStopLossPrice: 0.0 ];
            }
         };
         
         [ items_ addObject: tralling_switch_item_ ];
      }
   }
   
   return items_;
}

+(id)arrayWithTakeProfitItemsForPrice:( double )price_
                           controller:( PFMarketOperationViewController* )controller_
{
   BOOL on_ = price_ > 0.0;
   
   NSMutableArray* items_ = [ NSMutableArray arrayWithObject: [ PFTableViewItem takeProfitItemWithController: controller_ switchOn: on_ ] ];
   
   if ( on_ )
   {
      [ items_ addObject: [ PFTableViewItem takeProfitItemWithController: controller_ price: price_ ] ];
   }
   
   return items_;
}

@end
