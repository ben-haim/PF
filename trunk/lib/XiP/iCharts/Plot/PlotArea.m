
#import "PlotArea.h"
#import "Axis.h"
#import "XYChart.h"
#import "FinanceChart.h"
#import "PropertiesStore.h"
#import "TAOrderLevel.h"
#import "Utils.h"


@implementation PlotArea
@synthesize parentChart, parentFChart, plot_rect;

-(id)initWithChart:(XYChart*)_parentChart
      AndContainer:(FinanceChart*)_parentFChart
{    
    if(!(self = [super init]))
        return self;   
    self.parentChart = _parentChart;
    self.parentFChart = _parentFChart;
    return self;
}

-(void)dealloc
{	
	[super dealloc];
}

- (void)drawInContext:(CGContextRef)ctx
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
DrawPositionAndOrders:(BOOL) isPosOrdDraw
{
    plot_rect = rect;
    PropertiesStore* style = self.parentFChart.properties;
    //    CGColorRef clrPlotBG = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_bg_color"]) CGColor];
    CGColorRef clrFrame = [HEXCOLOR([style getColorParam:@"style.chart_general.chart_frame_color"]) CGColor];
    //    CGContextSetFillColorWithColor(ctx, clrPlotBG);
    CGContextSetStrokeColorWithColor(ctx, clrFrame);
    CGContextSetLineWidth(ctx, pen_1px);
    //   CGContextAddRect( ctx, plot_rect);
    //   CGContextDrawPath( ctx, kCGPathFill);
    CGContextAddRect( ctx, plot_rect);
	CGContextDrawPath( ctx, kCGPathStroke);

    if (!isPosOrdDraw)
    {
        CGFloat dashLengths[] = CHART_S_GRID_DASH;

        if (CHART_S_SHOW_HGRID || CHART_S_SHOW_VGRID)
        {
            CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR([style getColorParam:@"style.chart_general.chart_grid_color"]) CGColor]);
            CGContextSetLineWidth(ctx, pen_1px);
            CGContextSetLineDash(ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }

        if(CHART_S_SHOW_VGRID)
        {
            double x_;
            for (NSNumber* xcoord in self.parentChart.parentFChart.xAxis.tickPositions)
            {
                x_ = [xcoord doubleValue];

                if ( isnan( x_ ) )
                    continue;

                CGContextMoveToPoint(   ctx, x_, plot_rect.origin.y + pen_1px);
                CGContextAddLineToPoint(ctx, x_, plot_rect.origin.y + plot_rect.size.height - pen_1px);
            }
        }

        if(CHART_S_SHOW_HGRID)
        {
            double y_;

            for (NSNumber* ycoord in self.parentChart.yAxis.tickPositions)
            {
                y_ = [ycoord doubleValue];

                CGContextMoveToPoint(   ctx, plot_rect.origin.x, y_);
                CGContextAddLineToPoint(ctx, plot_rect.origin.x + plot_rect.size.width, y_);
            }
        }

        if (CHART_S_SHOW_HGRID || CHART_S_SHOW_VGRID)
        {
            CGContextStrokePath(ctx);
            CGContextSetLineDash(ctx, 0, nil, 0);
        }
    }
    else
    {
        if(parentChart == parentChart.parentFChart.mainChart)
        {
            //if([style getBoolParam:@"style.annotations.show_orders"])//show orders
            {
                NSMutableArray *orders = [parentFChart getOrderLevelsBetween:parentChart.yAxis.lowerLimit
                                                                         And:parentChart.yAxis.upperLimit];
                if([orders count]>0)
                {
                    //setup the font
                    UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
                    CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
                    CGContextSetTextMatrix(ctx, myTextTransform);
                    CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getSmallFontSize], kCGEncodingMacRoman);
                    //CGContextSetTextDrawingMode(ctx, kCGTextFill);
                    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);

                    CGContextSetStrokeColorWithColor(ctx, [ [ UIColor colorWithRed: 39.f / 255 green: 152.f / 255 blue: 236.f / 255 alpha: 1.f ] CGColor ]);
                    CGContextSetFillColorWithColor(ctx, [ [ UIColor colorWithRed: 39.f / 255 green: 152.f / 255 blue: 236.f / 255 alpha: 1.f ] CGColor ]);

                    for (TAOrderLevel* ol in orders)
                    {
                        if ( ol.isOrder )
                            SetContextLineDash(ctx, 4);
                        else
                            CGContextSetLineDash(ctx, 0, nil, 0);

                        double y_level = [parentChart.yAxis getCoorValue:ol.price];
                        double x_start = [parentChart.parentFChart.xAxis XIndexToX:parentChart.startIndex];
                        //fill text rectangle
                        //                      CGContextSetFillColorWithColor(ctx, clrPlotBG);
                        //                      CGContextFillRect(ctx, CGRectMake(x_start,
                        //                                                        y_level - font.capHeight,
                        //                                                        parentChart.yAxis.axis_rect.size.width*2,
                        //                                                        font.capHeight));

                        CGContextMoveToPoint(   ctx,
                                             plot_rect.origin.x+1*pen_1px,
                                             y_level);
                        CGContextAddLineToPoint(ctx,
                                                plot_rect.origin.x + plot_rect.size.width + CHART_AXIS_TICK_LEN,
                                                y_level);

                        //draw text
                        CGContextSetFillColorWithColor(ctx, clrFrame);

                        NSString *orderString = [NSString stringWithFormat:@"#%u %s", ol.order_no, (ol.cmd==0)?"buy":"sell"];
                        CGContextSaveGState(ctx);
                        CGContextSetShouldAntialias(ctx, true);
                        CGContextShowTextAtPoint(ctx,
                                                 x_start,
                                                 y_level- pen_1px*2,
                                                 [orderString UTF8String],
                                                 strlen([orderString UTF8String]));
                        CGContextSetShouldAntialias(ctx, false);
                        CGContextRestoreGState(ctx);
                    }
                    CGContextStrokePath(ctx);
                    CGContextSetLineDash(ctx, 0, nil, 0);
                }
            }
            float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentFChart.frame];
            if(parentChart.endIndex == [parentChart.DataStore GetLength]-1)
            {
                //draw last price
                HLOCDataSource *ds = parentFChart.chart_data;
                if([style getBoolParam:@"style.annotations.show_ask"])
                {
                    double ask = ds.last_ask;
                    double y_ask = [parentChart.yAxis getCoorValue:ask];//(topPadding + (topValue-bid)*pixelValue);

                    CGColorRef lineColor = [HEXCOLOR([style getColorParam:@"style.annotations.chart_ask_color"]) CGColor];
                    CGContextSetStrokeColorWithColor(ctx, lineColor);
                    CGContextSetLineWidth(ctx, pen_1px);

                    CGContextMoveToPoint(   ctx,
                                         plot_rect.origin.x + plot_rect.size.width - chart_grid_right_cellsize,
                                         y_ask);
                    CGContextAddLineToPoint(ctx,
                                            plot_rect.origin.x + plot_rect.size.width + CHART_AXIS_TICK_LEN,
                                            y_ask);
                    CGContextStrokePath(ctx);
                }
                if([style getBoolParam:@"style.annotations.show_bid"])
                {
                    double bid = ds.last_bid;
                    double y_bid = [parentChart.yAxis getCoorValue:bid];//(topPadding + (topValue-bid)*pixelValue);

                    if ( !isnan( y_bid ) )
                    {
                        CGColorRef lineColor = [HEXCOLOR([style getColorParam:@"style.annotations.chart_bid_color"]) CGColor];
                        CGContextSetStrokeColorWithColor(ctx, lineColor);
                        CGContextSetLineWidth(ctx, pen_1px);

                        CGContextMoveToPoint(   ctx,
                                             plot_rect.origin.x + plot_rect.size.width - chart_grid_right_cellsize,
                                             y_bid);
                        CGContextAddLineToPoint(ctx,
                                                plot_rect.origin.x + plot_rect.size.width + CHART_AXIS_TICK_LEN,
                                                y_bid);
                        CGContextStrokePath(ctx);
                    }
                }
            }
        }
    }
}

@end
