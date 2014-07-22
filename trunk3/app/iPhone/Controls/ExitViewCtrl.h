
#import <UIKit/UIKit.h>

@protocol iTraderAppDelegate

-(void)logout;

@end


@interface ExitViewCtrl : UIViewController <UIAlertViewDelegate> {

	IBOutlet UIButton* btnLogout;
	IBOutlet UIButton* btnExit;
	
	UIAlertView* alert;
	NSTimer* timer;
	int exitCounter;
	int logoutCounter;
	BOOL isExitRequest;
	BOOL isLogoutRequest;
}

@property (nonatomic, retain) IBOutlet UIButton* btnLogout;
@property (nonatomic, retain) IBOutlet UIButton* btnExit;

- (IBAction)exitClicked:(id)sender;
- (IBAction)logoutClicked:(id)sender;

@end
