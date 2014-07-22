#import "PFTableViewCategory+Settings.h"

#import "PFSettings.h"

#import "PFTableViewQuantityPadItem.h"
#import "PFTableViewTifItem.h"
#import "PFTableViewOrderTypeItem.h"
#import "PFTableViewSwitchItem.h"
#import "PFChartCasheSizePickerItem.h"
#import "PFChartPeriodPickerItem.h"

@implementation PFTableViewCategory (Settings)

+(id)settingsDefaultsCategoryWithSettings:( PFSettings* )settings_
{
   PFTableViewQuantityPadItem* quantity_item_ = [ [ PFTableViewQuantityPadItem alloc ] initWithLots: settings_.lots ];
   
   quantity_item_.applier = ^( PFTableViewItem* item_, id object_ )
   {
      PFTableViewQuantityPadItem* q_item_ = (PFTableViewQuantityPadItem*)item_;
      settings_.lots = [ q_item_ lots ];
      [ settings_ save ];
   };

   PFTableViewTifItem* tif_item_ = [ [ PFTableViewTifItem alloc ] initWithValidity: settings_.orderValidity andAllowedValidities: nil ];
   tif_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewTifItem* item_ = (PFTableViewTifItem*)picker_item_;
      [ settings_ setOrderValidity: [ item_ currentValidity ] ];
      [ settings_ save ];
   };

   PFTableViewOrderTypeItem* order_type_item_ = [ [ PFTableViewOrderTypeItem alloc ] initWithType: settings_.orderType
                                                                                  andAllowedTypes: [ NSArray arrayWithObjects: @(PFOrderMarket)
                                                                                                    , @(PFOrderLimit)
                                                                                                    , @(PFOrderStop)
                                                                                                    , @(PFOrderTrailingStop)
                                                                                                    , @(PFOrderOCO)
                                                                                                    , nil ] ];
   order_type_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewOrderTypeItem* item_ = (PFTableViewOrderTypeItem*)picker_item_;
      [ settings_ setOrderType: [ item_ currentType ] ];
      [ settings_ save ];
   };
   
   PFTableViewSwitchItem* use_sltp_offset_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"USE_SLTP_OFFSET", nil )
                                                                                         isOn: settings_.useSLTPOffset
                                                                                 switchAction: ^(PFTableViewSwitchItem* item_)
                                                   {
                                                      settings_.useSLTPOffset = item_.on;
                                                      [ settings_ save ];
                                                   } ];

   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"DEFAULTS", nil )
                                            items: [ NSArray arrayWithObjects:
                                                    quantity_item_
                                                    , tif_item_
                                                    , order_type_item_
                                                    , use_sltp_offset_item_
                                                    , nil ] ];
}

+(id)settingsConfirmationCategoryWithSettings:( PFSettings* )settings_
{
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"CONFIRMATIONS", nil )
                                            items: [ NSArray arrayWithObjects:
                                                    [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"ORDER_SENDING", nil )
                                                                                           isOn: settings_.shouldConfirmPlaceOrder
                                                                                   switchAction: ^(PFTableViewSwitchItem* item_)
                                                     {
                                                        settings_.shouldConfirmPlaceOrder = item_.on;
                                                        [ settings_ save ];
                                                     }]
                                                    , [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"ORDER_MODIFY", nil )
                                                                                             isOn: settings_.shouldConfirmModifyOrder
                                                                                     switchAction: ^(PFTableViewSwitchItem* item_)
                                                       {
                                                          settings_.shouldConfirmModifyOrder = item_.on;
                                                          [ settings_ save ];
                                                       }]
                                                    , [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"ORDER_CANCELLING", nil )
                                                                                             isOn: settings_.shouldConfirmCancelOrder
                                                                                     switchAction: ^(PFTableViewSwitchItem* item_)
                                                       {
                                                          settings_.shouldConfirmCancelOrder = item_.on;
                                                          [ settings_ save ];
                                                       }]
                                                    , [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"POSITION_MODIFY", nil )
                                                                                             isOn: settings_.shouldConfirmModifyPosition
                                                                                     switchAction: ^(PFTableViewSwitchItem* item_)
                                                       {
                                                          settings_.shouldConfirmModifyPosition = item_.on;
                                                          [ settings_ save ];
                                                       }]
                                                    , [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"POSITION_CLOSING", nil )
                                                                                             isOn: settings_.shouldConfirmClosePosition
                                                                                     switchAction: ^(PFTableViewSwitchItem* item_)
                                                       {
                                                          settings_.shouldConfirmClosePosition = item_.on;
                                                          [ settings_ save ];
                                                       }]
                                                    , [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"EXECUTING_AS_MARKET", nil )
                                                                                             isOn: settings_.shouldConfirmExecuteAsMarket
                                                                                     switchAction: ^(PFTableViewSwitchItem* item_)
                                                       {
                                                          settings_.shouldConfirmExecuteAsMarket = item_.on;
                                                          [ settings_ save ];
                                                       }]
                                                    , nil ] ];
}

+(id)settingsChartCategoryWithSettings:( PFSettings* )settings_
{
   PFChartPeriodPickerItem* period_item_ = [ [ PFChartPeriodPickerItem alloc ] initWithChartPeriod: settings_.defaultChartPeriod ];
   
   period_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFChartPeriodPickerItem* item_ = (PFChartPeriodPickerItem*)picker_item_;
      [ settings_ setDefaultChartPeriod: [ item_ chartPeriod ] ];
      [ settings_ save ];
   };
   
   PFChartCasheSizePickerItem* cashe_size_item_ = [ [ PFChartCasheSizePickerItem alloc ] initWithChartCasheLimit: settings_.chartCacheMaxSize ];
   
   cashe_size_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFChartCasheSizePickerItem* item_ = (PFChartCasheSizePickerItem*)picker_item_;
      [ settings_ setChartCacheMaxSize: [ item_ chartCasheLimit ] ];
      [ settings_ save ];
   };
   
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"CHART", nil )
                                            items: [ NSArray arrayWithObjects: period_item_, cashe_size_item_, nil ] ];
}

+(id)settingsMarketPanelsCategoryWithSettings:( PFSettings* )settings_
{
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"TRADING_PANELS", nil )
                                            items: [ NSArray arrayWithObject: [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"SHOW_MODAL", nil )
                                                                                                                     isOn: settings_.showModalForms
                                                                                                             switchAction: ^(PFTableViewSwitchItem* item_)
                                                                               {
                                                                                  settings_.showModalForms = item_.on;
                                                                                  [ settings_ save ];
                                                                               } ] ] ];
}

@end
