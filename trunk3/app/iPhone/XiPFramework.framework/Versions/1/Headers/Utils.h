
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#ifndef HEXCOLOR
#define HEXCOLOR(c) [UIColor colorWithRed:(((c)>>24)&0xFF)/255.0 \
green:(((c)>>16)&0xFF)/255.0 \
blue:(((c)>>8)&0xFF)/255.0 \
alpha:(((c))&0xFF)/255.0]


#endif

//#define dummy

#define Round_05(x) 0.5*(float)((int)((x) / 0.5))
#define Pad_05(x) (truncf(x) - 0.5)

#define CHART_DEF_SETTINGS_FILENAME         @"chart_def_settings"

#define PROPERTY_TYPE_COLOR                 0
#define PROPERTY_TYPE_UINT                  1
#define PROPERTY_TYPE_LINE_WIDTH            2
#define PROPERTY_TYPE_LINE_DASH             3
#define PROPERTY_TYPE_APPLY_TO              4
#define PROPERTY_TYPE_BOOL                  5
#define PROPERTY_TYPE_DBL                   6




#define CHART_DASH_1                        {1, 1}
#define CHART_DASH_2                        {2, 2}
#define CHART_DASH_3                        {6, 2}
#define CHART_DASH_4                        {6, 2, 1, 2}


#define CHART_S_TEXTCOLOR                   0x000000FF
#define CHART_S_LEGENDTEXTCOLOR             0x000000FF
#define CHART_S_DRAW_COLOR                  0x000000FF
#define CHART_S_DEFAULT_ZOOM                50
#define CHART_S_SHOW_HGRID                  true
#define CHART_S_SHOW_VGRID                  true
#define CHART_S_GRID_DASH                   {3, 3}

#define CHART_GRID_CELLSIZE                 30.0
#define CHART_GRID_RIGHT_CELLSIZE           10.0 //change this value to increase the distance of the rightmost chart element with the axis
#define CHART_PADDING_TOP_BOTTOM            2.0
#define CHART_SPLITTER_GRIP_RADIUS          10.0
#define CHART_XAXIS_LABEL_PADDING           10.0
#define CHART_CURSOR_RADIUS                 2.0
#define CHART_CURSOR_RECT_PADDING           2.0
#define CHART_LEGEND_MARK_SIZE              6.0
#define CHART_TA_ANCHOR_SIZE                15.0
#define CHART_TA_ANCHOR_THRESHOLD           14.0

#define CHART_XAXIS_HEIGHT                  17.0
#define CHART_AXIS_TICK_LEN                 3.0

#define CHART_AXIS_HORIZONTAL               0
#define CHART_AXIS_VERTICAL                 1

#define CHART_TYPE_CANDLES                  0
#define CHART_TYPE_BARS                     1
#define CHART_TYPE_LINE                     2
#define CHART_TYPE_AREA                     3

#define CHART_MODE_NONE                     0
#define CHART_MODE_CROSSHAIR                1
#define CHART_MODE_SPLITTER                 2
#define CHART_MODE_RESIZE                   3
#define CHART_MODE_DELETE                   4
#define CHART_MODE_DRAW                     5

#define CHART_TA_THRESHOLD                  10
#define CHART_HT_NONE                       0
#define CHART_HT_OBJECT                     1
#define CHART_HT_ANCHOR                     2


#define CHART_DRAW_SEGMENT                  16
#define CHART_DRAW_LINE                     17  
#define CHART_DRAW_RAY                      18  
#define CHART_DRAW_CHANNEL                  19  
#define CHART_DRAW_FIB_RETR                 20
#define CHART_DRAW_FIB_CIRC                 21
#define CHART_DRAW_FIB_FAN                  22
#define CHART_DRAW_HLINE                    23
#define CHART_DRAW_VLINE                    24

typedef struct {
    int hueValue;
    int saturationValue;
    int brightnessValue;
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} HsvColor;

typedef struct {
    int redValue;
    int greenValue;
    int blueValue;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
} RgbColor;

#define COLOR_COMPONENT_RED_INDEX 0
#define COLOR_COMPONENT_GREEN_INDEX 1
#define COLOR_COMPONENT_BLUE_INDEX 2
#define COLOR_COMPONENT_SCALE_FACTOR 255.0f
#define COMPONENT_DOMAIN_DEGREES 60.0f
#define COMPONENT_MAXIMUM_DEGREES 360.0f
#define COMPONENT_OFFSET_DEGREES_GREEN 120.0f
#define COMPONENT_OFFSET_DEGREES_BLUE 240.0f
#define COMPONENT_PERCENTAGE 100.0f

extern uint chart_nes_colors[];

void SetContextLineDash(CGContextRef ctx, uint linedash);

@interface Utils : NSObject
{}

+ (float) getChartGridRightCellSize:(CGRect)chartFrame;
+ (float) getFontSize;
+ (float) getSmallFontSize;
+ (int) getMinZoom;
+ (int) getMaxZoom;
+ (double) getYAxisWidth;

+ (RgbColor)rgbColorFromColor:(UIColor *)color;
+ (HsvColor)hsvColorFromRgbColor:(RgbColor)color;
+ (HsvColor)hsvColorFromColor:(UIColor *)color;

@end
