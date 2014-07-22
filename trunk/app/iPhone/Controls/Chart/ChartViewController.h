

#import <UIKit/UIKit.h>
#import "ParamsStorage.h"
#import <XiPFramework/FinanceChart.h>
#import "PlotToolbar.h"

@class ChartSensorView;


@interface ChartViewController : UIViewController<ChartNotificationsDelegate, ChartSettingsDelegate>
{
    UIViewController* parentVC;
    FinanceChart *chart_view;
    IBOutlet PlotToolbar *chartToolbar;
    IBOutlet ChartSensorView *chartSensor;
	IBOutlet UIView *progressView;
	IBOutlet UIImageView *bgView;
	ParamsStorage *storage;
	SymbolInfo *sym;
	CGFloat initialDistance;
	BOOL requestSent;	
	TradePaneType mytype;
    bool isMaximized;
    CGRect origFrame;
    UIWindow *fullscreenWindow;
}
@property (nonatomic, retain) IBOutlet FinanceChart *chart_view;
@property (nonatomic, retain) IBOutlet UIView *progressView;
@property (nonatomic, retain) IBOutlet UIImageView *bgView;
@property (nonatomic, retain) IBOutlet ChartSensorView *chartSensor;
@property (nonatomic, retain) ParamsStorage *storage;
@property (nonatomic, retain) UIViewController *parentVC;
@property (nonatomic, retain) SymbolInfo *sym;
@property (assign) BOOL requestSent;
@property (assign) bool isMaximized;
@property (assign) CGRect origFrame;
@property (assign) UIWindow *fullscreenWindow;

@property (assign) TradePaneType mytype;

-(void)GetChart:(SymbolInfo*)symbol AndRange:(NSString*)RangeType;
-(void)ShowForSymbol:(SymbolInfo *)si AndParams:(ParamsStorage*)p;
-(void)showSettingsToolbar:(BOOL)withAnimation;
- (void)settingsDlgClosed:(NSNotification *)notification;
- (void)chartReceived:(NSNotification *)notification;
- (void)setCursorMode:(uint)ChartModeValue;
- (void)ApplySettings;
- (void)SaveSettings;
- (void)needSaveSettings;
- (void)needMaximizeMinimize;
- (void)applyColorScheme:(int)scheme;
@end
