
#import "BarTrendLayer.h"
#import "BaseBoxLayer.h"
#import "FinanceChart.h"
#import "LegendBox.h"
#import "../../DataStores/BaseDataStore.h"
#import "XYChart.h"
#import "Axis.h"
#import "CursorLayer.h"

@implementation BarTrendLayer
@synthesize bar_width;


-(void)drawInContext:(CGContextRef)ctx 
              InRect:(CGRect)rect
              AndDPI:(double)pen_1px
{
    
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];

    ArrayMath* barData      = [self GetMainData];
    double* barDataRaw       = [barData getData];
    
    float bar_width_full = (rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / parentChart.parentFChart.duration;
    float barDtX = bar_width_full / 2;

    float last_x = rect.origin.x + rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
    double pixelValue = [parentChart.yAxis getPixelValue];
    float topPadding = Pad_05([parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit]);
    int iIndex = parentChart.endIndex;

    float y2 = NAN; 
    float y1 = NAN;
    
    CGColorRef c1 = [HEXCOLOR(color1) CGColor];
    CGColorRef c2 = [HEXCOLOR(color2) CGColor];
    
    bool drawBorder = parentChart.parentFChart.duration < 100;
    CGColorRef strokeC1;
    CGColorRef strokeC2;
    if (drawBorder)
    {
        HsvColor hsvColor1 = [Utils hsvColorFromColor:HEXCOLOR(color1)];
        hsvColor1.brightness *= 0.8f;  
        strokeC1 = [[UIColor colorWithHue:hsvColor1.hue saturation:hsvColor1.saturation brightness:hsvColor1.brightness alpha:1.0f] CGColor];
        
        HsvColor hsvColor2 = [Utils hsvColorFromColor:HEXCOLOR(color2)];
        hsvColor2.brightness *= 0.8f;
        strokeC2 = [[UIColor colorWithHue:hsvColor2.hue saturation:hsvColor2.saturation brightness:hsvColor2.brightness alpha:1.0f] CGColor];
    }
    while (iIndex >=self.parentChart.startIndex)
    {
        double barValue = barDataRaw[iIndex];
        if (!isnan(barValue))
        {
            y2 = topPadding + (parentChart.yAxis.upperLimit - barValue)*pixelValue;
            y1 = topPadding + (parentChart.yAxis.upperLimit - 0)*pixelValue;
            
            CGRect r = CGRectMake((last_x - barDtX), y1 > y2 ? y2 : y1, 
                                  (bar_width_full), fabsf(y2-y1));
            
            double previousBarValue = 0.0;
            int previousIndex = iIndex - 1;
            if (previousIndex > -1)
            {
                previousBarValue = barDataRaw[previousIndex];
            }
            BOOL valueIncresing = barValue > previousBarValue;
            CGColorRef color = valueIncresing ? c1 : c2;
            CGContextSetFillColorWithColor(ctx, color);
            CGContextFillRect(ctx, r);
            if (drawBorder) 
            {
                CGColorRef borderColor = valueIncresing ? strokeC1 : strokeC2;
                CGContextSetStrokeColorWithColor(ctx, borderColor);
                CGContextStrokeRect(ctx, r);
            }
        } 
        iIndex--;
        last_x -= bar_width_full;					
    }
}

@end
