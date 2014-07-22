
#import "DOTLayer.h"
#import "CursorLayer.h"
#import "../../DataStores/BaseDataStore.h"
#import "../../ArrayMath.h"
#import "../FinanceChart.h"
#import "../Axis.h"
#import "../XYChart.h"
#import "../LegendBox.h"
#import "PropertiesStore.h"


@implementation DOTLayer

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
{
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];
    
    CGContextSetShouldAntialias(ctx, true);
    int i = parentChart.endIndex;
    float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
    double bar_width_full = (rect.size.width - chart_grid_right_cellsize) / parentChart.parentFChart.duration;
//    int bar_width = bar_width_full;			
//    if(bar_width_full>5)
//        bar_width = bar_width_full*0.85;
//    if(bar_width/2 > CHART_GRID_CELLSIZE-5)
//        bar_width = (CHART_GRID_CELLSIZE-5)*2;
    //if(bar_width%2==0)
    //    bar_width--;
    double last_x = rect.origin.x + rect.size.width - chart_grid_right_cellsize;
    
    
    double* closeDataRaw    = [[parentChart.DataStore GetVector:@"closeData"] getData];
	ArrayMath *lineData		= [self GetMainData];
	if(lineData==nil)
		return;
	double *rawData			= [lineData getData];
    
    while (i >=parentChart.startIndex) 
    {
        double val     = rawData[i];
        double y_val    = [parentChart.yAxis getCoorValue:val];
        
        uint color = (closeDataRaw[i] > rawData[i]) ? color1 : color2;
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR(color) CGColor]); 
        CGContextFillRect(ctx, CGRectMake(last_x - CHART_CURSOR_RADIUS/2, 
                                          y_val - CHART_CURSOR_RADIUS/2, 
                                          CHART_CURSOR_RADIUS, 
                                          CHART_CURSOR_RADIUS));
                
        last_x = rect.origin.x + rect.size.width - 
                chart_grid_right_cellsize + (i-parentChart.endIndex-1)*(bar_width_full);
        i--;
    }
    CGContextSetShouldAntialias(ctx, false);
}
@end
