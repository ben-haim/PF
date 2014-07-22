#import "PFTableViewCategory+ChartSettings.h"

#import "PFChartSettings.h"

#import "PFTableViewSwitchItem.h"
#import "PFChartStyleTableItem.h"
#import "PFChartColorSchemeTableItem.h"

@implementation PFTableViewCategory (ChartSettings)

+(id)generalCategoryWithSettings:( PFChartSettings* )initial_settings_
{
   PFChartStyleTableItem* style_item_ = [ [ PFChartStyleTableItem alloc ] initWithStyleType: initial_settings_.styleType ];
   style_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.styleType = [ (PFChartStyleTableItem*)item_ styleType ];
   };
   
   PFChartColorSchemeTableItem* scheme_item_ = [ [ PFChartColorSchemeTableItem alloc ] initWithSchemeType: initial_settings_.schemeType ];
   scheme_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.schemeType = [ (PFChartColorSchemeTableItem*)item_ schemeType ];
   };
   
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"DEFAULTS", nil )
                                            items: [ NSArray arrayWithObjects:
                                                    style_item_
                                                    , scheme_item_
                                                    , nil ] ];
}

+(id)tradingLayersCategoryWithSettings:( PFChartSettings* )initial_settings_
{
   PFTableViewSwitchItem* show_orders_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"SHOW_ORDERS", nil )
                                                                                     isOn: initial_settings_.showOrders
                                                                             switchAction: nil ];
   show_orders_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.showOrders = [ (PFTableViewSwitchItem*)item_ on ];
   };
   
   PFTableViewSwitchItem* show_positions_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"SHOW_POSITIONS", nil )
                                                                                        isOn: initial_settings_.showPositions
                                                                                switchAction: nil ];
   show_positions_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.showPositions = [ (PFTableViewSwitchItem*)item_ on ];
   };
   
   PFTableViewSwitchItem* include_in_scaling_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"INCLUDE_IN_SCALING", nil )
                                                                                            isOn: initial_settings_.tradeLevelsInZoom
                                                                                    switchAction: nil ];
   include_in_scaling_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.tradeLevelsInZoom = [ (PFTableViewSwitchItem*)item_ on ];
   };
   
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"TRADING_LAYERS", nil )
                                            items: [ NSArray arrayWithObjects:
                                                      show_orders_item_
                                                    , show_positions_item_
                                                    , include_in_scaling_item_
                                                    , nil ] ];
}

+(id)additionalCategoryWithSettings:( PFChartSettings* )initial_settings_
{
   PFTableViewSwitchItem* show_volume_item_ = [ PFTableViewSwitchItem switchItemWithTitle: NSLocalizedString( @"SHOW_VOLUME", nil )
                                                                                     isOn: initial_settings_.showVolume
                                                                             switchAction: nil ];
   show_volume_item_.applier = ^( PFTableViewItem* item_, PFChartSettings* settings_ )
   {
      settings_.showVolume = [ (PFTableViewSwitchItem*)item_ on ];
   };
      
   return [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"ADDITIONAL", nil )
                                            items: [ NSArray arrayWithObject: show_volume_item_ ] ];
}

@end
