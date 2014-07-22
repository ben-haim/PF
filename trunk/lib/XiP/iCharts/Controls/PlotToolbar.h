

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "ToolbarDefines.h"
#import "ToolbarButton.h"
#import "ToolbarButtonDraw.h"
#import "ToolbarSegDashboard.h"
#import "PropertiesStore.h"


@protocol ChartNotificationsDelegate
@required
- (PropertiesStore*)getPropertiesStore;
- (void)buttonClick:(struct HitTestInfo)ht;
@end

///////////////////////////////////////////////////////////////////////////////////////////////
/*@interface PlotToolbarButton : NSObject 
{
    BOOL        isDown; //0 - up, 1 - down
    BOOL        isVisible;
	NSString*   action;
	NSString*   text;
    UIImage*    image;
} 
    @property( assign) BOOL isDown;
    @property( assign) BOOL isVisible;
    @property( nonatomic, retain) NSString *action;
    @property( nonatomic, retain) NSString *text;
    @property( nonatomic, retain) UIImage *image;
@end*/

///////////////////////////////////////////////////////////////////////////////////////////////

@interface PlotToolbar : UIView 
{
    NSMutableArray*                 buttons; 
    NSTimer*                        timerAutoCollapse; 
    id <ChartNotificationsDelegate>  tb_delegate;
    ToolbarSegDashboard*            dashboard;
}
@property (retain) id tb_delegate;
@property( nonatomic, retain) NSMutableArray *buttons;
@property( nonatomic, retain) NSTimer *timerAutoCollapse;
@property( nonatomic, retain) ToolbarSegDashboard *dashboard;

- (void)setupChartToolbar;
- (void)unselectAllButtons;
- (void)collapseAllButtons;
- (struct HitTestInfo)hitTestSegment:(CGPoint)where;
- (void) ProcessClick:(struct HitTestInfo)ht;
- (ToolbarButton *) GetButtonWithTag:(uint)tag;
- (void)startAutoCollapse:(uint)button_tag;
- (void)stopAutoCollapse;
- (void)AutoCollapseProc:(NSTimer *)timer;
- (void)ShowDashBoardForSegment:(ToolbarButtonSegment*)seg;
- (void)HideDashBoard;

/*- (PlotToolbarButton*)addButton:(NSString*)Action WithText:(NSString*)Text AndImage:(UIImage*)image;
- (PlotToolbarButton*)getButtonWithAction:(NSString*)action;
- (PlotToolbarButton*)drawInternal:(CGRect)rect AndHitTestIs:(BOOL)isHitTest ForPoint:(CGPoint)point;
- (float)getFullWidth;
- (void)collapseFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)collapse;
- (void)expand;
- (void)unselectAllButtons;
- (PlotToolbarButton*)hitTest:(CGPoint)point;
*/
@end
