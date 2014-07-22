//
//  TAVLine.m
//  XiP
//
//  Created by Xogee MacBook on 08/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAVLine.h"
#import "TAAnchor.h"
#import "TALine.h"
#import "Utils.h"
#import "FinanceChart.h"
#import "XYChart.h"
#import "Axis.h"
#import "PlotArea.h"


@implementation TAVLine
@synthesize dateformatter;
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndY1:(double)y1  
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
    
	dateformatter = [[NSDateFormatter alloc] init];
	[dateformatter setDateFormat:@"dd.MM.yyyy HH:mm"];

    return self;
}

-(bool)isVisibleWithin:(int)x_start And:(int)x_end
{	
    TAAnchor* a1 = anchors[0];
    TAAnchor* a2 = [self get_a2];	
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1
                                            AndLineDash:0];
    bool isRayVisible = [line1 isVisibleWithin:x_start And:x_end];
    
    return isRayVisible;
}


- (double)GetDistance:(CGPoint)p
{  	
    TAAnchor* a1 = anchors[0];	
    TAAnchor* a2 = [self get_a2];	
    
    
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:0x00000000 
                                           AndLineWidth:1
                                            AndLineDash:0];
    double resDistance = [line1 GetDistance:p];
    
    return resDistance;
}

-(TAAnchor*)get_a2
{    
    TAAnchor* a1 = anchors[0];    
    return [[TAAnchor alloc] initWithParentChart:parentChart 
                                        AndObject:self 
                                            Color:0x0 
                                           XIndex:a1.x_index 
                                           YValue:a1.y_value>parentChart.yAxis.lowerLimit?parentChart.yAxis.lowerLimit:parentChart.yAxis.upperLimit];
}
/*
 //draw texts
 var timeFormatter:DateFormatter;
 timeFormatter = new DateFormatter();
 timeFormatter.formatString = "DD.MM.YYYY JJ:NN";
 
 var timeValue:Number = this.parentChart.getTimeValueAt(a1.x_index);    
 //(chartCursors[iCursor].x);
 var dtTime:Date = new Date();
 dtTime.setTime(timeValue);
 var TimeStr:String = timeFormatter.format(dtTime);
 
 var textField:TextField = new TextField();
 textField.defaultTextFormat = new flash.text.TextFormat(this.parentChart.xAxis.font, 
 this.parentChart.xAxis.fontSize, 
 color);
 textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
 textField.text = TimeStr;
 textField.x = a1.x_coord - textField.textHeight/2-2;			
 textField.y = parentChart.plotArea.y + parentChart.plotArea.areaHeight - parentChart.xAxis.paddingTopBottom - textField.textWidth-9; 
 */

- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
               AndDPI:(double)pen_1px 
        AndCursorMode:(uint)cursorMode
{  	
    TAAnchor* a1 = anchors[0];	
    TAAnchor* a2 = [self get_a2];
    
    TALine* line1 = [[TALine alloc] initWithParentChart:parentChart 
                                                  AndX1:a1.x_index 
                                                  AndX2:a2.x_index 
                                                  AndY1:a1.y_value 
                                                  AndY2:a2.y_value
                                               AndColor:color   
                                           AndLineWidth:linewidth
                                            AndLineDash:linedash];
    
    [line1 drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:CHART_MODE_NONE];    
    
    
    //setup the font
	UIFont* font = [UIFont systemFontOfSize:[Utils getFontSize]];
	CGAffineTransform myTextTransform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
	myTextTransform = CGAffineTransformRotate(myTextTransform, M_PI/2);
    CGContextSetTextMatrix(ctx, myTextTransform); 
	CGContextSelectFont(ctx, [font.fontName UTF8String], [Utils getFontSize], kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextSetFillColorWithColor(ctx, HEXCOLOR(color).CGColor);
   
   double last_timeval = [self.parentChart getTimeValueAt:a1.x_index];
   NSDate* cursor_date= [NSDate dateWithTimeIntervalSince1970:last_timeval];
    //draw text
	/*int gmt_delta		= [[NSTimeZone localTimeZone] secondsFromGMT];
    double last_timeval = [self.parentChart getTimeValueAt:a1.x_index];
	int dateDaylightSaving	= [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[[[NSDate alloc] initWithTimeIntervalSince1970:last_timeval] autorelease]];
	int timeDelta = gmt_delta;
	if (dateDaylightSaving == 0) 
	{
		timeDelta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
	}
	NSDate* cursor_date= [[NSDate dateWithTimeIntervalSince1970:last_timeval] addTimeInterval:(NSTimeInterval)-timeDelta];	*/
	NSString *lastDateString = [dateformatter stringFromDate:cursor_date];
    NSLog(@"%@", lastDateString); 
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, true);
   
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [lastDateString sizeWithFont:font 
                                      constrainedToSize:maximumLabelSize 
                                          lineBreakMode:UILineBreakModeClip]; 
    
    CGPoint point = CGPointMake([parentChart.parentFChart.xAxis XIndexToX:a1.x_index] - 2*pen_1px, [parentChart.yAxis getCoorValue:parentChart.yAxis.lowerLimit] - 2*pen_1px - expectedLabelSize.width );
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(M_PI/ 2);
    CGContextTranslateCTM(ctx, point.x, point.y);
    CGContextConcatCTM(ctx, rotateTransform);
    CGContextTranslateCTM(ctx, -point.x, -point.y);
    [lastDateString drawAtPoint:point withFont:font];

    CGContextSetShouldAntialias(ctx, false);
    CGContextRestoreGState(ctx);
    
    [a1 drawInContext:ctx InRect:rect AndDPI:pen_1px AndCursorMode:cursorMode];
}@end
