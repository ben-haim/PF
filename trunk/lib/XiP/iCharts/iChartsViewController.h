
#import <UIKit/UIKit.h>
#import "Plot/FinanceChart.h"
#import "Controls/PlotToolbar.h"

@class ChartSensorView;
@interface iChartsViewController : UIViewController <ChartNotificationsDelegate>
{
    IBOutlet PlotToolbar *chartToolbar;
    IBOutlet FinanceChart *pnlChart; 
    IBOutlet ChartSensorView *chartSensor;
    IBOutlet UIButton *btnShowHideMenu;
}
-(void)settingsDlgClosed:(NSNotification *)notification;
-(void)showSettingsToolbar:(BOOL)withAnimation;
-(void)hideSettingsToolbar:(BOOL)withAnimation;
-(void)toggleSettingsToolbar:(BOOL)withAnimation;
-(void)ChartReceived:(NSString*)data;
- (void)setCursorMode:(uint)ChartModeValue;
//-(void)restoreToolbarWithSettings:(IndicatorDesc*)ind_desc;

@property (nonatomic, retain) PlotToolbar *chartToolbar;
@end
