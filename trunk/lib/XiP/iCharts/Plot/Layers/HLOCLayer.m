

#import "HLOCLayer.h"
#import "CursorLayer.h"
#import "../../DataStores/BaseDataStore.h"
#import "../../ArrayMath.h"
#import "../FinanceChart.h"
#import "../Axis.h"
#import "../XYChart.h"
#import "../LegendBox.h"
#import "PropertiesStore.h"


@implementation HLOCLayer

@synthesize bar_color, bar_line_width;
@synthesize bar_color_up, bar_color_down;

- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart
{
    self  = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:@"none" LayerName:@"HLOC"];
    if(self  ==  nil)
        return self;
    
    PropertiesStore* style = _parentChart.parentFChart.properties;
    bar_color                = [style getColorParam:@"style.bars.chart_bars_color"];
    bar_line_width           = [style getUIntParam:@"style.bars.chart_bars_width"];
    bar_color_up             = [style getColorParam:@"style.bars.chart_bars_color_up"];
    bar_color_down           = [style getColorParam:@"style.bars.chart_bars_color_down"];
    return self;
}


-(double)getLowerDataValue
{    
    ArrayMath *v = [DataStore GetVector:@"lowData"];
    return [v min2:parentChart.startIndex AndLength:parentChart.range];
}

-(double)getUpperDataValue
{			
    ArrayMath *v = [DataStore GetVector:@"highData"];
    return [v max2:parentChart.startIndex AndLength:parentChart.range];
}



- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
{
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];

    int i = parentChart.endIndex;
    float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
    double bar_width_full = (rect.size.width - chart_grid_right_cellsize) / parentChart.parentFChart.duration;
    int bar_width = bar_width_full;
    if(bar_width_full>5)
        bar_width = bar_width_full*0.85;
    CGContextSetLineWidth(ctx, pen_1px*bar_line_width);
    if(bar_width/2 > CHART_GRID_CELLSIZE-5)
        bar_width = (CHART_GRID_CELLSIZE-5)*2;
    //if(bar_width%2==0)
    //    bar_width--;

    double* openData    = [[parentChart.DataStore GetVector:@"openData"] getData];
    double* closeData   = [[parentChart.DataStore GetVector:@"closeData"] getData];
    double* highData    = [[parentChart.DataStore GetVector:@"highData"] getData];
    double* lowData     = [[parentChart.DataStore GetVector:@"lowData"] getData];

    double open, close, high, low, y_close, y_open, y_high, y_low;
    uint cs_color;

    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(bar_color) CGColor]);
    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(bar_color) CGColor]);

    for (int up_bar=0; up_bar<2; up_bar++)
    {
        double last_x_new = rect.origin.x + rect.size.width - chart_grid_right_cellsize;
        double last_x;

        cs_color = (up_bar) ? bar_color_up :bar_color_down;

        CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(cs_color) CGColor]);
        CGContextSetFillColorWithColor(ctx, [HEXCOLOR(cs_color) CGColor]);

        while (i >=parentChart.startIndex)
        {
            open     = openData[i];
            close    = closeData[i];

            last_x_new = rect.origin.x + rect.size.width -
            chart_grid_right_cellsize + (i-parentChart.endIndex-1)*(bar_width_full);

            if (up_bar)
            {
                if (close <= open)
                {
                    i--;
                    continue;
                }
            }
            else
            {
                if (close > open)
                {
                    i--;
                    continue;
                }
            }

            high     = highData[i];
            low      = lowData[i];

            y_close  = [parentChart.yAxis getCoorValue:close];
            y_open  = [parentChart.yAxis getCoorValue:open];
            y_high  = [parentChart.yAxis getCoorValue:high];
            y_low  = [parentChart.yAxis getCoorValue:low];

            CGContextMoveToPoint(ctx, last_x_new, y_high);
            CGContextAddLineToPoint(ctx, last_x_new, y_low);

            CGContextMoveToPoint(ctx, last_x_new - bar_width/2, y_open);
            CGContextAddLineToPoint(ctx, last_x_new, y_open);

            CGContextMoveToPoint(ctx, last_x_new + bar_width/2, y_close);
            CGContextAddLineToPoint(ctx, last_x_new, y_close);
            
            i--;
        }
        CGContextStrokePath(ctx);
        i = parentChart.endIndex;
    }
}


-(void)setChartCursorValue:(uint)valueIndex
{
    ArrayMath* closeData = [DataStore GetVector:@"closeData"];
    ArrayMath* openData = [DataStore GetVector:@"openData"];
    double xValue = NAN;
    double yValue = NAN;
    double bar_width_full = NAN;
    if (closeData == nil || openData == nil)
        return;
    bar_width_full = (parentChart.parentFChart.xAxis.axis_rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / parentChart.range;
    xValue = layer_rect.origin.x  + (valueIndex+1) * bar_width_full ;
    
	int realIndex = parentChart.startIndex + valueIndex;
    double closeValue = [closeData getData][realIndex];
    double val = [self.parentChart.yAxis getCoorValue:closeValue];
    yValue = val;
	[parentChart.cursorLayer setChartCursorValue:layerName pX:xValue pY:yValue Index:valueIndex];
}


-(void)setLegendText:(int)globalIndex
{
    if (parentChart.legendBox == nil || globalIndex==-1) 
		return;
    ArrayMath* highData = [DataStore GetVector:@"highData"];
    ArrayMath* lowData = [DataStore GetVector:@"lowData"];
    ArrayMath* closeData = [DataStore GetVector:@"closeData"];
    ArrayMath* openData = [DataStore GetVector:@"openData"];
    
    if (highData == nil)
        return;
    
	if(globalIndex>=[openData getLength])
		globalIndex = [openData getLength]-1;
    int realIndex = globalIndex;
    double openPrice = [openData getData][realIndex];
    double closePrice = [closeData getData][realIndex];
    double highPrice = [highData getData][realIndex];
    double lowPrice = [lowData getData][realIndex];
    
	
	NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@(%@) H:%@, L:%@, O:%@, C:%@", 
                           parentChart.parentFChart.symbol,
                           [parentChart.parentFChart.chart_data getIntervalName],
                           [parentChart formatPrice:highPrice], 
                           [parentChart formatPrice:lowPrice], 
                           [parentChart formatPrice:openPrice], 
                           [parentChart formatPrice:closePrice]];
    
	[parentChart.legendBox setText:LegendMsg ForKey:legendKey];
	[LegendMsg autorelease];

}
@end
