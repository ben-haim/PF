#import "PFChangePasswordViewController.h"

#import "PFLoginInfo.h"
#import "PFLoadingView.h"
#import "PFTableView.h"
#import "PFTableViewDetailItem.h"
#import "PFTableViewCategory+ChangePassword.h"
#import "UIViewController+Wrapper.h"
#import "PFAppDelegate.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

typedef enum
{
   PFChangePasswordStatusOk = 0
   , PFChangePasswordStatusNeedSMS = 1
   , PFChangePasswordStatusSmsError = 2
   , PFChangePasswordStatusError = 3
} PFChangePasswordStatus;

@interface PFChangePasswordViewController () < PFSessionDelegate, UIAlertViewDelegate >

@property ( nonatomic, strong ) PFLoadingView* loadingView;
@property ( nonatomic, strong ) PFSession* currentSession;
@property ( nonatomic, strong ) NSString* verificationPassword;
@property ( nonatomic, assign ) BOOL autoresetPasswordMode;
@property ( nonatomic, copy ) PFChangePasswordDoneBlock doneBlock;

@end

@implementation PFChangePasswordViewController

@synthesize changeButton;
@synthesize loadingView = _loadingView;

@synthesize currentSession;
@synthesize verificationPassword;
@synthesize autoresetPasswordMode;
@synthesize doneBlock;

//!Workaround for assign delegate
-(void)dealloc
{
   [ self.currentSession removeDelegate: self ];
    self.changeButton = nil;
    self.loadingView = nil;
}

-(PFLoadingView*)loadingView
{
   if ( !_loadingView )
   {
      _loadingView = [ PFLoadingView new ];
   }
   return _loadingView;
}

+(id)changePasswordControllerWithSession:( PFSession* )current_session_
{
   return [ [ PFChangePasswordViewController alloc ] initWithTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil )
                                                        andSession: current_session_ ];
}

+(id)createAutoresetPasswordControllerWithSession:( PFSession* )current_session_
                                     andDoneBlock:( PFChangePasswordDoneBlock )done_block_
{
   PFChangePasswordViewController* change_password_controller_ = [ self changePasswordControllerWithSession: current_session_ ];
   change_password_controller_.autoresetPasswordMode = YES;
   change_password_controller_.doneBlock = done_block_;
   
   return [ change_password_controller_ wrapIntoNavigationController ];
}

-(id)initWithTitle:( NSString* )title_
        andSession:( PFSession* )current_session_
{
   //! bad solution (temp)
   self = [ super initWithNibName: @"PFChangePasswordViewController" bundle: nil ];
   
   if ( self )
   {
      self.title = title_;
      self.currentSession = current_session_;
   }
   return self;
}

-(void)cancel
{
   if ( self.doneBlock )
      self.doneBlock(NO);
}

- (void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.changeButton setTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil ) forState: UIControlStateNormal ];
   
   if ( self.autoresetPasswordMode )
   {
      self.navigationItem.leftBarButtonItem = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                               target: self
                                                                                               action: @selector( changeAction: ) ];
      
      self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel
                                                                                                target: self
                                                                                                action: @selector( cancel ) ];
      self.changeButton.hidden = YES;
   }
   
   [ self.currentSession addDelegate: self ];
   
   self.tableView.categories = [ PFTableViewCategory changePasswordCategories ];
}

-(IBAction)changeAction:(id)sender_
{
   NSString* old_password_ = [ (PFTableViewEditableDetailItem*)[ [ [ self.tableView.categories objectAtIndex: 0 ] items ] objectAtIndex: 0 ] value ];
   NSString* new_password_ = [ (PFTableViewEditableDetailItem*)[ [ [ self.tableView.categories lastObject ]items ] objectAtIndex: 0 ] value ];
   NSString* confirm_password_ = [ (PFTableViewEditableDetailItem*)[ [ [ self.tableView.categories lastObject ]items ] lastObject ] value ];
   
   if ( old_password_.length == 0 )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"EMPTY_PASSWORD", nil ) ];
      return;
   }
   
   if ( [ new_password_ isEqualToString: confirm_password_ ] )
   {
      [ self.loadingView showInView: self.view ];
      
      [ self.currentSession applyNewPassword: new_password_
                                 oldPassword: old_password_
                        verificationPassword: self.verificationPassword
                                      userId: self.currentSession.user.userId ];
   }
   else
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"INCORRECT_CONFIRM_PASSWORD", nil ) ];
   }
}

-(void)showVerificationView
{
   UIAlertView* alert_view_ = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString(@"VERIFICATION_TITLE", nil)
                                                            message: @""
                                                           delegate: self
                                                  cancelButtonTitle: NSLocalizedString(@"CANCEL", nil)
                                                  otherButtonTitles: NSLocalizedString(@"OK", nil), nil ];
   
   alert_view_.alertViewStyle = UIAlertViewStylePlainTextInput;
   [ alert_view_ show ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
loadChangePasswordStatus:( int )change_password_status_
        reason:( NSString* )reason_
{
   [ self.loadingView hide ];
   
   switch ( change_password_status_ )
   {
      case PFChangePasswordStatusOk:
         if ( self.autoresetPasswordMode )
         {
            if ( self.doneBlock )
               self.doneBlock( YES );
         }
         else
         {
            [ self.navigationController popViewControllerAnimated: YES ];
            [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"CHANGE_PASSWORD_OK", nil ) ];
         }
         
         break;
         
      case PFChangePasswordStatusNeedSMS:
         [ self showVerificationView ];
         break;
         
      case PFChangePasswordStatusSmsError:
         [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"CHANGE_PASSWORD_VERIFICATION_WRONG", nil ) ];
         self.verificationPassword = nil;
         break;
         
      default:
         if ( self.autoresetPasswordMode )
         {
            [ JFFAlertView showAlertWithTitle: nil description: reason_ ? NSLocalizedString(reason_, nil) : NSLocalizedString(@"CHANGE_PASSWORD_ERROR", nil) ];
         }
         else if ( !reason_ )
         {
            [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"CHANGE_PASSWORD_ERROR", nil) ];
         }
         
         break;
   }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView: (UIAlertView*)alert_view_ clickedButtonAtIndex: (NSInteger)button_index_
{
   self.verificationPassword = [ [ alert_view_ textFieldAtIndex: 0 ] text ];
   if ( button_index_ == 1 && [ self.verificationPassword length ] > 0 )
   {
      [ self changeAction: nil ];
   }
   else if ( button_index_ == 0 )
   {
      self.verificationPassword = nil;
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"SMS_VERIFICATION_CANCELLED", nil ) ];
   }
   else
   {
      self.verificationPassword = nil;
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"EMPTY_PASSWORD", nil ) ];
   }
}

@end