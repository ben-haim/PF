
#import "LineLayer.h"
#import "BaseBoxLayer.h"
#import "FinanceChart.h"
#import "LegendBox.h"
#import "../../DataStores/BaseDataStore.h"
#import "XYChart.h"
#import "Axis.h"
#import "CursorLayer.h"


@implementation LineLayer
@synthesize subtype, linewidth, linedash;

-(void)drawInContext:(CGContextRef)ctx 
              InRect:(CGRect)rect
			  AndDPI:(double)pen_1px
{
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];
	ArrayMath *lineData		= [self GetMainData];
	if(lineData==nil)
		return;
	double *rawData			= [lineData getData];
	double segmentWidth = NAN;
    int iIndex = 0;
	double x1 = NAN;
    double y1 = NAN; 
	
	segmentWidth = (rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / parentChart.parentFChart.duration;
	iIndex = parentChart.endIndex;
	double x0  = NAN;
	double y0 = NAN;
    double pixelValue = [parentChart.yAxis getPixelValue];
    double topPadding = [parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit];
	
	x1 = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
	
	CGContextSetFillColorWithColor(ctx, [HEXCOLOR(color1) CGColor]);
	CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(color1) CGColor]);
	CGContextSetLineWidth(ctx, linewidth*pen_1px);
	CGContextSetShouldAntialias(ctx, parentChart.parentFChart.duration<250);			
	
	SetContextLineDash(ctx, linedash);
	
	bool firstDraw = true;
	
	while (iIndex >=parentChart.startIndex) 
	{
		double pointVal = rawData[iIndex];
		if (!isnan(pointVal))
		{
			y1 = topPadding + (parentChart.yAxis.upperLimit - pointVal)*pixelValue;
			if (iIndex != parentChart.endIndex) 
			{ 
				if(firstDraw)				
				{
					if (isnan(x0) || isnan(y0))
					{
						x0=x1;
						y0=y1;
					}
					firstDraw = false;
					CGContextMoveToPoint(ctx, x0, y0);// draw lines fix (like interLineLayer)
				}
				else 
				{
					CGContextAddLineToPoint(ctx, x1, y1);
				}					                        
			}                   
		} 
		x0=x1; 
		y0=y1;
		x1-=segmentWidth;
		
		iIndex--;
	}
	CGContextStrokePath(ctx);
	CGContextSetShouldAntialias(ctx, false);	
	CGContextSetLineDash(ctx, 0, nil, 0);
}

@end
