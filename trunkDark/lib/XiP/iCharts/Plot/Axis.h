
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class XYChart;
@class FinanceChart;

@interface Axis : NSObject 
{
    XYChart* __unsafe_unretained parentChart;
    FinanceChart* __unsafe_unretained parentFChart;
    NSMutableArray* tickPositions;
    NSDateFormatter *dateFormatter;
    uint axisType;
    CGRect axis_rect;
    //double paddingTopBottom;
    bool isAutoScale;
    bool isAutoLower;
    bool showZero;
    double upperLimit;
    double lowerLimit;
    
}
- (id)initWithType:(uint)_axisType parentXYChart:(XYChart*)_parentChart parentFinanceChart:(FinanceChart*)_parentFChart;
- (void)layoutInRect:(CGRect)rect;
- (void)drawInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px;
- (void)drawXAxisInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px;
- (void)drawYAxisInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px;
- (void)drawCursorTimeInContext:(CGContextRef)ctx 
                      WithIndex:(uint)cursorIndex 
                  WithFillColor:(CGColorRef)fillColor
                  WithTextColor:(CGColorRef)textColor
                         AndDPI:(double)pen_1px;
- (void)drawCursorPriceInContext:(CGContextRef)ctx
						   WithY:(int)pY
				   WithFillColor:(CGColorRef)fillColor
				   WithTextColor:(CGColorRef)textColor
						  AndDPI:(double)pen_1px;
- (void)autoScale;
- (double)getPixelValue;
- (double)getValueOfPixel;
- (int)getXDataIndex:(double)pX;
- (double)XIndexToX:(int)x_index;
- (double)XIndexToXRaw:(int)x_index AndCheck:(bool)mustCheck;
- (double)getCoorValue:(double)value;
- (double)coorToValue:(double)pY;
- (void)clear;
- (void)setAutoScale;
- (void)setLinearScale:(double)_lowerLimit AndUpper:(double)_upperLimit;
- (void)setLowerLimit_:(double)_lowerLimit;

@property (unsafe_unretained) XYChart* parentChart;
@property (unsafe_unretained) FinanceChart* parentFChart;
@property (nonatomic, strong) NSMutableArray* tickPositions;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (assign) uint axisType;
@property (assign) CGRect axis_rect;
@property (assign) bool showZero;
@property (assign) bool isAutoScale;
@property (assign) bool isAutoLower;
@property (assign) double upperLimit;
@property (assign) double lowerLimit;
@end
