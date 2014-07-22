//
//  TAObject.m
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAObject.h"
#import "TAAnchor.h"
#import "HitTestResult.h"
#import "Utils.h"


@implementation TAObject
@synthesize parentChart, anchors, color, linewidth, linedash;

- (id)initWithParentChart:(XYChart*)_parentChart 
                 AndColor:(uint)_color 
             AndLineWidth:(uint)_linewidth 
              AndLineDash:(uint)_linedash
{
    self = [super init];
    if(self == nil)
        return self;
    self.parentChart        = _parentChart;
    self.color              = _color;
    self.anchors            = [[NSMutableArray alloc] init];
    self.isSelected         = false;  
    self.linewidth          = _linewidth;
    self.linedash           = _linedash;
    numberFormatter         = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setDecimalSeparator:@"."];
	[numberFormatter setGeneratesDecimalNumbers:TRUE];
	[numberFormatter setMinimumIntegerDigits:1]; 
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    return self;
}


-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{
    return true;
}

-(double)GetDistance:(CGPoint)p
{
    return HUGE_VAL;
}

-(TAAnchor*) GetNearestAnchor:(CGPoint)p
{
    return nil;
}

-(void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{
    
}

-(HitTestResult*)HitTest:(CGPoint)p AndThreshold:(int)threshold
{
    HitTestResult *res = [[HitTestResult alloc] initWithRes:CHART_HT_NONE];
    
    double minDistance = HUGE_VAL;
    
    for (TAAnchor* a in anchors)
    {
        double curDistance = [a GetDistance:p]; 
        if(curDistance<=round(0.707*a.AnchorSize + CHART_TA_ANCHOR_THRESHOLD) && curDistance<minDistance)
        {
            minDistance = curDistance;
            curDistance = [a GetDistance:p]; 
            res._ht_res = CHART_HT_ANCHOR;
            res.a = a;
            res.distance = curDistance;
        }
    }
    if(res._ht_res == CHART_HT_ANCHOR)
        return res;
    double oDistance = [self GetDistance:p];
    if(oDistance<=threshold && oDistance < minDistance)
    {
        res._ht_res = CHART_HT_OBJECT;
        res.o = self;   
        res.distance = oDistance;
    }
    
    return res;
}
-(void) setIsSelected:(bool)input
{
    isSelected = input;	
    if(!input)
    {
        for(TAAnchor* a in anchors)
        {
            a.isSelected = false;
        }
    }
}
-(bool)isSelected
{
    return isSelected;
}
@end
