//
//  ArrowsLayer.m
//  XiP
//
//  Created by Alexandros Ioannou on 3/23/12.
//  Copyright (c) 2012 Xogee. All rights reserved.
//

#import "ArrowsLayer.h"
#import "BaseDataStore.h"
#import "LegendBox.h"
#import "Utils.h"
#import "XYChart.h"
#import "FinanceChart.h"
#import "Axis.h"

@implementation ArrowsLayer

@synthesize mUpData, mDownData;
@synthesize mUpArrowsColor, mDownArrowsColor;

- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
                 UpData:(NSString*)upData
               DownData:(NSString*)downData 
              LayerName:(NSString*)_layerName
          UpArrowsColor:(uint)upArrowsColor
        DownArrowsColor:(uint)downArrowsColor
{
    self = [super initWithDataStore:_DataStore ParentChart:_parentChart SrcField:upData LayerName:_layerName];
    if(self == nil)
        return self;
    
    mUpData    = upData;  
    mDownData    = downData;
    
    mUpArrowsColor     = upArrowsColor;
    mDownArrowsColor     = downArrowsColor;
    
    return self;
}

-(void)dealloc
{	
    if(mUpData!=nil)
        [mUpData release];
    if(mDownData!=nil)
        [mDownData release];
    [super dealloc];
}

-(double)getLowerDataValue
{
    ArrayMath *v1 = [DataStore GetVector:mUpData];
    float min1 = [v1 min2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:mDownData];
    float min2 = [v2 min2:parentChart.startIndex AndLength:parentChart.range];
    
    double minValue = MIN(min1 , min2);
    double yCoord = [parentChart.yAxis getCoorValue:minValue];
    if (yCoord > 0)
    {
        minValue = [parentChart.yAxis coorToValue:(yCoord + 10)];
    }
    return minValue;
}

-(double)getUpperDataValue
{			
    ArrayMath *v1 = [DataStore GetVector:mUpData];
    float max1 = [v1 max2:parentChart.startIndex AndLength:parentChart.range];
    
    ArrayMath *v2 = [DataStore GetVector:mDownData];
    float max2 = [v2 max2:parentChart.startIndex AndLength:parentChart.range];
    
    double maxValue = MAX(max1 , max2);
    double yCoord = [parentChart.yAxis getCoorValue:maxValue];
    if (yCoord > 0)
    {
        double otherUpper = [parentChart.yAxis coorToValue:(yCoord + 10)];
        maxValue += maxValue - otherUpper;
    }
    return maxValue;
}

-(void) setLegendText:(int)globalIndex
{
    ArrayMath* upData = nil;
    ArrayMath* downData = nil;
    double upValue = NAN;
    double downValue = NAN;
    if (parentChart.legendBox != nil)
    {
        if (mUpData != nil && mDownData != nil)
        {
            upData = [DataStore GetVector:mUpData];
            downData = [DataStore GetVector:mDownData];
            
            if (upData != nil && downData != nil &&
                globalIndex < [upData getLength] &&
                globalIndex < [downData getLength])
            {
                upValue = [upData getData][globalIndex];  
                downValue = [downData getData][globalIndex];
                
                NSString* upValueText = [parentChart formatPrice:upValue];
                if(isnan(upValue))
                {
                    upValueText = @"";
                }
                NSString* downValueText = [parentChart formatPrice:downValue];
                if(isnan(downValue))
                {
                    downValueText = @"";
                }
                NSString *LegendMsg = [[NSString alloc] initWithFormat:@"%@: %@ / %@", legendKey, upValueText, downValueText];
                
                [parentChart.legendBox setText:LegendMsg ForKey:legendKey];
                [LegendMsg autorelease];
            }
        }
    }
}

-(void)drawInContext:(CGContextRef)ctx 
              InRect:(CGRect)rect
			  AndDPI:(double)pen_1px
{
	[super drawInContext:ctx InRect:rect AndDPI:pen_1px];
    
    ArrayMath *upData		= [self.DataStore GetVector:mUpData];
	double *upDataPointer			= [upData getData];
    ArrayMath *downData		= [self.DataStore GetVector:mDownData];
	double *downDataPointer			= [downData getData];
    
	if(upData == nil || downData == nil)
    {
		return;
    }
	double segmentWidth = NAN;
    int iIndex = 0;
	double x = NAN;
    double y = NAN; 
	
	segmentWidth = (rect.size.width - [Utils getChartGridRightCellSize: parentChart.parentFChart.frame]) / parentChart.parentFChart.duration;
	iIndex = parentChart.endIndex;
    double pixelValue = [parentChart.yAxis getPixelValue];
    double topPadding = [parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit];
    
    x = rect.origin.x + (parentChart.endIndex - parentChart.startIndex) * segmentWidth + segmentWidth;
	
    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(color1) CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(color1) CGColor]);
    //CGContextSetLineWidth(ctx, 1*pen_1px);
    //CGContextSetShouldAntialias(ctx, parentChart.parentFChart.duration<250);			
	
    //SetContextLineDash(ctx, linedash);
    
    while (iIndex >=parentChart.startIndex) 
    {
        //up arrows
        if (iIndex < [upData getLength])
        {
            double upVal = upDataPointer[iIndex];
            if (!isnan(upVal))
            {
                y = topPadding + (parentChart.yAxis.upperLimit - upVal)*pixelValue;                
                if (iIndex != parentChart.endIndex) 
                {
                    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(mUpArrowsColor) CGColor]);
                    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(mUpArrowsColor) CGColor]);
                    
                    CGMutablePathRef upArrow =  CGPathCreateMutable();
                    CGPathMoveToPoint(upArrow, nil, x, y - 10);
                    CGPathAddLineToPoint(upArrow, nil, x + 4, y - 2);
                    CGPathAddLineToPoint(upArrow, nil, x, y - 5);
                    CGPathAddLineToPoint(upArrow, nil, x - 4, y - 2);
                    
                    CGContextAddPath(ctx, upArrow);
                    CGContextFillPath(ctx);
                    CGPathRelease(upArrow);
                }
            }
        }
        
        //down arrows
        if (iIndex < [downData getLength])
        {
            double downVal = downDataPointer[iIndex];
            if (!isnan(downVal))
            {
                y = topPadding + (parentChart.yAxis.upperLimit - downVal)*pixelValue;                
                if (iIndex != parentChart.endIndex) 
                {
                    CGContextSetFillColorWithColor(ctx, [HEXCOLOR(mDownArrowsColor) CGColor]);
                    CGContextSetStrokeColorWithColor(ctx, [HEXCOLOR(mDownArrowsColor) CGColor]);
                    
                    CGMutablePathRef downArrow =  CGPathCreateMutable();
                    CGPathMoveToPoint(downArrow, nil, x, y + 10);
                    CGPathAddLineToPoint(downArrow, nil, x + 4, y + 2);
                    CGPathAddLineToPoint(downArrow, nil, x, y + 5);
                    CGPathAddLineToPoint(downArrow, nil, x - 4, y + 2);
                    
                    CGContextAddPath(ctx, downArrow);
                    CGContextFillPath(ctx);
                    CGPathRelease(downArrow);
                }
            }
        }
        
        x-=segmentWidth;
        
        iIndex--;
    }
    CGContextSetShouldAntialias(ctx, false);	
    CGContextSetLineDash(ctx, 0, nil, 0);
}


@end
