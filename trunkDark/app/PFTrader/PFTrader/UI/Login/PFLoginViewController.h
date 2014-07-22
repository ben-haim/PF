#import "PFViewController.h"

@class PFSwitch;
@class PFSegmentedControl;
@class PFTextField;
@protocol PFLoginViewControllerDelegate;

@interface PFLoginViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* steelImageView;
@property ( nonatomic, weak ) IBOutlet UIScrollView* scrollView;
@property ( nonatomic, weak ) IBOutlet PFTextField* loginField;
@property ( nonatomic, weak ) IBOutlet PFTextField* passwordField;
@property ( nonatomic, weak ) IBOutlet PFSwitch* passwordSwitch;
@property ( nonatomic, weak ) IBOutlet UIButton* loginButton;
@property ( nonatomic, weak ) IBOutlet UIButton* registerButton;
@property ( nonatomic, weak ) IBOutlet UILabel *rememberPasswordLabel;
@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* serverTypeControl;
@property ( nonatomic, weak ) IBOutlet UIImageView* logoImageView;
@property ( nonatomic, weak ) id< PFLoginViewControllerDelegate > delegate;

-(IBAction)logonAction:( id )sender_;
-(IBAction)registerAction:( id )sender_;

-(void)resetPasswordForLogin:( NSString* )login_;

@end

@class PFServerInfo;

@protocol PFLoginViewControllerDelegate < NSObject >

-(void)loginViewController:( PFLoginViewController* )controller_
        logonUserWithLogin:( NSString* )login_
                  password:( NSString* )password_
                serverInfo:( PFServerInfo* )server_info_;

@end
