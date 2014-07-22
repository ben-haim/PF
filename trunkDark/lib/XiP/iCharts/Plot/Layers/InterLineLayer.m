

#import "InterLineLayer.h"
#import "BaseDataStore.h"
#import "LegendBox.h"
#import "Utils.h"
#import "XYChart.h"
#import "FinanceChart.h"
#import "Axis.h"

@implementation InterLineLayer
@synthesize srcField1, srcField2;
@synthesize fillAlpha, color12, color21, linecolor, linedash, linewidth;
@synthesize clip_level, clipAbove, mustClip;

- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              SrcField1:(NSString*)_srcField1
              SrcField2:(NSString*)_srcField2 
              LayerName:(NSString*)_layerName
              LineColor:(uint)_linecolor
                Color12:(uint)_color12
                Color21:(uint)_color21
              FillAlpha:(uint)_alpha
              LineWidth:(uint)line_width
               LineDash:(uint)line_dash
{
    self = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:_srcField1 LayerName:_layerName];
    if(self == nil)
        return self;
    
    srcField1    = _srcField1;  
    srcField2    = _srcField2;
    
    color12     = _color12;
    color21     = _color21;
    linecolor   = _linecolor;
    fillAlpha   = _alpha;//0xFFFFFF4C;
    
    linedash    = line_dash;
    linewidth   = line_width;
    
    mustClip    = false;
    clipAbove   = false;
    clip_level  = 0;
    return self;
}


-(double)getLowerDataValue
{
    ArrayMath *v1 = [DataStore GetVector:srcField1];
    float min1 = [v1 min2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:srcField2];
    float min2 = [v2 min2:parentChart.startIndex AndLength:parentChart.range];
    
    return MIN(min1 , min2);
}

-(double)getUpperDataValue
{			
    ArrayMath *v1 = [DataStore GetVector:srcField1];
    float max1 = [v1 max2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:srcField2];
    float max2 = [v2 max2:parentChart.startIndex AndLength:parentChart.range];
    
    return MAX(max1 , max2);
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px
{  
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];

    //if(((color12 & 0xFF)==0) && ((color21 & 0xFF)==0))
    //    return;
    
    ArrayMath *lineData1		= [self.DataStore GetVector:srcField1];
	double *rawData1			= [lineData1 getData];
    ArrayMath *lineData2		= [self.DataStore GetVector:srcField2];
	double *rawData2			= [lineData2 getData];
    
	double segmentWidth = NAN;
    int iIndex = 0;
	double x1 = NAN;
    double y1 = NAN;  
	float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
	segmentWidth = (rect.size.width - chart_grid_right_cellsize) / parentChart.parentFChart.duration;
	double x0           = NAN;
	double y0           = NAN;
    double pixelValue   = [parentChart.yAxis getPixelValue];
    double topPadding   = [parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit];
   
//	if ( isnan(topPadding) )
//      return;
	
    x1 = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
	
    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(color12 & fillAlpha) CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(linecolor) CGColor]);
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    CGContextSetShouldAntialias(ctx, parentChart.parentFChart.duration<250);
    
    CGMutablePathRef lines =  CGPathCreateMutable();
    
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
    bool firstDraw = true;
    

	iIndex = parentChart.endIndex;
    while (iIndex >=parentChart.startIndex) 
    {
        double pointVal1 =  rawData1[iIndex];
        if (!isnan(pointVal1))
        {
            y1 = 	//rect.origin.y + 
                    topPadding +  
                    (parentChart.yAxis.upperLimit - pointVal1)*pixelValue;
            
            if (iIndex != parentChart.endIndex) 
            { 
                if(firstDraw)				
                {
                    firstDraw = false;
                    CGPathMoveToPoint(lines, nil, x0, y0);
                    //CGContextMoveToPoint(ctx, x0, y0);
                }
                //CGContextAddLineToPoint(ctx, x1, y1);
                CGPathAddLineToPoint(lines, nil, x1, y1);
            }
            x0=x1;
            y0=y1;
            x1-=segmentWidth;
        } 
        iIndex--;
    }
    CGMutablePathRef fill = CGPathCreateMutableCopy(lines);
    
    x1 = rect.origin.x + segmentWidth;
    firstDraw = true;
    iIndex = parentChart.startIndex;
    while (iIndex <= parentChart.endIndex) 
    {
        double pointVal2 = rawData2[iIndex];
        if (!isnan(pointVal2))
        {
            y1 = 	//rect.origin.y + 
                    topPadding +  
                    (parentChart.yAxis.upperLimit - pointVal2)*pixelValue;
            
            //if (iIndex != parentChart.startIndex) 
            { 
                if(firstDraw)				
                {
                    firstDraw = false;
                    CGPathMoveToPoint(lines, nil, x1, y1);
                    //CGContextMoveToPoint(ctx, x0, y0);
                }
                else
                    CGPathAddLineToPoint(lines, nil, x1, y1);                
            }
           if(!isnan(y1))
            CGPathAddLineToPoint(fill, nil, x1, y1);
            //x0=x1;
            //y0=y1;
        } 
        x1+=segmentWidth;
        iIndex++;
    }
    CGContextAddPath(ctx, lines);
    CGContextStrokePath(ctx);
    CGPathRelease(lines);
    
    CGContextSaveGState(ctx);
    if(mustClip)
    {
        if(clipAbove)
        {
            CGContextClipToRect(ctx, CGRectMake(rect.origin.x + segmentWidth,
                                                topPadding, 
                                                rect.size.width - segmentWidth - chart_grid_right_cellsize, 
                                                (parentChart.yAxis.upperLimit - clip_level)*pixelValue - pen_1px 
                                            ));
        }
        else
        {
            CGContextClipToRect(ctx, CGRectMake(rect.origin.x + segmentWidth,
                                                topPadding + (parentChart.yAxis.upperLimit - clip_level)*pixelValue + pen_1px, 
                                                rect.size.width - segmentWidth - chart_grid_right_cellsize, 
                                                (clip_level - parentChart.yAxis.lowerLimit)*pixelValue 
                                                )); 
        }
    }
    CGContextAddPath(ctx, fill);
    CGContextFillPath(ctx);
    CGPathRelease(fill);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetShouldAntialias(ctx, false);	
    CGContextSetLineDash(ctx, 0, nil, 0);
	
    // }
    /*else
     {
     x1 = this.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
     iIndex = parentChart.endIndex;
     while (iIndex >=parentChart.startIndex) 
     {
     if (!isNaN(lineData[iIndex]))
     {
     y1 = 	this.y + 
     topPadding +  
     (parentChart.yAxis.upperLimit - lineData.data[iIndex])*pixelValue;
     
     
     this.parentChart.canvas.fillRect(new Rectangle( x1- lineData.symbolSize, 
     y1 - lineData.symbolSize, 
     lineData.symbolSize*2+1, 
     lineData.symbolSize*2+1),
     colors[1]);
     }
     x1-=segmentWidth;
     iIndex--;
     }
     } */
    //}

}


-(void)setFillColor:(uint)_color12 AndColor2:(uint)_color21 AndFillColor:(uint)_fillAlpha //default 0xFFFFFF4C
{
    self.color12 = _color12;
    self.color21 = _color21;
    self.fillAlpha = _fillAlpha;
}


-(void) setLegendText:(int)globalIndex
{
    ArrayMath* lineData1 = nil;
    ArrayMath* lineData2 = nil;
    double value1 = NAN;
    double value2 = NAN;
    if (parentChart.legendBox != nil)
    {
        if (srcField1 != nil && srcField1 != nil)
        {
            lineData1 = [DataStore GetVector:srcField1];
            lineData2 = [DataStore GetVector:srcField2];
            
            if (lineData1 != nil && lineData2 != nil &&
                globalIndex<[lineData1 getLength] &&
                globalIndex<[lineData2 getLength])
            {
                value1 = [lineData1 getData][globalIndex];  
                value2 = [lineData2 getData][globalIndex];
                
                NSString* valueText1 = [parentChart formatPrice:value1];
                if(isnan(value1))
                    valueText1 = @"";
                NSString* valueText2 = [parentChart formatPrice:value2];
                if(isnan(value2))
                    valueText2 = @"";
                NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@:(%@,%@)", legendKey, valueText1, valueText2];
                
                [parentChart.legendBox setText:LegendMsg ForKey:legendKey];
//                [LegendMsg autorelease];
            }
        }
    }
}



@end
