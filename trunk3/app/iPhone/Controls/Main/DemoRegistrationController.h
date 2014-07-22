
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "DemoRegistration.h"
#import "RegField.h"
#import "SelectionListViewController.h"
#import "DropDown.h"
#import "CustomAlert.h"

#import "GetServer.h"
#import "GetToken.h"
#import "ServerConnection.h"

@interface DemoRegistrationController : UIViewController <UITextFieldDelegate, SelectionListViewControllerDelegate, UIAlertViewDelegate>
{
	//class
	ParamsStorage *storage;
	UIView *openDropDown;
	//ui
	IBOutlet UILabel *registrationMessage;
	//IBOutlet UILabel *registrationMandatory;
	IBOutlet UIImageView *background;
	IBOutlet DropDown *btnServer;
	UIButton *btnRegister;

	UITextField *activeField;
	
	//values
	NSString *serverURL;
	NSString *login;
	NSString *password;
	NSString *investors; 
	NSString *serverName;
	
	GetServer *gsServer;
	GetToken *gsToken;
	ServerConnection *serverConn;
	
	BOOL wasConnected;
	BOOL shouldStopConnecting;
	NSString *serverHost;
	int serverPort;
	
	CustomAlert *demoDialog;
	CustomAlert *registrationDialog;
}

@property( nonatomic, assign) ParamsStorage *storage;
@property( nonatomic, retain) IBOutlet DropDown *btnServer;
@property( nonatomic, retain) IBOutlet UILabel *registrationMessage;
//@property( nonatomic, retain) IBOutlet UILabel *registrationMandatory;
@property( nonatomic, retain) IBOutlet IBOutlet UIImageView *background;

@property(assign) NSString *login;
@property(assign) NSString *password;
@property(assign) NSString *investors; 
@property(assign) NSString *serverName;

- (IBAction) cancel:(id)sender;
- (IBAction) btnServer_Clicked:(id)sender;
- (NSArray *) demoServersFromServers:(NSArray *)servers;
- (void) filterGroupsForServer:(ServerInfo *) serverInfo;

//- (NSString *) getFieldName:(NSString *)name withStatus:(FieldStatus)status;
- (RegField *) getRegFieldWithId:(RegFields)fieldId;
- (RegField *) getRegFieldWithView:(UIView *)fieldView;
- (UITextField *) textfieldWithTitle:(NSString *)title
							  frame:(CGRect)frame
						 background:(UIImage *)background  
						   keyboard:(UIKeyboardType)inputType;

- (DropDown *)selectWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
						  tag:(RegFields)tag;

- (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
						  tag:(RegFields)tag;

- (void)registerForKeyboardNotifications;

- (void) initRegistration;
- (void)disconnectServers;
- (void)RegisterNotifications;
@end
