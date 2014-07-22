//
//  SplitterLayer.h
//  XiP
//
//  Created by Xogee MacBook on 06/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class FinanceChart;

@interface ChartSplitterHittest : NSObject
{
    int iChart;
    int state;
    void* address;
    double y;
}
@property (assign) int iChart;
@property (assign) double y;
@property (assign) void* address;
@property (assign) int state;
@end

@interface SplitterLayer : NSObject 
{
    FinanceChart* parentFChart;
    NSMutableArray* iChartClicks;
    CGFloat scale;
}
- (id)initWithParentChart:(FinanceChart*)_parentChart;
- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px;
- (void)touchesBegan:(NSSet*)points;
- (void)touchesMoved:(NSSet*)points;
- (void)touchesEnded:(NSSet*)points;
- (void)touchesCanceled:(NSSet*)points;

-(BOOL)splitterModeFromTouches: (NSSet*)touches;

@property (assign) FinanceChart* parentFChart;
@property (nonatomic, retain) NSMutableArray* iChartClicks;
@end
