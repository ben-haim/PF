
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <XiPFramework/Utils.h>
#import "ToolbarDefines.h"
#import "ToolbarButtonSegment.h"

@class ToolbarButton;
@interface ToolbarButtonDraw : CALayer 
{
    ToolbarButton* btn;
}
-(id)initWithButton:(ToolbarButton*)_btn AndScale:(float)scale;
- (struct HitTestInfo)drawInternal:(CGContextRef)ctx orHitTest:(BOOL)isHittest forPoint:(CGPoint)where;
@property (assign) ToolbarButton* btn;
@end
