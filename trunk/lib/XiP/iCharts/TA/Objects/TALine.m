//
//  TALine.m
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TALine.h"
#import "TAAnchor.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"

@implementation TALine
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndX2:(int)x2_index 
                   AndY1:(double)y1  
                   AndY2:(double)y2  
                AndColor:(uint)_color
            AndLineWidth:(uint)_linewidth 
             AndLineDash:(uint)_linedash
{
    self = [super initWithParentChart:_parentChart 
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
    TAAnchor* p2 = [[TAAnchor alloc] initWithParentChart:_parentChart 
                                               AndObject:self 
                                                   Color:_color 
                                                  XIndex:x2_index 
                                                  YValue:y2];
    [anchors addObject:p2];
    [p1 release];
    [p2 release];
    return self;
}

-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{			
    CGPoint p1 = [self getP1];
    CGPoint p2 = [self getP2];
    
    double xa = p1.x;
    //double ya = p1.y;
    double xb = p2.x;
   // double yb = p2.y;			
    
    if(xa==xb)
        return true;
    
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    double k = (a2.y_value-a1.y_value)/(a2.x_index-a1.x_index);
    double l = (a1.y_value*a2.x_index - a2.y_value*a1.x_index)/(a2.x_index-a1.x_index);
    
    double y_left = [parentChart.yAxis getCoorValue:(x_start*k + l)];
    double y_right = [parentChart.yAxis getCoorValue:(x_end*k + l)];
    
    return MAX(y_left, y_right)>=0 && 
            MIN(y_left, y_right) - parentChart.plotArea.plot_rect.origin.y < parentChart.plotArea.plot_rect.size.height;
}

- (double)GetDistance:(CGPoint)p
{
    //|(x2 -x1)(y1-y0) - (x1-x0)(y2-y1)| / sqrt((x2-x1)^2 + (y2-y1)^2)
    
    CGPoint p1 = [self getP1];
    CGPoint p2 = [self getP2];
    
    double xa = p1.x;
    double ya = p1.y;
    double xb = p2.x;
    double yb = p2.y;
    double xp = p.x; 
    double yp = p.y;
    
    return fabs( ( xp * ( ya - yb ) + yp * ( xb - xa ) + ( xa * yb - xb * ya ) ) / sqrt((xb-xa)*(xb-xa) + (yb-ya)*(yb-ya)) );
}



-(CGPoint)getP1
{
    TAAnchor* p1 = [anchors objectAtIndex:0];
    TAAnchor* p2 = [anchors objectAtIndex:1];
    double x1 = p1.x_coord;
    double y1 = p1.y_coord;
    double k = (p2.y_value-p1.y_value)/(p2.x_index-p1.x_index);
    double l = (p1.y_value*p2.x_index - p2.y_value*p1.x_index)/(p2.x_index-p1.x_index);
    
    
    if(p1.x_index<parentChart.parentFChart.startIndex)//if we went out of the screen left
    {			
        x1 = [parentChart.parentFChart.xAxis XIndexToX:parentChart.parentFChart.startIndex];
        double x1p = parentChart.parentFChart.startIndex;
        y1 = [parentChart.yAxis getCoorValue:(k*x1p + l)];
    }
    
    if(p1.x_index>=parentChart.parentFChart.startIndex + parentChart.parentFChart.duration)//if we went out of the screen right
    {	
        x1 = [parentChart.parentFChart.xAxis XIndexToX:(parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 1)];
        double x1p = (parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 1);
        y1 = [parentChart.yAxis getCoorValue:(k*x1p + l)];
    }
    return CGPointMake(x1, y1);
}

-(CGPoint)getP2
{
    TAAnchor* p1 = [anchors objectAtIndex:0];
    TAAnchor* p2 = [anchors objectAtIndex:1];
    double x2 = p2.x_coord;
    double y2 = p2.y_coord;
    double k = (p2.y_value-p1.y_value)/(p2.x_index-p1.x_index);
    double l = (p1.y_value*p2.x_index - p2.y_value*p1.x_index)/(p2.x_index-p1.x_index);
    double x2p = NAN;
    
    if(p2.x_index<parentChart.parentFChart.startIndex)//if we went out of the screen left
    {			
        x2 = [parentChart.parentFChart.xAxis XIndexToX:(parentChart.parentFChart.startIndex+1)];
        x2p = parentChart.parentFChart.startIndex+1;
        y2 = [parentChart.yAxis getCoorValue:(k*x2p + l)];
    }
    
    if(p2.x_index>=parentChart.parentFChart.startIndex + parentChart.parentFChart.duration)//if we went out of the screen right
    {	
        x2 = [parentChart.parentFChart.xAxis XIndexToX:(parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 2)];
        x2p = (parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 2);
        y2 = [parentChart.yAxis getCoorValue:(k*x2p + l)];
    }    
    return CGPointMake(x2, y2);
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    double k = (a2.y_value-a1.y_value) / (a2.x_index-a1.x_index);
    double l = (a1.y_value*a2.x_index - a2.y_value*a1.x_index)/(a2.x_index-a1.x_index);
    
    double i_start = parentChart.startIndex;
    double i_end = parentChart.startIndex + parentChart.parentFChart.duration - 1;
    
    double x_left = [parentChart.parentFChart.xAxis XIndexToX:i_start];
    double x_right = [parentChart.parentFChart.xAxis XIndexToX:i_end];
    double y_left = [parentChart.yAxis getCoorValue:(i_start*k + l)];
    double y_right = [parentChart.yAxis getCoorValue:(i_end*k + l)];
    
    if(a2.x_index==a1.x_index)//90 degrees line
    {				
        x_left = x_right = [parentChart.parentFChart.xAxis XIndexToX:( a2.x_index)];
        y_left = [parentChart.yAxis getCoorValue:parentChart.yAxis.upperLimit];
        y_right = [parentChart.yAxis getCoorValue:parentChart.yAxis.lowerLimit];        
    }
    if ((int) y_left == (int) y_right || (int) x_left == (int) x_right) 
    {
        CGContextSetShouldAntialias(ctx, false);
    }   
    else
    {
        CGContextSetShouldAntialias(ctx, true);
    }
    CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(color).CGColor);
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    SetContextLineDash(ctx, linedash);
    CGContextMoveToPoint(ctx, x_left, y_left);
    CGContextAddLineToPoint(ctx, x_right, y_right);
    CGContextStrokePath(ctx);
	
    CGContextSetShouldAntialias(ctx, false);
    CGContextSetLineDash(ctx, 0, nil, 0);
    for (TAAnchor* a in anchors)
    {
        [a drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
    }   
}
@end
