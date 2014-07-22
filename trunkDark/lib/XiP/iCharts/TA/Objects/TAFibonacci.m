//
//  TAFibonacci.m
//  XiP
//
//  Created by Xogee MacBook on 04/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAFibonacci.h"
#import "TAAnchor.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"

double fibRates1[] = {0, 0.236, 0.382, 0.5, 0.618, 1};

@implementation TAFibonacci
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
    [p1 release];
    [p2 release];
    return self;
}


-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{   
    TAAnchor* p1 = [anchors objectAtIndex:0];
    TAAnchor* p2 = [anchors objectAtIndex:1];
    
    
    return !(MAX(p1.x_index, p2.x_index)<x_start ||  
             MIN(p1.x_index, p2.x_index)>x_end);
}




- (double)GetDistance:(CGPoint)p
{  
    double minDistance = HUGE_VAL;	
    TAAnchor* a1 = [anchors objectAtIndex:0];
    TAAnchor* a2 = [anchors objectAtIndex:1];
    double priceDelta = a2.y_value - a1.y_value;
    
    for(int f=0; f<sizeof(fibRates1)/sizeof(double); f++)  
    {
        double pct = fibRates1[f];
        double currDistance = NAN;
        
        double lastPrice = a1.y_value + pct * priceDelta;
        double curY = [parentChart.yAxis getCoorValue:lastPrice];
        
        CGPoint p1 = [self getP1];
        CGPoint p2 = [self getP2];
        
        double xa = p1.x;
        double ya = curY;
        double xb = p2.x;
        double yb = curY;
        double xp = p.x; 
        double yp = p.y;
        
        double xu = xp - xa;
        double yu = yp - ya;
        double xv = xb - xa;
        double yv = yb - ya;
        
        
        if (xu * xv + yu * yv < 0)
            currDistance = sqrt( (xp-xa)*(xp-xa) + (yp-ya)*(yp-ya));
        else
        {
            xu = xp - xb;
            yu = yp - yb;
            xv = -xv;
            yv = -yv;
            if (xu * xv + yu * yv < 0)
                currDistance =  sqrt( (xp-xb)*(xp-xb) + (yp-yb)*(yp-yb) );
            else
                currDistance =  fabs( ( xp * ( ya - yb ) + yp * ( xb - xa ) + ( xa * yb - xb * ya ) ) / sqrt( ( xb - xa )*( xb - xa ) + ( yb - ya )*(yb - ya) ) );
        }
        
        if(currDistance < minDistance)
            minDistance = currDistance;
    }
    return minDistance;
}

-(CGPoint)getP1
{
    //! changed 1->0 0->1 indexes
    TAAnchor* p1 = [anchors objectAtIndex:1];
    TAAnchor* p2 = [anchors objectAtIndex:0];
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
    //! changed 1->0 0->1 indexes
    TAAnchor* p1 = [anchors objectAtIndex:1];
    TAAnchor* p2 = [anchors objectAtIndex:0];
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
    //! changed 1->0 0->1 indexes
    TAAnchor* a1 = [anchors objectAtIndex:1];
    TAAnchor* a2 = [anchors objectAtIndex:0];
    CGPoint p1 = [self getP1];
    CGPoint p2 = [self getP2];
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    SetContextLineDash(ctx, linedash);
    CGContextSetShouldAntialias(ctx, false);

    double lastPrice = 0;
    double priceDelta = a2.y_value - a1.y_value;
    
    //setup the font
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(color).CGColor);
    
    for(int f=0; f<sizeof(fibRates1)/sizeof(double); f++)  
    {
        double pct = fibRates1[f];
        lastPrice = a1.y_value + pct * priceDelta;
        double curY = [parentChart.yAxis getCoorValue:lastPrice];
        
        //draw line
        if(f==0 || f==sizeof(fibRates1)/sizeof(double)-1)
        {            	
			CGContextSetLineDash(ctx, 0, nil, 0);
        }
        else
        if(f%2==1)
        {
            CGFloat dashLengths[] = {10, 5};
            for(int i=0; i<sizeof( dashLengths ) / sizeof( CGFloat ); i++)
                dashLengths[i]*=pen_1px;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
        else
        {
            CGFloat dashLengths[] = {5, 10};
            for(int i=0; i<sizeof( dashLengths ) / sizeof( CGFloat ); i++)
                dashLengths[i]*=pen_1px;
            CGContextSetLineDash(	ctx, 0, dashLengths, sizeof( dashLengths ) / sizeof( CGFloat ) );
        }
        CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(color).CGColor);
        CGContextMoveToPoint(ctx, p1.x, curY);
        CGContextAddLineToPoint(ctx, p2.x, curY);    
        CGContextStrokePath(ctx);
        
        //draw text
        NSNumber *c = [NSNumber numberWithDouble:pct*100.0];
        NSString *title = [numberFormatter stringFromNumber:c];
        NSString *PriceStr = [NSString stringWithFormat:@"%@ (%@)", [parentChart formatPrice:lastPrice], title];        
        CGContextSaveGState(ctx);
		CGContextSetShouldAntialias(ctx, true);
//        CGContextShowTextAtPoint(ctx, 
//                                 ((a1.x_index>a2.x_index)?p2.x:p1.x) + 0.75*CHART_TA_ANCHOR_SIZE*pen_1px, 
//                                 curY - 4*pen_1px,// - font.capHeight - 4, 
//                                 [PriceStr UTF8String], 
//                                 strlen([PriceStr UTF8String]));
        [PriceStr drawAtPoint:CGPointMake(((a1.x_index>a2.x_index)?p2.x:p1.x) + 0.75*CHART_TA_ANCHOR_SIZE*pen_1px, curY ) withFont:font];
		CGContextSetShouldAntialias(ctx, false);
        CGContextRestoreGState(ctx);

    }	
    CGContextSetLineDash(ctx, 0, nil, 0);
    CGContextSetShouldAntialias(ctx, true);
    for (TAAnchor* a in anchors)
    {
        [a drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
    } 
}
@end
/*
 


 for each(var pct:Number in fibRates)
 {
 lastPrice = a1.y_value + pct * priceDelta;
 var curY:Number = parentChart.yAxis.getCoorValue(lastPrice);
 
 //draw line
 var line_px:int = 0;
 var dash_px:int = 0;
 if(cnt==0 || cnt==fibRates.length-1)
 dash_px = 0;
 else
 if(cnt%2==1)
 {
 line_px  = 20;
 dash_px = 10;
 }
 else
 {
 line_px  = 10;
 dash_px = 10;
 }
 
 if(_isSelected)
 {
 if(dash_px==0)
 dc.line_2px(p1.x, curY, p2.x, curY, color);
 else
 dc.line_dashed_2px(p1.x, curY, p2.x, curY, line_px, dash_px, color);
 }
 else		
 {
 if(dash_px==0)
 dc.line(p1.x, curY, p2.x, curY, color);
 else
 dc.line_dashed(p1.x, curY, p2.x, curY, line_px, dash_px, color);
 }
 //draw texts
 var textField:TextField = new TextField();
 textField.defaultTextFormat = new flash.text.TextFormat(this.parentChart.xAxis.font, 
 this.parentChart.xAxis.fontSize, 
 color);
 textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
 textField.text = lastPrice.toFixed( this.parentChart.digits) + " (" + (pct*100).toFixed(2) + ")";
 textField.x = ((a1.x_index>a2.x_index)?p2.x:p1.x);				
 textField.y = curY - textField.textHeight-4;   
 
 var bd:BitmapData = new BitmapData(textField.textWidth+8, textField.textHeight+5, true, 0x00FFFFFF);
 var r:Rectangle = new flash.geom.Rectangle(0, 0, bd.width, bd.height);
 var p:Point = new flash.geom.Point(textField.x, textField.y);  
 bd.draw(textField);  
 dc.copyPixels(bd, r, p, null, null, true);
 cnt++;	
 }
 for each(var a:TAAnchor in anchors)
 {
 a.draw(dc);
 }
 }
 }

 */
