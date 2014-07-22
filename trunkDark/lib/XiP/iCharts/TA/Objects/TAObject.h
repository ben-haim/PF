//
//  TAObject.h
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class XYChart;
@class TAAnchor;
@class HitTestResult;
@interface TAObject : NSObject 
{
    XYChart* __unsafe_unretained parentChart;
    NSMutableArray* anchors; 
    uint color;
    uint linewidth;
    uint linedash;
    bool isSelected; 
    
    NSNumberFormatter *numberFormatter;
}

- (id)initWithParentChart:(XYChart*)_parentChart 
                 AndColor:(uint)_color 
             AndLineWidth:(uint)_linewidth 
              AndLineDash:(uint)_linedash;
- (bool)isVisibleWithin:(int)x_start And:(int)x_end;
- (double)GetDistance:(CGPoint)p;
- (HitTestResult*)HitTest:(CGPoint)p AndThreshold:(int)threshold;
- (TAAnchor*) GetNearestAnchor:(CGPoint)p;
- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode;
- (void)setIsSelected:(bool)input;
- (bool)isSelected;

@property (unsafe_unretained) XYChart* parentChart;
@property (nonatomic, strong) NSMutableArray* anchors;
@property (assign) uint color;
@property (assign) uint linewidth;
@property (assign) uint linedash;

@end
