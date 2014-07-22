//
//  TASegment.m
//  XiP
//
//  Created by Xogee MacBook on 04/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TASegment.h"
#import "TAAnchor.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"


@implementation TASegment

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
    return self;
}


-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{	 
    TAAnchor *p1 = anchors[0];
    TAAnchor *p2 = anchors[1];
    
    return !(MAX(p1.x_index, p2.x_index)<x_start ||  
             MIN(p1.x_index, p2.x_index)>x_end);
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
    
    
    double xu = xp - xa;
    double yu = yp - ya;
    double xv = xb - xa;
    double yv = yb - ya;
    
    if (xu * xv + yu * yv < 0)
        return sqrt( (xp-xa)*(xp-xa) + (yp-ya)*(yp-ya));
    
    xu = xp - xb;
    yu = yp - yb;
    xv = -xv;
    yv = -yv;
    if (xu * xv + yu * yv < 0)
        return sqrt( (xp-xb)*(xp-xb) + (yp-yb)*(yp-yb) );
    
    return fabs( ( xp * ( ya - yb ) + yp * ( xb - xa ) + ( xa * yb - xb * ya ) ) / sqrt((xb-xa)*(xb-xa) + (yb-ya)*(yb-ya)) );
}

-(CGPoint)getP1
{
    TAAnchor* p1 = anchors[0];
    TAAnchor* p2 = anchors[1];
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
    TAAnchor* p1 = anchors[0];
    TAAnchor* p2 = anchors[1];
    double x2 = p2.x_coord;
    double y2 = p2.y_coord;
    double k = (p2.y_value-p1.y_value)/(p2.x_index-p1.x_index);
    double l = (p1.y_value*p2.x_index - p2.y_value*p1.x_index)/(p2.x_index-p1.x_index);
    double x2p = NAN;
    
    if(p2.x_index<parentChart.parentFChart.startIndex)//if we went out of the screen left
    {			
        x2 = [parentChart.parentFChart.xAxis XIndexToX:(parentChart.parentFChart.startIndex)];
        x2p = parentChart.parentFChart.startIndex+1;
        y2 = [parentChart.yAxis getCoorValue:(k*x2p + l)];
    }
    
    if(p2.x_index>=parentChart.parentFChart.startIndex + parentChart.parentFChart.duration)//if we went out of the screen right
    {	
        x2 = [parentChart.parentFChart.xAxis XIndexToX:(parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 1)];
        x2p = (parentChart.parentFChart.startIndex + parentChart.parentFChart.duration - 1);
        y2 = [parentChart.yAxis getCoorValue:(k*x2p + l)];
    }    
    return CGPointMake(x2, y2);
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{
    CGPoint p1 = [self getP1];
    CGPoint p2 = [self getP2];
    CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(color).CGColor);
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    SetContextLineDash(ctx, linedash);
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    
    if ((int) p1.y == (int) p2.y || (int) p1.x == (int) p2.x) 
    {
        CGContextSetShouldAntialias(ctx, false);
    }   
    else
    {
        CGContextSetShouldAntialias(ctx, true);
    }
    CGContextStrokePath(ctx);    
    CGContextSetLineDash(ctx, 0, nil, 0);
    CGContextSetShouldAntialias(ctx, false);
    for (TAAnchor* a in anchors)
    {
        [a drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
    }   

}
@end