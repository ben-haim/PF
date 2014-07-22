#import "PFViewController.h"

@class PFSwitch;
@class PFSegmentedControl;

@protocol PFLoginViewControllerDelegate;

@interface PFLoginViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UIScrollView* scrollView;

@property ( nonatomic, strong ) IBOutlet UITextField* loginField;
@property ( nonatomic, strong ) IBOutlet UITextField* passwordField;
@property ( nonatomic, strong ) IBOutlet PFSwitch* passwordSwitch;
@property ( nonatomic, strong ) IBOutlet UIButton* loginButton;
@property ( nonatomic, strong ) IBOutlet UIButton* registerButton;
@property (strong, nonatomic) IBOutlet UILabel *rememberPasswordLabel;
@property (strong, nonatomic) IBOutlet PFSegmentedControl* serverTypeControl;
@property (strong, nonatomic) IBOutlet UIImageView* logoImageView;

@property ( nonatomic, assign ) id< PFLoginViewControllerDelegate > delegate;

-(IBAction)logonAction:( id )sender_;
-(IBAction)registerAction:( id )sender_;

-(void)resetPasswordForLogin:( NSString* )login_;

@end

@class PFServerInfo;

@protocol PFLoginViewControllerDelegate <NSObject>

-(void)loginViewController:( PFLoginViewController* )controller_
        logonUserWithLogin:( NSString* )login_
                  password:( NSString* )password_
                serverInfo:( PFServerInfo* )server_info_;

@end
