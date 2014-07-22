//
//  TAFibArcs.m
//  XiP
//
//  Created by Xogee MacBook on 05/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAFibArcs.h"
#import "TAAnchor.h"
#import "TASegment.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"


double fibRates2[] = {0.382, 0.5, 0.618, 0.786};
@implementation TAFibArcs
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
    TAAnchor* p1 = anchors[0];
    TAAnchor* p2 = anchors[1];
    
    
    return !(MAX(p1.x_index, p2.x_index)<x_start ||  
             MIN(p1.x_index, p2.x_index)>x_end);
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
    double xp = p.x; 
    double yp = p.y;		
    TAAnchor* a1 = anchors[0];
    TAAnchor* a2 = anchors[1];

    double real_x1 = [parentChart.parentFChart.xAxis XIndexToX:a1.x_index];
    double real_x2 = [parentChart.parentFChart.xAxis XIndexToX:a2.x_index];
    double real_y1 = [parentChart.yAxis getCoorValue:(a1.y_value)];
    double real_y2 = [parentChart.yAxis getCoorValue:(a2.y_value)];
     
    double radius = sqrt((real_x1 - real_x2)*(real_x1 - real_x2) + (real_y1 - real_y2)*(real_y1 - real_y2));     
    //double limit = (real_y1>real_y2)?real_y1:real_y2;
    double lastRadius = 0;
    
    for(int f=0; f<sizeof(fibRates2)/sizeof(double); f++)  
    {
        double pct = fibRates2[f];
        lastRadius =  radius * pct;
        if(real_y1>real_y2 && yp>real_y1)
        {
            currDistance = sqrt( (xp-real_x1)*(xp-real_x1) + (yp-real_y1)*(yp-real_y1));
        }
        else
        if(real_y1<real_y2 && yp<real_y1)
        {
            currDistance = sqrt( (xp-real_x2)*(xp-real_x2) + (yp-real_y2)*(yp-real_y2)); 
        }
        else
        {
            currDistance = sqrt( (xp-real_x1)*(xp-real_x1) + (yp-real_y1)*(yp-real_y1));
            currDistance = abs(currDistance - lastRadius);
        }				
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
static inline double radians (double degrees) { return degrees * M_PI/180; }
CGMutablePathRef createArcPathFromBottomOfRect(CGRect rect, CGFloat arcHeight, bool upwards) 
{
    
    CGRect arcRect = CGRectMake(rect.origin.x, 
                                rect.origin.y + rect.size.height - arcHeight, 
                                rect.size.width, arcHeight);
    
    CGFloat arcRadius = (arcRect.size.height/2) + 
    (pow(arcRect.size.width, 2) / (8*arcRect.size.height));
    CGPoint arcCenter = CGPointMake(arcRect.origin.x + arcRect.size.width/2, 
                                    arcRect.origin.y + arcRadius);
    
    CGFloat angle = acos(arcRect.size.width / (2*arcRadius));
    CGFloat startAngle = radians(upwards?180:0) + angle;
    CGFloat endAngle = radians(upwards?360:180) - angle;
    
    CGMutablePathRef path = CGPathCreateMutable();
   
   if ( !isnan( arcRadius ) )
   {
      CGPathAddArc(path, NULL, arcCenter.x, arcCenter.y, arcRadius, startAngle, endAngle, 0);
   }
    //CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    //CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    //CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    return path;    
    
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
    
    double real_x1 = [parentChart.parentFChart.xAxis XIndexToXRaw:a1.x_index AndCheck:false];
    double real_x2 = [parentChart.parentFChart.xAxis XIndexToXRaw:a2.x_index AndCheck:false];
    double real_y1 = [parentChart.yAxis getCoorValue:(a1.y_value)];
    double real_y2 = [parentChart.yAxis getCoorValue:(a2.y_value)];
    
    double radius = sqrt((real_x1 - real_x2)*(real_x1 - real_x2) + (real_y1 - real_y2)*(real_y1 - real_y2));
    double lastRadius = 0;
    
    
    CGContextSetLineWidth(ctx, linewidth*pen_1px);
    CGContextSetStrokeColorWithColor(ctx, HEXCOLOR(color).CGColor);
    //setup the font
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	myTextTransform = CGAffineTransformRotate(myTextTransform, M_PI/2);
    CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(color).CGColor);
    for(int f=0; f<sizeof(fibRates2)/sizeof(double); f++)  
    {
        CGContextSetShouldAntialias(ctx, true);
        double pct = fibRates2[f];
        lastRadius =  radius * pct;
        
        CGRect arcRect = CGRectMake(real_x1 - lastRadius, real_y1 - lastRadius, 2*lastRadius, lastRadius);
        arcRect.size.height = lastRadius;
        
        //CGContextSaveGState(ctx);
        CGMutablePathRef arcPath = createArcPathFromBottomOfRect(arcRect, lastRadius, (real_y1>real_y2));
        CGContextAddPath(ctx, arcPath);
        CGContextStrokePath(ctx);
        //CGContextRestoreGState(ctx);        
        CFRelease(arcPath);
        
        //draw text 
        NSNumber *c = @(pct*100.0);
        NSString *PriceStr = [numberFormatter stringFromNumber:c];
        CGContextSaveGState(ctx);
		
        
        CGSize maximumLabelSize = CGSizeMake(296,9999);
        
        CGSize expectedLabelSize = [PriceStr sizeWithFont:font 
                                              constrainedToSize:maximumLabelSize 
                                                  lineBreakMode:UILineBreakModeClip]; 
        
        CGPoint point1 = CGPointMake(real_x1 + lastRadius + font.capHeight/2.0, real_y1  + ((real_y1<=real_y2)?-font.capHeight/2.0:25) - expectedLabelSize.width );
        CGPoint point2 = CGPointMake(real_x1 - lastRadius + font.capHeight/2.0, real_y1  + ((real_y1<=real_y2)?-font.capHeight/2.0:25) - expectedLabelSize.width );
        CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(M_PI/ 2);
        
        CGContextTranslateCTM(ctx, point1.x, point1.y);
        CGContextConcatCTM(ctx, rotateTransform);
        CGContextTranslateCTM(ctx, -point1.x, -point1.y);
        
        [PriceStr drawAtPoint:point1 withFont:font];

        CGContextRestoreGState(ctx);
        CGContextSaveGState(ctx);
		CGContextSetShouldAntialias(ctx, true);

        CGContextTranslateCTM(ctx, point2.x, point2.y);
        CGContextConcatCTM(ctx, rotateTransform);
        CGContextTranslateCTM(ctx, -point2.x, -point2.y);             
        
        [PriceStr drawAtPoint:point2 withFont:font];             
        
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

@end
