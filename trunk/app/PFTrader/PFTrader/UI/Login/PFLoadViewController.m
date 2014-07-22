#import "PFLoadViewController.h"

#import "PFReachability.h"
#import "PFBrandingSettings.h"
#import "PFIpManager.h"

#import "NSError+PFTrader.h"
#import "UIColor+Skin.h"

#import "PFChangePasswordViewController.h"
#import "PFChangePasswordViewController_iPad.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFLoadViewController ()< PFSessionDelegate, UIAlertViewDelegate >

@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, strong ) PFServerInfo* serverInfo;
@property ( nonatomic, strong ) PFSession* session;

@end

@implementation PFLoadViewController

@synthesize statusLabel;

@synthesize login;
@synthesize password;
@synthesize serverInfo;

@synthesize session;
@synthesize delegate;

-(void)dealloc
{
   [ self.session removeDelegate: self ];
}

-(id)initWithLogin:( NSString* )login_
          password:( NSString* )password_
        serverInfo:( PFServerInfo* )server_info_
{
   self = [ super initWithNibName: @"PFLoadViewController" bundle: nil ];

   if (self)
   {
      self.login = login_;
      self.password = password_;
      self.serverInfo = server_info_;
   }

   return self;
}

-(void)unsubscribeSession
{
   [ self.session removeDelegate: self ];
}

-(void)loadSession
{
   self.statusLabel.text = NSLocalizedString( @"SERVER_CONNECTING", nil );

   if ( [ PFReachability sharedReachability ].status == PFNoReachability )
   {
      [ self.delegate loadViewController: self
                        didFailWithError: [ NSError traderErrorWithDescription: NSLocalizedString( @"CHECK_NETWORK", nil ) ] ];
      return;
   }

   self.session = [ PFSession new ];
   self.session.dowJonesToken = [ PFBrandingSettings sharedBranding ].dowJonesToken;
   [ self.session addDelegate: self ];

   BOOL connected_ = [ self.session connectToServerWithInfo: self.serverInfo ];
   if ( !connected_ )
   {
      [ self unsubscribeSession ];
      [ self.delegate loadViewController: self
                        didFailWithError: [ NSError traderErrorWithDescription: NSLocalizedString( @"CONNECTION_FAILED", nil ) ] ];
   }
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.view.backgroundColor = [ UIColor mainHighlightedBackgroundColor ];

   [ self loadSession ];
}

-(IBAction)cancelAction:( id )sender_
{
   [ self.session disconnect ];
   [ self.delegate didCancelLoadViewController: self ];
}

#pragma mark - PFSessionDelegate

-(void)didConnectSession:( PFSession* )session_
{
   self.statusLabel.text = NSLocalizedString( @"AUTHENTICATION", nil );
   [ self.session logonWithLogin: self.login
                        password: self.password
            verificationPassword: nil
                  verificationId: -1
                       ipAddress: [ [ PFIpManager sharedManager ] myIpAddress ] ];
}

-(void)session:( PFSession* )session_
didLogoutWithReason:( NSString* )reason_
{
   [ self.session disconnect ];
   [ self.delegate loadViewController: self
                     didFailWithError: [ NSError traderErrorWithDescription: reason_ ] ];
}

-(void)session:( PFSession* )session_ didFailConnectWithError:( NSError* )error_
{
   [ self.session disconnect ];
   
   if ( [ error_.domain isEqualToString: @"kCFStreamErrorDomainSSL" ] )
   {
      JFFAlertButton* continue_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"OK", nil )
                                                               action: ^( JFFAlertView* sender_ )
                                          {
                                             [ PFSession setUseUnsafeSSL: YES ];
                                             [ self loadSession ];
                                          } ];
      
      JFFAlertButton* cancel_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CANCEL", nil )
                                                             action: ^( JFFAlertView* sender_ )
                                        {
                                           [ self.delegate loadViewController: self didFailWithError: error_ ];
                                        } ];
      
      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"SSL_CERTIFICATE_WARNING", nil )
                                              cancelButtonTitle: cancel_button_
                                              otherButtonTitles: continue_button_, nil ];
      [ alert_view_ show ];
   }
   else
   {
      [ self.delegate loadViewController: self didFailWithError: error_ ];
   }
}

-(void)didLogonSession:( PFSession* )session_
{
   self.statusLabel.text = NSLocalizedString( @"READING_DATA", nil );
}

-(void)didFinishBlockTransferSession:( PFSession* )session_
{
   [ self.delegate loadViewController: self didLogonSession: session_ ];
}

-(void)showVerificationViewWithTag:( int )tag_
{
   UIAlertView* alert_view_ = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString(@"VERIFICATION_TITLE", nil)
                                                            message: @""
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"CANCEL", nil)
                                                  otherButtonTitles: NSLocalizedString(@"OK", nil), nil ];
   alert_view_.tag = tag_;
   alert_view_.alertViewStyle = UIAlertViewStylePlainTextInput;
   [ alert_view_ show ];
}

-(void)session:( PFSession* )session_ needVerificationWithId:( int )verification_id_
{
   [ self showVerificationViewWithTag: verification_id_ ];
}

-(void)session:( PFSession* )session_
changePasswordForUser:( int )user_id_
{
   if ( user_id_ != 0 )
   {
      PFChangePasswordDoneBlock password_change_block_ = ^( BOOL changed_ )
      {
         [ self dismissViewControllerAnimated: YES completion: nil];
         
         if ( changed_ )
         {
            if ( [self.delegate respondsToSelector: @selector(loadViewController:didChangePasswordForLogin: ) ] )
            {
               [ self.delegate loadViewController: self didChangePasswordForLogin: self.login ];
            }
            
            [ self session: self.session didLogoutWithReason: NSLocalizedString(@"CHANGE_PASSWORD_OK", nil) ];
         }
         else
         {
            [ self session: self.session didLogoutWithReason: NSLocalizedString(@"CHANGE_PASSWORD_CANCELLED", nil) ];
         }
      };
      
      PFChangePasswordViewController* change_password_controller_ = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ?
      [ PFChangePasswordViewController_iPad createAutoresetPasswordControllerWithSession: session_ andDoneBlock: password_change_block_ ] :
      [ PFChangePasswordViewController createAutoresetPasswordControllerWithSession: session_ andDoneBlock: password_change_block_ ];
      
      [ self presentViewController: change_password_controller_
                          animated: YES
                        completion: nil ];
   }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView: (UIAlertView*)alert_view_ clickedButtonAtIndex: (NSInteger)button_index_
{
   NSString* sms_password_ = [ [ alert_view_ textFieldAtIndex: 0 ] text ];
   
   if ( button_index_ == 1 && [ sms_password_ length ] > 0 )
      [ self.session logonWithLogin: self.login
                           password: self.password
               verificationPassword: sms_password_
                     verificationId: (int)alert_view_.tag
                          ipAddress: [ [ PFIpManager sharedManager ] myIpAddress ] ];
   else if ( button_index_ == 0 )
      [ self session: self.session didLogoutWithReason: NSLocalizedString(@"SMS_VERIFICATION_CANCELLED", nil) ];
   else
      [ self session: self.session didLogoutWithReason: NSLocalizedString(@"EMPTY_PASSWORD", nil) ];
}
@end
