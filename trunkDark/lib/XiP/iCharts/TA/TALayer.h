//
//  TALayer.h
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TAAnchor.h"
#import "Objects/TAObject.h"
#import "HitTestResult.h"

@class XYChart;

@interface ChartTATouchInfo : NSObject
{
    HitTestResult* lastHitTest;
    CGPoint ptMouseDown;
    void* address;  
}
@property (nonatomic, retain) HitTestResult* lastHitTest;
@property (assign) CGPoint ptMouseDown;
@property (assign) void* address;
@end

@interface TALayer : NSObject 
{
    XYChart* parentChart;
    NSMutableArray* objects; 
    NSMutableArray* ta_touches; 
    UIImage* ta_anchor_img;
    UIImage* ta_anchor_img_off;
}

- (id)initWithParentChart:(XYChart*)_parentChart;
- (void)Clear;
- (void)AddObject:(TAObject*)o;
- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect 
               AndDPI:(double)pen_1px
        AndCursorMode:(uint)cursorMode;
- (HitTestResult*)hitTest:(CGPoint)p AndThreshold:(double)threshold;
- (void)HandleDrag:(NSSet *)touches;
- (void)HandleDrawStartAt:(CGPoint)pt WithTouch:(UITouch*)touch WithXIndex:(int)x_index AndYValue:(double)y_value;

- (void)touchesBegan:(NSSet*)touches;
- (void)touchesMoved:(NSSet*)touches;
- (void)touchesEnded:(NSSet*)touches;
- (NSArray*)GetDrawings;
- (void)SetDrawings:(NSArray*)_objects;

-(BOOL)resizeModeFromTouches:(NSSet*)touches;

@property (assign) XYChart* parentChart;
@property (nonatomic, retain) NSMutableArray* objects;
@property (nonatomic, retain) NSMutableArray* ta_touches;
@property (nonatomic, retain) UIImage* ta_anchor_img;
@property (nonatomic, retain) UIImage* ta_anchor_img_off;

@end
