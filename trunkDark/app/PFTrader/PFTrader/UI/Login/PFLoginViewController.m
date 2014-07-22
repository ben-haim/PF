#import "PFLoginViewController.h"
#import "PFRegistrationViewController.h"
#import "PFLoginInfo.h"
#import "PFBrandingSettings.h"
#import "PFSegmentedControl.h"
#import "PFTextField.h"
#import "PFSwitch.h"
#import "NSUserDefaults+PFServerInfo.h"
#import "NSObject+KeyboardNotifications.h"
#import "UIViewController+Wrapper.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

static bool visibleDemoRegistrationButton = NO;

@interface PFLoginViewController () < PFRegistrationViewControllerDelegate, PFSegmentedControlDelegate >

@property ( nonatomic, strong ) UITextField* activeTextField;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, strong ) NSString* demoLogin;
@property ( nonatomic, strong ) NSString* demoPassword;
@property ( nonatomic, assign ) BOOL rememberDemoPassword;
@property ( nonatomic, assign ) BOOL rememberPassword;
@property ( nonatomic, assign ) BOOL demoMode;

@end

@implementation PFLoginViewController

@synthesize steelImageView;
@synthesize logoImageView;
@synthesize scrollView;
@synthesize loginField;
@synthesize passwordField;
@synthesize passwordSwitch;
@synthesize loginButton;
@synthesize registerButton;
@synthesize activeTextField;
@synthesize rememberPasswordLabel;
@synthesize serverTypeControl;
@synthesize demoMode = _demoMode;

@synthesize login;
@synthesize password;
@synthesize rememberPassword;
@synthesize demoLogin;
@synthesize demoPassword;
@synthesize rememberDemoPassword;

@synthesize delegate;

-(void)saveLoginInfo
{
   PFLoginInfo* info_ = [ [ PFLoginInfo alloc ] initWithLogin: self.login
                                                     password: self.rememberPassword ? self.password : nil
                                                    demoLogin: self.demoLogin
                                                 demoPassword: self.rememberDemoPassword ? self.demoPassword : nil ];
   [ info_ writeToFile: self.loginInfoPath ];
}

-(void)saveInputValues
{
   if ( self.demoMode )
   {
      self.demoLogin = self.loginField.text;
      self.demoPassword = self.passwordField.text;
      self.rememberDemoPassword = self.passwordSwitch.on;
   }
   else
   {
      self.login = self.loginField.text;
      self.password = self.passwordField.text;
      self.rememberPassword = self.passwordSwitch.on;
   }
}

-(BOOL)demoMode
{
   return _demoMode;
}

-(void)setDemoMode:( BOOL )demo_mode_
{
   _demoMode = demo_mode_;
   
   if ( _demoMode )
   {
      self.loginField.text = self.demoLogin;
      self.passwordField.text = self.demoPassword;
      self.passwordSwitch.on = self.rememberDemoPassword;
   }
   else
   {
      self.loginField.text = self.login;
      self.passwordField.text = self.password;
      self.passwordSwitch.on = self.rememberPassword;
   }
}

-(id)init
{
   self = [ super initWithNibName: @"PFLoginViewController" bundle: nil ];
   if (self)
   {
   }
   return self;
}

-(NSString*)loginInfoPath
{
   NSString* document_directory_ = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ];
   
   return [ document_directory_ stringByAppendingPathComponent: @"PFLoginInfo.plist" ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   PFLoginInfo* info_ = [ PFLoginInfo loginInfoWithContentsOfFile: self.loginInfoPath ];
   
   self.login = info_.login;
   self.password = info_.password;
   self.rememberPassword = info_.rememberPassword;
   self.demoLogin = info_.demoLogin;
   self.demoPassword = info_.demoPassword;
   self.rememberDemoPassword = info_.rememberDemoPassword;
   
   self.loginField.text = self.login;
   self.passwordField.text = self.password;
   self.passwordSwitch.on = self.rememberPassword;

   self.loginField.placeholder = NSLocalizedString( @"LOGIN", nil );
   self.passwordField.placeholder = NSLocalizedString( @"PASSWORD", nil );
   self.rememberPasswordLabel.text = NSLocalizedString( @"REMEMBER_PASSWORD", nil );
   
   self.loginField.backgroundMode = PFTextFieldBackgroundModeTop;
   self.passwordField.backgroundMode = PFTextFieldBackgroundModeBottom;
   
   [ self.loginButton setTitle: NSLocalizedString( @"LOGIN_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.registerButton setTitle: NSLocalizedString( @"REGISTER_BUTTON", nil ) forState: UIControlStateNormal ];
   
   self.serverTypeControl.items = [ NSArray arrayWithObjects: NSLocalizedString(@"LIVE_SERVER", nil), NSLocalizedString(@"DEMO_SERVER", nil), nil ];
   self.serverTypeControl.selectedSegmentIndex = 0;
   
   if ( [ PFBrandingSettings sharedBranding ].defaultDemoServer.length > 0 )
   {
      CGRect old_frame_ = self.logoImageView.frame;
      self.logoImageView.frame = CGRectMake(old_frame_.origin.x, old_frame_.origin.y - 34, old_frame_.size.width, old_frame_.size.height);
   }
   else
   {
      self.serverTypeControl.hidden = YES;
   }
   
   self.demoMode = NO;
   
   self.registerButton.hidden = !visibleDemoRegistrationButton;
}

-(void)resetPasswordForLogin:( NSString* )login_
{
   if ( self.demoMode )
   {
      self.demoPassword = nil;
   }
   else
   {
      self.password = nil;
   }
   
   [ self saveLoginInfo ];
   self.demoMode = _demoMode;
}

-(IBAction)logonAction:( id )sender_
{
   if ( [ self.loginField.text length ] == 0 )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"EMPTY_LOGIN", nil ) ];
      return;
   }
   
   if ( [ self.passwordField.text length ] == 0 )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"EMPTY_PASSWORD", nil ) ];
      return;
   }
   
   
   [ PFSession setUseUnsafeSSL: NO ];
   
   PFServerInfo* server_info_ =  self.demoMode ? [ [ NSUserDefaults standardUserDefaults ] demoServerInfo ] : [ [ NSUserDefaults standardUserDefaults ] liveServerInfo ];
   NSLog( @"Server Info: %@", server_info_ );

   if ( [ server_info_.activeServer length ] == 0 )
      return;

   [ self removeInset ];
   [ self saveInputValues ];
   [ self saveLoginInfo ];

   [ self.delegate loginViewController: self
                    logonUserWithLogin: self.loginField.text
                              password: self.passwordField.text
                            serverInfo: server_info_ ];
}

-(PFRegistrationViewController*)createRegistrationController
{
   return [ [ PFRegistrationViewController alloc ] initWithServerInfo: [ [ PFServerInfo alloc ] initWithServers: [ PFBrandingSettings sharedBranding ].brandingServer
                                                                                                         secure: NO
                                                                                                        useHTTP:[ PFBrandingSettings sharedBranding ].useHTTP ] ];
}

-(IBAction)registerAction:( id )sender_
{
   if ( [ [ PFBrandingSettings sharedBranding ].demoRegistrationServer length ] == 0 )
   {
      PFRegistrationViewController* registration_controller_ = [ self createRegistrationController ];
      registration_controller_.delegate = self;
      
      [ self presentViewController: [ registration_controller_ wrapIntoNavigationController ]
                          animated: YES
                        completion: nil ];
   }
   else
   {
      [ [ UIApplication sharedApplication ] openURL: [ NSURL URLWithString: [ PFBrandingSettings sharedBranding ].demoRegistrationServer ] ];
   }
}

-(void) dealloc
{
   if (!visibleDemoRegistrationButton)
      visibleDemoRegistrationButton = !self.registerButton.hidden;
}

-(void)calculateContentSize
{
   CGRect bottom_view_rect_ = [ self.registerButton convertRect: self.registerButton.bounds toView: self.scrollView ];
   self.scrollView.contentSize = CGSizeMake( self.view.bounds.size.width, CGRectGetMaxY( bottom_view_rect_ ) );
}

-(void)didRotateFromInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
{
   [ self calculateContentSize ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];

   [ self calculateContentSize ];
   [ self subscribeKeyboardNotifications ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self unsubscribeKeyboardNotifications ];
}

-(void)removeInset
{
   self.scrollView.contentInset = UIEdgeInsetsZero;
   self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)didHideKeyboard
{
   [ self removeInset ];
}

-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_
{
   UIEdgeInsets content_inset_ = UIEdgeInsetsZero;
   content_inset_.bottom = height_;

   self.scrollView.contentInset = content_inset_;
   self.scrollView.scrollIndicatorInsets = content_inset_;

   CGRect login_button_rect_ = [ self.loginButton convertRect: self.loginButton.bounds toView: self.scrollView ];
   [ self.scrollView scrollRectToVisible: login_button_rect_ animated: YES ];
}

#pragma mark PFRegistrationViewControllerDelegate


-(void)registrationController:( PFRegistrationViewController* )registration_controller_
         didCreateDemoAccount:( id< PFDemoAccount > )demo_account_
{
   self.loginField.text = demo_account_.login;
   self.passwordField.text = demo_account_.password;

   [ registration_controller_ dismissViewControllerAnimated: YES completion: nil];
}

-(void)didCancelRegistrationController:( PFRegistrationViewController* )registration_controller_
{
   [ registration_controller_ dismissViewControllerAnimated: YES completion: nil ];
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:( UITextField* )text_field_
{
   self.activeTextField = text_field_;
}

-(BOOL)textFieldShouldReturn:( UITextField* )text_field_
{
   [ text_field_ resignFirstResponder ];
   return YES;
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_ didSelectItemAtIndex:( NSInteger )index_
{
   [ self saveInputValues ];
   self.demoMode = ( index_ != 0 );
}

@end
