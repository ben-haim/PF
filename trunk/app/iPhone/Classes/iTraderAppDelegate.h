#import <UIKit/UIKit.h>

#import "../Controls/Mail/MailList.h"
#import "Logout.h"

#import "PFServerConnectionDelegate.h"

@class GetServer;
@class GetToken;
@class GetSettings;
@class LoginViewController;
@class LoginProgressController;
@class MailList;
@class Logout;
@class ParamsStorage;

@interface iTraderAppDelegate : NSObject <UIApplicationDelegate, PFServerConnectionDelegate >
{
@private
    UIWindow *window;
	GetServer *gsServer;
	GetToken *gsToken; 
	GetSettings *gsSettings; 
	NSString *serverHost;
	int serverPort;
	NSString *login;
	NSString *password;
	/////////
	BOOL userDisconnect;
	BOOL wasConnected;
	BOOL isConnecting;
	/////////Trading data
	NSString *currency;
	ParamsStorage *storage;

	////////
    LoginViewController *loginView;
	LoginProgressController *loginProgress;
	MailList* mailList;
	Logout* logoutView;

	BOOL isOnBackupServer;
	BOOL notificationsRegistered;
	
	NSString *chartInterval;
	float chartScale;
}

- (void) logout;
- (void)saveTabSettings;
- (void) any2progress: (id) sender;
- (void) any2login: (id) sender;
- (void) StartConnection;

@property (nonatomic, assign) NSString *serverHost;
@property (nonatomic, assign) int serverPort;
@property (nonatomic, assign) ParamsStorage* storage;
@property (nonatomic, assign) BOOL isOnBackupServer;
@property (nonatomic, assign) NSString *chartInterval;
@property (nonatomic, assign) float chartScale;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LoginViewController *loginView;
@property (nonatomic, retain) IBOutlet LoginProgressController *loginProgress;

@property (nonatomic, retain) IBOutlet MailList* mailList;
@property (nonatomic, retain) IBOutlet Logout* logoutView;

@property (nonatomic, assign) BOOL notificationsRegistered;

-(void) UnRegisterNotification;

@end

