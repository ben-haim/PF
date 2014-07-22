//
//  TAFibFan.m
//  XiP
//
//  Created by Xogee MacBook on 07/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAFibFan.h"
#import "TAAnchor.h"
#import "TASegment.h"
#import "TARay.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"

double fibRates3[] = {0.382, 0.5, 0.618};
@implementation TAFibFan
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
    TAAnchor* a1 = anchors[0];
    TAAnchor* a2 = anchors[1];
    
    
    for(int f=0; f<sizeof(fibRates3)/sizeof(double); f++)  
    {
        double pct = fibRates3[f];
        double curr_y = a1.y_value - pct*(a1.y_value-a2.y_value);        
        TARay* ray = [[TARay alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:curr_y 
                                               AndColor:0x00000000 
                                           AndLineWidth:1 
                                            AndLineDash:0];
        bool isRayVisible = [ray isVisibleWithin:x_start And:x_end];
        if(isRayVisible)
        {
            return true;
        }
    }
    TASegment *seg = [[TASegment alloc] initWithParentChart:parentChart 
                                                      AndX1:a1.x_index 
                                                      AndX2:a2.x_index 
                                                      AndY1:a1.y_value 
                                                      AndY2:a2.y_value 
                                                   AndColor:0 
                                               AndLineWidth:1 
                                                AndLineDash:0];
    bool res = [seg isVisibleWithin:x_start And:x_end];
    return res;
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


- (double)GetDistance:(CGPoint)p
{  
    double currDistance = NAN;
    double minDistance = HUGE_VAL;
	
    TAAnchor* a1 = anchors[0];
    TAAnchor* a2 = anchors[1];
    
    
    for(int f=0; f<sizeof(fibRates3)/sizeof(double); f++)  
    {
        double pct = fibRates3[f];
        double curr_y = a1.y_value - pct*(a1.y_value-a2.y_value);        
        TARay* ray = [[TARay alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:curr_y 
                                               AndColor:0x00000000 
                                           AndLineWidth:1 
                                            AndLineDash:0];
        currDistance = [ray GetDistance:p];
        if(currDistance < minDistance)
            minDistance = currDistance;
    }
    TASegment *seg = [[TASegment alloc] initWithParentChart:parentChart 
                                                      AndX1:a1.x_index 
                                                      AndX2:a2.x_index 
                                                      AndY1:a1.y_value 
                                                      AndY2:a2.y_value 
                                                   AndColor:0 
                                               AndLineWidth:1 
                                                AndLineDash:0];    
    double seg_dist = [seg GetDistance:p];
    if(seg_dist < minDistance)
        minDistance = seg_dist;
    return minDistance;
}


- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{
    TAAnchor* a1 = anchors[0];
    TAAnchor* a2 = anchors[1];
    CGPoint p1 = [self getP1];
    CGPoint p2 = [self getP2];   
    
    
    //double real_x1 = [parentChart.parentFChart.xAxis XIndexToXRaw:a1.x_index AndCheck:false];
    double real_x2 = [parentChart.parentFChart.xAxis XIndexToXRaw:a2.x_index AndCheck:false];
    //double real_y1 = [parentChart.yAxis getCoorValue:(a1.y_value)];
    //double real_y2 = [parentChart.yAxis getCoorValue:(a2.y_value)];
    
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(color).CGColor);
    //setup the font
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
    CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(color).CGColor);

    for(int f=0; f<sizeof(fibRates3)/sizeof(double); f++)  
    {
        double pct = fibRates3[f];
        double curr_y = a1.y_value - pct*(a1.y_value-a2.y_value);
        
        TARay* ray = [[TARay alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:curr_y 
                                               AndColor:color 
                                           AndLineWidth:linewidth 
                                            AndLineDash:linedash];
        [ray drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:CHART_MODE_NONE];
        
        //draw text   
        NSNumber *c = @(100.0-pct*100.0);//! added 100.0-
        NSString *PriceStr = [numberFormatter stringFromNumber:c];
        CGContextSaveGState(ctx);
		CGContextSetShouldAntialias(ctx, true);
        [PriceStr drawAtPoint:CGPointMake(real_x2, [parentChart.yAxis getCoorValue:curr_y]) withFont:font];
		CGContextSetShouldAntialias(ctx, false);
        CGContextRestoreGState(ctx);
    }
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
/*

 public override function draw(dc:Raster):void
 {

 
 
 dc.line_2px(p1.x, p1.y, p2.x, p2.y, color);
 for each(var pct:Number in fibRates)
 {
 var curr_y:Number = real_y2 - pct*(real_y2-real_y1);
 var ray:TARay = new TARay(parentChart, a1.x_index, a1.y_value,
 a2.x_index, curr_y,
 color);
 ray.draw_ex(dc, this._isSelected, false);  
 
 //draw texts
 var textField:TextField = new TextField();
 textField.defaultTextFormat = new flash.text.TextFormat(	this.parentChart.xAxis.font, 
 this.parentChart.xAxis.fontSize, 
 color);
 textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
 textField.text = (pct*100).toFixed(2);
 textField.x = real_x2;				
 textField.y = parentChart.yAxis.getCoorValue(curr_y)-textField.textHeight-6; 
 
 
 var bd:BitmapData = new BitmapData(textField.textWidth+8, textField.textHeight+5, true, 0x00FFFFFF);
 var r:Rectangle = new flash.geom.Rectangle(0, 0, bd.width, bd.height);
 var p:Point = new flash.geom.Point(textField.x-textField.textWidth/2-3, textField.y);  
 
 bd.draw(textField, null, null, flash.display.BlendMode.LAYER); 
 if(p.x<this.parentChart.plotArea.x + parentChart.plotArea.areaWidth-parentChart.xAxis.GridCellSize &&
 p.y+10<this.parentChart.plotArea.y + parentChart.plotArea.areaHeight-parentChart.xAxis.paddingTopBottom - (parentChart.xAxis.isVisible?parentChart.xAxis.axisHeight:0) &&
 p.x>this.parentChart.plotArea.x)
 dc.copyPixels(bd, r, p, null, null, true);
 }
}
}
 */
@end
