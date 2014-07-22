//
//  TAHLine.m
//  XiP
//
//  Created by Xogee MacBook on 07/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAHLine.h"
#import "TAAnchor.h"
#import "TALine.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"


@implementation TAHLine

-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndY1:(double)y1  
                AndColor:(uint)_color
            AndLineWidth:(uint)_linewidth 
             AndLineDash:(uint)_linedash
{
    self  = [super initWithParentChart:_parentChart 
                            AndColor:_color
                        AndLineWidth:_linewidth 
                         AndLineDash:_linedash];
    if(self == nil)
        return self;
    TAAnchor* p1 = [[TAAnchor alloc] initWithParentChart:_parentChart 
                                               AndObject:self 
                                                   Color:_color 
                                                  XIndex:x1_index 
                                                  YValue:y1];
    [anchors addObject:p1];  
    [p1 release]; 
    
    return self;
}

-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{	
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [self get_a2];	
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1
                                            AndLineDash:0];
    bool isRayVisible = [line1 isVisibleWithin:x_start And:x_end];
    
    [line1 release];
    return isRayVisible;
}


- (double)GetDistance:(CGPoint)p
{  	
    TAAnchor* a1 = [anchors objectAtIndex:0];	
    TAAnchor* a2 = [self get_a2];	
    
    
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1
                                            AndLineDash:0];
    double resDistance = [line1 GetDistance:p];
    
    [line1 release];
    return resDistance;
}

-(TAAnchor*)get_a2
{    
    TAAnchor* a1 = [anchors objectAtIndex:0];    
    return [[[TAAnchor alloc] initWithParentChart:parentChart 
                                        AndObject:self 
                                            Color:0x0 
                                           XIndex:a1.x_index>1?a1.x_index-1:a1.x_index+1 
                                           YValue:a1.y_value] 
            autorelease];
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{  	
    TAAnchor* a1 = [anchors objectAtIndex:0];	
    TAAnchor* a2 = [self get_a2];
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:color   
                                           AndLineWidth:linewidth
                                            AndLineDash:linedash];
    
    [line1 drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:CHART_MODE_NONE];    
    [line1 release];
    
    
    //setup the font
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(color).CGColor);
    
    //draw text
    NSString *PriceStr = [parentChart formatPrice:a1.y_value];        
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, true);
    [PriceStr drawAtPoint:CGPointMake([parentChart.parentFChart.xAxis XIndexToX:parentChart.startIndex], [parentChart.yAxis getCoorValue:a1.y_value] - 2*pen_1px) withFont:font];    
    CGContextSetShouldAntialias(ctx, false);
    CGContextRestoreGState(ctx);
    
    [a1 drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
}@end
