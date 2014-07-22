
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "SelectServer.h"
#import "DemoRegistrationController.h"

@interface LoginViewController : UIViewController 
{
	IBOutlet UIImageView *imgLogo;
	IBOutlet UITextField *edtLogin;
	IBOutlet UITextField *edtPassword;
	IBOutlet UITextField *edtServer;
	IBOutlet UIButton *btnOk;

	IBOutlet UIButton *btnDemo;
	IBOutlet UIButton *btnAccounts;
	IBOutlet UIView *wobbleView;
	
	IBOutlet UILabel *lblLogin;
	IBOutlet UILabel *lblPassword;
	IBOutlet UILabel *lblServer;
	IBOutlet UILabel *verNum;
	
	/////////////////////////////
	NSString *login;
	NSString *password;
	NSString *server;
	ParamsStorage *storage;
}

@property( nonatomic, retain) IBOutlet UIImageView *imgLogo;
@property( nonatomic, assign) ParamsStorage *storage;
@property( nonatomic, retain) NSString *login;
@property( nonatomic, retain) NSString *password;
@property( nonatomic, retain) NSString *server;

@property( nonatomic, retain) IBOutlet UILabel *verNum;
@property( nonatomic, retain) UILabel *lblLogin; 
@property( nonatomic, retain) UILabel *lblPassword;
@property( nonatomic, retain) UILabel *lblServer;
@property( nonatomic, retain) IBOutlet UIButton *btnOk;
@property( nonatomic, retain) IBOutlet UIButton *btnAccounts;

@property( nonatomic, retain) IBOutlet UIButton *btnDemo;

@property( nonatomic, retain) IBOutlet UIView *wobbleView;

- (IBAction) btnLogin_Clicked:(id)sender;
- (IBAction) btnServer_Clicked:(id)sender;
- (IBAction) btnAccount_Clicked:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField*)aTextBox;
- (void)initialize;
- (void)wobbleButton;
- (void)wobbleButtonStop;
- (void)shakeButton;
-(void) checkCredentials;
-(void)HideAccountSelector;

- (IBAction) btnDemo_Clicked:(id)sender;
@end
