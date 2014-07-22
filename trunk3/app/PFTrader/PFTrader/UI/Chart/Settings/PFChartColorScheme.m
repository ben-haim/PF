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
           @"style.chart_general.chart_bg_color": @"0xFFFFFF00"
           , @"style.chart_general.chart_frame_color": @"0x222222FF"
           , @"style.chart_general.chart_grid_color": @"0xAEB6BCFF"
           , @"style.chart_general.chart_margin_color": @"0xFFFFFF00"
           , @"style.chart_general.chart_font_color": @"0x222222FF"
           , @"style.chart_general.chart_cursor_color": @"0x222222FF"
           , @"style.chart_general.chart_cursor_textcolor": @"0x222222FF"
           , @"style.draw.color": @"0x222222FF"
           , @"style.candles.candle_up": @"0x4C8214FF"
           , @"style.candles.candle_up_border": @"0x222222FF"
           , @"style.candles.candle_down": @"0xAC1D14FF"
           , @"style.candles.candle_down_border": @"0x222222FF"
           , @"style.bars.chart_bars_color": @"0x222222FF"
           , @"style.bars.chart_bars_color_up": @"0x4C8214FF"
           , @"style.bars.chart_bars_color_down": @"0xAC1D14FF"
           , @"style.main_line.color": @"0x2798ECFF"
           , @"style.area.area_fill_color": @"0x2798ECFF"
           , @"style.area.area_stroke_color": @"0x2798ECFF"
           } ];
}

+(id)greenScheme
{
   return [ self schemeWithProperties: @{
           @"style.chart_general.chart_bg_color": @"0xFFFFFF00"
           , @"style.chart_general.chart_frame_color": @"0x222222FF"
           , @"style.chart_general.chart_grid_color": @"0xAEB6BCFF"
           , @"style.chart_general.chart_margin_color": @"0xFFFFFF00"
           , @"style.chart_general.chart_font_color": @"0x222222FF"
           , @"style.chart_general.chart_cursor_color": @"0x222222FF"
           , @"style.chart_general.chart_cursor_textcolor": @"0x222222FF"
           , @"style.draw.color": @"0x222222FF"
           , @"style.candles.candle_up": @"0x4C8214FF"
           , @"style.candles.candle_up_border": @"0x222222FF"
           , @"style.candles.candle_down": @"0xFFFFFF00"
           , @"style.candles.candle_down_border": @"0x222222FF"
           , @"style.bars.chart_bars_color": @"0x222222FF"
           , @"style.bars.chart_bars_color_up": @"0x4C8214FF"
           , @"style.bars.chart_bars_color_down": @"0x222222FF"
           , @"style.main_line.color": @"0x4C8214FF"
           , @"style.area.area_fill_color": @"0x4C8214FF"
           , @"style.area.area_stroke_color": @"0x4C8214FF"
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
   return [ [ self schemesByType ] objectAtIndex: scheme_type_ ];
}

@end
