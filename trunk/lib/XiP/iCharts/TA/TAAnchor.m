//
//  TAAnchor.m
//  XiP
//
//  Created by Xogee MacBook on 14/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAAnchor.h"
#import "Utils.h"
#import "XYChart.h"
#import "TALayer.h"
#import "FinanceChart.h"
#import "Axis.h"
#import "TAObject.h"


@implementation TAAnchor
@synthesize AnchorSize, parentChart, parentObject, color;
@synthesize x_index, y_value, x_index_orig_drag, y_val_orig_drag;


- (id)initWithParentChart:(XYChart*)_parentChart 
                AndObject:(TAObject*)_parentObject 
                    Color:(uint)_color
                   XIndex:(int)_x_index
                   YValue:(double)_y_value
{
    self = [super init];
    if(self == nil)
        return self;    
    AnchorSize = CHART_TA_ANCHOR_SIZE;
    color = 0x000000FF;//_color;
    parentChart = _parentChart;
    parentObject = _parentObject;
    x_index = _x_index;
    y_value = _y_value;
    return self;
}

-(double) GetDistance:(CGPoint)p
{    
    double _x_coord = [self x_coord];
    double _y_coord = [self y_coord];
    return sqrt((_x_coord-p.x)*(_x_coord-p.x) + (_y_coord-p.y)*(_y_coord-p.y));   
}

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{
    if(cursorMode != CHART_MODE_DRAW && cursorMode != CHART_MODE_RESIZE && cursorMode != CHART_MODE_DELETE)  
        return;   
    
    CGRect r = CGRectMake([self x_coord] - AnchorSize/2.0,
                          [self y_coord] - AnchorSize/2.0,
                          AnchorSize,
                          AnchorSize);
    //uint neg_color = 0x000000FF | (~color);
    
    /*CGContextSetLineWidth(ctx, 1*pen_1px);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(isSelected?color:neg_color).CGColor);
    CGContextFillRect(ctx, r);
    CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(isSelected?neg_color:color).CGColor);
    CGContextStrokeRect(ctx, r);*/
    
    /*CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 
                          0.0, 
                          r.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, r, self.parentChart.taLayer.ta_anchor_img.CGImage); 
    CGContextRestoreGState(ctx);*/
    
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2), 2.0, [UIColor grayColor].CGColor);
    
    if (cursorMode == CHART_MODE_DELETE)
    {
        [self.parentChart.taLayer.ta_anchor_img_off drawInRect:r];
    }
    else
    {
        [self.parentChart.taLayer.ta_anchor_img drawInRect:r];
    }
    CGContextRestoreGState(ctx);
}

-(double)x_coord
{
    return [parentChart.parentFChart.xAxis XIndexToX:x_index];
}
-(double)y_coord
{
    return [parentChart.yAxis getCoorValue:y_value];
}

-(double)x_time
{
    return [parentChart getTimeValueAt:x_index]; 
}

-(void) setIsSelected:(bool)input
{
    isSelected = input;	    
    if(input)
    {
        parentObject.isSelected = true;
    }
}
-(bool)isSelected
{
    return isSelected;
}

@end
