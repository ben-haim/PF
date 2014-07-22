

#import "AreaLayer.h"
#import "BaseBoxLayer.h"
#import "FinanceChart.h"
#import "LegendBox.h"
#import "../../DataStores/BaseDataStore.h"
#import "XYChart.h"
#import "Axis.h"
#import "CursorLayer.h"
#import "PropertiesStore.h"


@implementation AreaLayer
@synthesize fillcolor, linecolor, linewidth, linedash;


- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart
               SrcField:(NSString*)_srcField LayerName:(NSString*)_layerName
{
    self = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:_srcField LayerName:_layerName];
    if(self == nil)
        return self;
    
    PropertiesStore* style = _parentChart.parentFChart.properties;
    fillcolor              = [style getColorParam:@"style.area.area_fill_color"];
    linecolor              = [style getColorParam:@"style.area.area_stroke_color"];                   
    linewidth              = [style getUIntParam:@"style.area.area_stroke_width"];                  
    linedash               = [style getUIntParam:@"style.area.area_stroke_dash"];
    return self;
}

-(void)drawInContext:(CGContextRef)ctx 
              InRect:(CGRect)rect
			  AndDPI:(double)pen_1px
{
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];

	ArrayMath *lineData		= [self GetMainData];
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
	//if(lineData.symbolType==null)	 
	//{
            x1 = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
	
			CGContextSetFillColorWithColor(ctx, [HEXCOLOR(fillcolor & 0xFFFFFF55) CGColor]);
			CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(linecolor) CGColor]);
			CGContextSetLineWidth(ctx, linewidth*pen_1px);
			CGContextSetShouldAntialias(ctx, true);
			
			switch (linedash) 
			{
				case 1:
					{
						CGFloat dashLengths[] = CHART_DASH_1;
						CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
					}
					break;
					case 2:
					{
						CGFloat dashLengths[] = CHART_DASH_2;
						CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
					}
						break;
					case 3:
					{
						CGFloat dashLengths[] = CHART_DASH_3;
						CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
					}
						break;
					case 4:
					{
						CGFloat dashLengths[] = CHART_DASH_4;
						CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
					}
						break;
					
				default:
					break;
			}
            //fill area
            CGContextMoveToPoint(ctx, 
                                    rect.origin.x+segmentWidth, 
                                    2*topPadding + (parentChart.yAxis.upperLimit - parentChart.yAxis.lowerLimit)*pixelValue);
            CGContextAddLineToPoint(ctx, 
                                    x1, 
                                    2*topPadding + (parentChart.yAxis.upperLimit - parentChart.yAxis.lowerLimit)*pixelValue);
            while (iIndex >=parentChart.startIndex) 
            {
				double pointVal = rawData[iIndex];
                if (!isnan(pointVal))
                {
                    y1 = 	//rect.origin.y + 
                    topPadding +  
                    (parentChart.yAxis.upperLimit - pointVal)*pixelValue;
                    
                    CGContextAddLineToPoint(ctx, x1, y1);
                    
                    x0=x1;
                    y0=y1;
                    x1-=segmentWidth;
                } 
                iIndex--;
            }
            //CGContextFillPath(ctx);
            // Create a gradient from white to red
            CGFloat colors [] = { 
                                    (((fillcolor)>>24)&0xFF)/255.0, (((fillcolor)>>16)&0xFF)/255.0, (((fillcolor)>>8)&0xFF)/255.0, (((fillcolor))&0xFF)/255.0,
                                    (((fillcolor)>>24)&0xFF)/255.0, (((fillcolor)>>16)&0xFF)/255.0, (((fillcolor)>>8)&0xFF)/255.0, (((fillcolor))&0)/255.0,
                                };

            
            CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
            CGColorSpaceRelease(baseSpace);
            baseSpace = NULL;
    
            CGContextSaveGState(ctx);
            //CGContextAddEllipseInRect(context, rect);
            CGContextClip(ctx);
            
            CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
            
            CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
            CGGradientRelease(gradient);
            gradient = NULL;
            
            CGContextRestoreGState(ctx);
    
    
    
    
            
            //draw line
            x1 = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
            iIndex = parentChart.endIndex;
            bool firstDraw = true;
            while (iIndex >=parentChart.startIndex) 
            {
				double pointVal = rawData[iIndex];
                if (!isnan(pointVal))
                {
                    y1 = 	//rect.origin.y + 
							topPadding +  
							(parentChart.yAxis.upperLimit - pointVal)*pixelValue;
                    
                    if (iIndex != parentChart.endIndex) 
                    { 
						if(firstDraw)				
						{
							firstDraw = false;
							CGContextMoveToPoint(ctx, x0, y0);
						}
                        CGContextAddLineToPoint(ctx, x1, y1);	                        
                    }
                    x0=x1;
                    y0=y1;
                    x1-=segmentWidth;
                } 
                iIndex--;
            }
			CGContextStrokePath(ctx);
    
    
			CGContextSetShouldAntialias(ctx, false);	
			CGContextSetLineDash(ctx, 0, nil, 0);    
}


@end
