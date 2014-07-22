

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import <XiPFramework/Utils.h>
#import "ToolbarDefines.h"
#import "ToolbarButtonSegment.h"


struct HitTestInfo;
@protocol ChartNotificationsDelegate;
@class ToolbarButtonDraw;
@interface ToolbarButton : CALayer 
{    
    NSMutableArray *segments; 
    uint        tag;
    uint        selectedSegmentTag;
    BOOL        isExpanded; //0 - up, 1 - down
    BOOL        isAnimation;
    CGRect      dummy_bounds;
    BOOL        shouldCleanData; 
    id <ChartNotificationsDelegate>  tb_delegate;
    UIImage*    btnSkin;
    ToolbarButtonDraw* btn;
}
- (id)initWithTag:(uint)_tag AndScale:(float)scale AndDelegate:(id)_tb_delegate;
- (ToolbarButtonSegment*)addSegment:(uint)Action WithText:(NSString*)Text AndImage:(UIImage*)image;
- (void) unselectAllSegments;
- (ToolbarButtonSegment *) GetSegmentWithAction:(uint)_action;
- (struct HitTestInfo)hitTestSegment:(CGPoint)where;
- (struct HitTestInfo)drawInternal:(CGContextRef)ctx orHitTest:(BOOL)isHittest forPoint:(CGPoint)where;
- (void)Expand;
- (void)Collapse:(BOOL)fast;
- (void)MakeInvisible:(float)duration;
- (void)MakeVisible:(float)duration;

@property (assign) id tb_delegate;
@property( nonatomic, retain) NSMutableArray *segments;
@property( nonatomic, retain) UIImage *btnSkin;
@property( assign) uint selectedSegmentTag;
@property( assign) BOOL isExpanded;
@property( assign) BOOL shouldCleanData;
@property( assign) uint tag;
@property( assign) CGRect dummy_bounds;
@property( assign) ToolbarButtonDraw *btn;

@end

struct HitTestInfo
{   
    ToolbarButton *btn;
    ToolbarButtonSegment *seg;
} ;
