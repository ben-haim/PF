//
//  TAChannel.m
//  XiP
//
//  Created by Xogee MacBook on 07/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAChannel.h"
#import "TAAnchor.h"
#import "TALine.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"


@implementation TAChannel
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndX2:(int)x2_index 
                   AndX3:(int)x3_index 
                   AndY1:(double)y1  
                   AndY2:(double)y2  
                   AndY3:(double)y3  
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
    TAAnchor* p3 = [[TAAnchor alloc] initWithParentChart:_parentChart 
                                               AndObject:self 
                                                   Color:_color 
                                                  XIndex:x3_index 
                                                  YValue:y3];
    [anchors addObject:p3];
    [p1 release];
    [p2 release];
    [p3 release];
    return self;
}

-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{	
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    TAAnchor* a3 = [anchors objectAtIndex:2];	
    TAAnchor* a4 = [self get_a4];	
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                              AndX1:a1.x_index 
                                              AndX2:a2.x_index 
                                              AndY1:a1.y_value 
                                              AndY2:a2.y_value
                                           AndColor:0x00000000 
                                       AndLineWidth:1
                                            AndLineDash:0];
    
    TALine* line2 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a3.x_index 
                                                  AndX2:a4.x_index 
                                                  AndY1:a3.y_value 
                                                  AndY2:a4.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1 
                                            AndLineDash:0];
    bool isRayVisible = [line1 isVisibleWithin:x_start And:x_end] || [line2 isVisibleWithin:x_start And:x_end];
    
    [line1 release];
    [line2 release];
    return isRayVisible;
}


- (double)GetDistance:(CGPoint)p
{  	
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    TAAnchor* a3 = [anchors objectAtIndex:2];	
    TAAnchor* a4 = [self get_a4];	
    
    
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1
                                            AndLineDash:0];
    
    TALine* line2 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a3.x_index 
                                                  AndX2:a4.x_index 
                                                  AndY1:a3.y_value 
                                                  AndY2:a4.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1 
                                            AndLineDash:0];
    double resDistance = MIN([line1 GetDistance:p], [line2 GetDistance:p]);
    
    [line1 release];
    [line2 release];
    return resDistance;
}

-(TAAnchor*)get_a4
{    
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    TAAnchor* a3 = [anchors objectAtIndex:2];
    double y4 = NAN;
    
    if(a2.x_index==a1.x_index)
    {			
        return [[[TAAnchor alloc] initWithParentChart:parentChart 
                                            AndObject:self 
                                                Color:0x0 
                                               XIndex:a3.x_index 
                                               YValue:a2.y_value] 
                autorelease];
    }
    double k = (a2.y_value-a1.y_value)/(a2.x_index-a1.x_index);
    double l = (a1.y_value*a2.x_index - a2.y_value*a1.x_index)/(a2.x_index-a1.x_index);
    double delta = a3.y_value - (k*a3.x_index + l);
    l+=delta;
    
    if(fabs(a3.x_index-a1.x_index)<fabs(a3.x_index-a2.x_index))//we are closer to a1
    {
        y4 = k*a2.x_index + l;        
        return [[[TAAnchor alloc] initWithParentChart:parentChart 
                                            AndObject:self 
                                                Color:0x0 
                                               XIndex:a2.x_index 
                                               YValue:y4] 
                autorelease];
    }
    else
    {
        y4 = k*a1.x_index + l;       
        return [[[TAAnchor alloc] initWithParentChart:parentChart 
                                            AndObject:self 
                                                Color:0x0 
                                               XIndex:a1.x_index 
                                               YValue:y4] 
                autorelease];
    }
    return nil;
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{  	
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    TAAnchor* a3 = [anchors objectAtIndex:2];	
    TAAnchor* a4 = [self get_a4];	
    
    
    
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
    
    TALine* line2 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a3.x_index 
                                                  AndX2:a4.x_index 
                                                  AndY1:a3.y_value 
                                                  AndY2:a4.y_value
                                               AndColor:color
                                           AndLineWidth:linewidth
                                            AndLineDash:linedash];
    [line2 drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:CHART_MODE_NONE];    
    [line2 release];	
    CGContextSetLineDash(ctx, 0, nil, 0);
    
    for (TAAnchor* a in anchors)
    {
        [a drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
    }     
}
@end
