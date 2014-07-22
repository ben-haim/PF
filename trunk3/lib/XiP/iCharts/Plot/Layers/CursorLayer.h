#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XYChart;
@interface ChartCursor : NSObject
{
    NSString *key;
    uint color;
    double x;
    double y;
    int index;
}
-(id)initWithKey:(NSString*)_key AndColor:(uint)_color;
@property (nonatomic, retain) NSString* key;
@property (assign) uint color;
@property (assign) double x;
@property (assign) double y;
@property (assign) int index;
@end

@interface CursorLayer : NSObject 
{
    XYChart* parentChart;
    NSMutableArray* chartCursors;
    UIWindow *loupeWindow;
    bool chartCursorVisible;
    double cursorX;
    double cursorY;
    //
    UIImage         *glass;
    UIImage         *mask;
    UIView* uiView;
}
- (id)initWithParentChart:(XYChart*)_parentChart;
- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect 
               AndDPI:(double)pen_1px 
            drawLoupe:(bool)onlyLoupe;
- (void)setChartCursorValue:(NSString*)key pX:(double)_x pY:(double)_y Index:(int)_i;
- (void)setChartCursorKey:(NSString*)key AndColor:(uint)_color;
- (UIImage*)cropImage:(UIImage*)originalImage toRect:(CGRect)rect;
- (void)showLoupe;
- (void)hideLoupe;
@property (assign) XYChart* parentChart;
@property (nonatomic, retain) NSMutableArray* chartCursors;
@property (nonatomic, retain) UIWindow *loupeWindow;
@property (assign) bool chartCursorVisible;
@property (assign) double cursorX;
@property (assign) double cursorY;
@property (nonatomic, retain) UIImage* glass;
@property (nonatomic, retain) UIImage* mask;
@end
