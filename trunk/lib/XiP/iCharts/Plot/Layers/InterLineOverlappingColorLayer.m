//
//  InterLineOverlappingColorLayer.m
//  XiP
//
//  Created by Alexandros Ioannou on 3/23/12.
//  Copyright (c) 2012 Xogee. All rights reserved.
//

#import "InterLineOverlappingColorLayer.h"
#import "BaseDataStore.h"
#import "LegendBox.h"
#import "Utils.h"
#import "XYChart.h"
#import "FinanceChart.h"
#import "Axis.h"

@implementation InterLineOverlappingColorLayer

@synthesize mSpanAData, mSpanBData;
@synthesize fillAlpha, mSpanAColor, mSpanBColor, linedash, linewidth;

- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              SpanAData:(NSString*)spanAData
              SpanBData:(NSString*)spanBData 
              LayerName:(NSString*)_layerName
                SpanAColor:(uint)spanAColor
                SpanBColor:(uint)spanBColor
              FillAlpha:(uint)_alpha
              LineWidth:(uint)line_width
               LineDash:(uint)line_dash
{
    self = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:spanAData LayerName:_layerName];
    if(self == nil)
        return self;
    
    mSpanAData    = spanAData;  
    mSpanBData    = spanBData;
    
    mSpanAColor     = spanAColor;
    mSpanBColor     = spanBColor;
    fillAlpha   = _alpha;//0xFFFFFF4C;
    
    linedash    = line_dash;
    linewidth   = line_width;
    
    return self;
}

-(void)dealloc
{	
    if(mSpanAData!=nil)
        [mSpanAData release];
    if(mSpanBData!=nil)
        [mSpanBData release];
    [super dealloc];
}

-(double)getLowerDataValue
{
    ArrayMath *v1 = [DataStore GetVector:mSpanAData];
    float min1 = [v1 min2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:mSpanBData];
    float min2 = [v2 min2:parentChart.startIndex AndLength:parentChart.range];
    
    return MIN(min1 , min2);
}

-(double)getUpperDataValue
{			
    ArrayMath *v1 = [DataStore GetVector:mSpanAData];
    float max1 = [v1 max2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:mSpanBData];
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
    
    ArrayMath *spanAData		= [self.DataStore GetVector:mSpanAData];
	double *spanADataPointer			= [spanAData getData];
    ArrayMath *spanBData		= [self.DataStore GetVector:mSpanBData];
	double *spanBDataPointer			= [spanBData getData];
    
	double segmentWidth = NAN;
    int iIndex = 0;
	double x1 = NAN;
    double y1 = NAN;  
	float chart_grid_right_cellsize = [Utils getChartGridRightCellSize: parentChart.parentFChart.frame];
    double layerWidth = rect.size.width - chart_grid_right_cellsize;
	segmentWidth = layerWidth / parentChart.parentFChart.duration;
	double x0           = NAN;
	double y0           = NAN;
    double pixelValue   = [parentChart.yAxis getPixelValue];
    double topPadding   = [parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit];
	//if(lineData.symbolType==null)	 
	//{
    x1 = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;

    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    CGContextSetShouldAntialias(ctx, parentChart.parentFChart.duration<250);
    
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

    CGMutablePathRef spanALine =  CGPathCreateMutable();
    bool firstDraw = true;
	iIndex = parentChart.endIndex;
    while (iIndex >=parentChart.startIndex) 
    {
        double pointVal1 =  spanADataPointer[iIndex];
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
                    CGPathMoveToPoint(spanALine, nil, x0, y0);
                }
                CGPathAddLineToPoint(spanALine, nil, x1, y1);
            }
            x0=x1;
            y0=y1;
            x1-=segmentWidth;
        } 
        iIndex--;
    }
    
    CGMutablePathRef spanBLine =  CGPathCreateMutable();
    x1 = rect.origin.x + segmentWidth;
    firstDraw = true;
    iIndex = parentChart.startIndex;
    while (iIndex <= parentChart.endIndex) 
    {
        double pointVal2 = spanBDataPointer[iIndex];
        if (!isnan(pointVal2))
        {
            y1 = topPadding +  (parentChart.yAxis.upperLimit - pointVal2)*pixelValue;
            if(firstDraw)				
            {
                firstDraw = false;
                CGPathMoveToPoint(spanBLine, nil, x1, y1);
            }
            else
            {
                CGPathAddLineToPoint(spanBLine, nil, x1, y1);                
            }
        } 
        x1+=segmentWidth;
        iIndex++;
    }
    
    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(mSpanAColor) CGColor]);
    CGContextAddPath(ctx, spanALine);
    CGContextStrokePath(ctx);
    //CGPathRelease(spanALine);
    
    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(mSpanBColor) CGColor]);
    CGContextAddPath(ctx, spanBLine);
    CGContextStrokePath(ctx);
    //CGPathRelease(spanBLine);
    
    CGContextSetLineDash(ctx, 0, nil, 0);
    
    
    double clipLeft = rect.origin.x + segmentWidth;
    double clipRight = rect.origin.x + layerWidth;
    double clipTop = rect.origin.y;
    double clipBottom = rect.origin.y + rect.size.height;
    
    CGMutablePathRef spanBClip = CGPathCreateMutableCopy(spanALine);
    CGPathAddLineToPoint(spanBClip, nil, clipLeft, clipTop);
    CGPathAddLineToPoint(spanBClip, nil, clipRight, clipTop);
    CGPathCloseSubpath(spanBClip);
    
    CGPathAddLineToPoint(spanALine, nil, clipLeft, clipBottom);
    CGPathAddLineToPoint(spanALine, nil, clipRight, clipBottom);
    CGPathCloseSubpath(spanALine);
    
    CGMutablePathRef spanAClip = CGPathCreateMutableCopy(spanBLine);
    CGPathAddLineToPoint(spanAClip, nil, clipRight, clipTop);
    CGPathAddLineToPoint(spanAClip, nil, clipLeft, clipTop);
    CGPathCloseSubpath(spanAClip);
    
    CGPathAddLineToPoint(spanBLine, nil, clipRight, clipBottom);
    CGPathAddLineToPoint(spanBLine, nil, clipLeft, clipBottom);
    CGPathCloseSubpath(spanBLine);
    
    //draw spanA area color
    CGContextSaveGState(ctx);
    
    CGContextAddPath(ctx, spanBClip);
    CGContextClip(ctx);
    
    CGContextAddPath(ctx, spanBLine);
    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(mSpanBColor & fillAlpha) CGColor]);
    CGContextFillPath(ctx);
    
    CGPathRelease(spanBClip);
    CGPathRelease(spanBLine);
    
    
    CGContextRestoreGState(ctx);
    
    //draw spanB area color
    CGContextSaveGState(ctx);
    
    CGContextAddPath(ctx, spanAClip);
    CGContextClip(ctx);
    
    CGContextAddPath(ctx, spanALine);
    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(mSpanAColor & fillAlpha) CGColor]);
    CGContextFillPath(ctx);
    
    CGPathRelease(spanAClip);
    CGPathRelease(spanALine);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetShouldAntialias(ctx, false);	
}


-(void)setSpanAColor:(uint)spanAColor AndSpanBColor:(uint)spanBColor AndFillColor:(uint)_fillAlpha //default 0xFFFFFF4C
{
    self.mSpanAColor = spanAColor;
    self.mSpanBColor = spanBColor;
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
        if (mSpanAData != nil && mSpanBData != nil)
        {
            lineData1 = [DataStore GetVector:mSpanAData];
            lineData2 = [DataStore GetVector:mSpanBData];
            
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
                NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@: (%@,%@)", legendKey, valueText1, valueText2];
                
                [parentChart.legendBox setText:LegendMsg ForKey:legendKey];
                [LegendMsg autorelease];
            }
        }
    }
}

@end
