//
//  ChartSensorView.m
//  XiP
//
//  Created by Xogee MacBook on 04/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "ChartSensorView.h"
#import "FinanceChart.h"

@implementation ChartSensorView
@synthesize chart;


- (id)initWithCoder:(NSCoder*)coder 
{
    if( !(self = [super initWithCoder:coder]) )
        return self;
    if (self) 
    {
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chart sensor_touchesBegan:touches];
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [chart sensor_touchesEnded:touches];
    [super touchesCancelled:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [chart sensor_touchesMoved:touches];
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chart sensor_touchesEnded:touches];
    [super touchesEnded:touches withEvent:event];
}
@end
