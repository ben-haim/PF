#import "PFChartColorScheme.h"

@interface PFChartColorScheme ()

@property ( nonatomic, strong ) NSDictionary* properties;

@end

@implementation PFChartColorScheme

@synthesize properties;

+(id)schemeWithProperties:( NSDictionary* )properties_
{
   PFChartColorScheme* scheme_ = [ self new ];
   scheme_.properties = properties_;
   return scheme_;
}

+(id)defaultScheme
{
   return [ self schemeWithProperties: @{
                                         @"style.chart_general.chart_bg_color": @"0x111111FF"
                                         , @"style.chart_general.chart_frame_color": @"0x777777FF"
                                         , @"style.chart_general.chart_grid_color": @"0x262729FF"
                                         , @"style.chart_general.chart_margin_color": @"0x111111FF"
                                         , @"style.chart_general.chart_font_color": @"0x777777FF"
                                         , @"style.chart_general.chart_cursor_color": @"0x777777FF"
                                         , @"style.chart_general.chart_cursor_textcolor": @"0xFFFFFFFF"
                                         , @"style.draw.color": @"0x777777FF"
                                         , @"style.candles.candle_up": @"0x77BC00FF"
                                         , @"style.candles.candle_up_border": @"0x77A000FF"
                                         , @"style.candles.candle_down": @"0xEA3700FF"
                                         , @"style.candles.candle_down_border": @"0xC83700FF"
                                         , @"style.bars.chart_bars_color": @"0x777777FF"
                                         , @"style.bars.chart_bars_color_up": @"0x77BC00FF"
                                         , @"style.bars.chart_bars_color_down": @"0xEA3700FF"
                                         , @"style.main_line.color": @"0x71A1D1FF"
                                         , @"style.area.area_fill_color": @"0x71A1D1FF"
                                         , @"style.area.area_stroke_color": @"0x71A1D1FF"
                                         } ];
}

+(id)greenScheme
{
   return [ self schemeWithProperties: @{
                                         @"style.chart_general.chart_bg_color": @"0x111111FF"
                                         , @"style.chart_general.chart_frame_color": @"0x777777FF"
                                         , @"style.chart_general.chart_grid_color": @"0x262729FF"
                                         , @"style.chart_general.chart_margin_color": @"0x111111FF"
                                         , @"style.chart_general.chart_font_color": @"0x777777FF"
                                         , @"style.chart_general.chart_cursor_color": @"0x777777FF"
                                         , @"style.chart_general.chart_cursor_textcolor": @"0xFFFFFFFF"
                                         , @"style.draw.color": @"0x777777FF"
                                         , @"style.candles.candle_up": @"0x77BC00FF"
                                         , @"style.candles.candle_up_border": @"0x77A000FF"
                                         , @"style.candles.candle_down": @"0x11111100"
                                         , @"style.candles.candle_down_border": @"0x77A000FF"
                                         , @"style.bars.chart_bars_color": @"0x77BC00FF"
                                         , @"style.bars.chart_bars_color_up": @"0x77BC00FF"
                                         , @"style.bars.chart_bars_color_down": @"0x77BC00FF"
                                         , @"style.main_line.color": @"0x77BC00FF"
                                         , @"style.area.area_fill_color": @"0x77BC00FF"
                                         , @"style.area.area_stroke_color": @"0x77BC00FF"
                                         } ];
}

+(NSArray*)schemesByType
{
   static NSArray* schemes_ = nil;
   if ( !schemes_ )
   {
      schemes_ = @[ [ self defaultScheme ], [ self greenScheme ] ];
   }
   return schemes_;
}

+(id)schemeWithType:( PFChartColorSchemeType )scheme_type_
{
   return [ self schemesByType ][scheme_type_];
}

@end
