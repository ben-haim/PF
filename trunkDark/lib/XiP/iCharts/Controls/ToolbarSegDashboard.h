
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "../Plot/Utils.h"
#import "ToolbarDefines.h"
#import "ToolbarButtonSegment.h"

@protocol ChartNotificationsDelegate;
@interface ToolbarSegDashboard : CALayer 
{
    ToolbarButtonSegment *parent_segment;
    id <ChartNotificationsDelegate>  tb_delegate;
}
- (id)initWithScale:(float)scale AndDelegate:(id)_tb_delegate;
- (void)drawInContext:(CGContextRef)ctx;
- (struct HitTestInfo)hitTestSegment:(CGPoint)where;
- (CGRect)getCellRectAtRow:(int)r AndCol:(int)c AndDPI:(float)pen_1px;
@property (assign) ToolbarButtonSegment* parent_segment;
@property (assign) id tb_delegate;
@end
