

#import <Foundation/Foundation.h>
#import "XYChart.h" 

@class XYChart;
@class FinanceChart;

@interface PlotArea : NSObject 
{
	XYChart* __unsafe_unretained parentChart;
	FinanceChart* __unsafe_unretained parentFChart;
	CGRect plot_rect;
}
-(id)initWithChart:(XYChart*)_parentChart AndContainer:(FinanceChart*)_parentFChart;
- (void)drawInContext:(CGContextRef)ctx InRect:(CGRect)rect AndDPI:(double)pen_1px DrawPositionAndOrders:(BOOL) isPosOrdDraw;
@property (unsafe_unretained) XYChart* parentChart;
@property (unsafe_unretained) FinanceChart* parentFChart;
@property (assign) CGRect plot_rect;
@end
