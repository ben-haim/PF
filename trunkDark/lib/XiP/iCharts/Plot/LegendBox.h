

#import <Foundation/Foundation.h>
#import "XYChart.h"
#import "LegendKey.h"

@class XYChart;

@interface LegendBox : NSObject 
{    
    XYChart*        __unsafe_unretained parentChart;
    NSMutableArray* legendKeys;
    CGRect          legend_rect;
}
- (id)initWithParentChart:(XYChart*)_parentChart;
- (void)drawInContext:(CGContextRef)ctx 
               InRect:(CGRect)rect
         mustFillRect:(bool)fillRect
               AndDPI:(double)pen_1px;
- (void)setKey:(NSString*)_legendKeyString color1:(uint)_legendColor color2:(uint)_legendColor2 forceFirst:(bool)insertFirst;
- (void)setText:(NSString*)text ForKey:(NSString*)_key;
@property (unsafe_unretained) XYChart* parentChart;
@property (nonatomic, strong) NSMutableArray* legendKeys;
@property (assign) CGRect legend_rect;
@end
