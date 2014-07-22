//
//  TAAnchor.h
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class XYChart;
@class TAObject;
@interface TAAnchor : NSObject 
{
    double AnchorSize;
    XYChart* parentChart;
    TAObject* parentObject;
    uint color;
    int x_index;
    double y_value;
    int x_index_orig_drag;
    double y_val_orig_drag;
    bool isSelected;    
}
- (id)initWithParentChart:(XYChart*)_parentChart 
                AndObject:(TAObject*)_parentObject 
                    Color:(uint)_color
                   XIndex:(int)_x_index
                   YValue:(double)_y_value;

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode;
-(double)GetDistance:(CGPoint)p;
-(double)x_coord;
-(double)y_coord;
- (double)x_time;
- (void)setIsSelected:(bool)input;
- (bool)isSelected;

@property (assign) XYChart* parentChart;
@property (assign) TAObject* parentObject;
@property (assign) double AnchorSize;
@property (assign) uint color;
@property (assign) int x_index;
@property (assign) double y_value;
@property (assign) int x_index_orig_drag;
@property (assign) double y_val_orig_drag;
@end
