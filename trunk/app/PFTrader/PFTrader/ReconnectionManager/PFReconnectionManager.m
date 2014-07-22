#import "PFReconnectionManager.h"

#import "PFReconnectionBannerPresenter.h"
#import "PFChangePasswordViewController.h"
#import "PFChangePasswordViewController_iPad.h"
#import "NSError+PFTrader.h"
#import "PFBrandingSettings.h"
#import "PFLayoutManager.h"
#import "PFIpManager.h"
#import "PFAppDelegate.h"

#import <JFFMessageBox/JFFMessageBox.h>

@interface PFReconnectionCancelOblect : NSObject

@property ( nonatomic, assign ) BOOL isCancelled;

@end

@implementation PFReconnectionCancelOblect

@synthesize isCancelled;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.isCancelled = NO;
   }
   return self;
}

@end

@interface PFReconnectionManager () < PFReachabilityDelegate, PFSessionDelegate, UIAlertViewDelegate >

@property ( nonatomic, strong, readonly ) PFAppDelegate* currentAppDelegate;
@property ( nonatomic, strong ) PFReconnectionCancelOblect* cancelObject;
@property ( nonatomic, strong ) PFSession* oldSession;
@property ( nonatomic, strong ) PFSession* createdSession;

-(void)connectCreatedSession;

@end

@implementation PFReconnectionManager

@synthesize login;
@synthesize password;
@synthesize serverInfo;

@synthesize cancelObject;
@synthesize oldSession;
@synthesize createdSession;

+(PFReconnectionManager*)sharedManager
{
   static PFReconnectionManager* shared_manager_;
   static dispatch_once_t onceToken;
   
   dispatch_once( &onceToken,
                 ^{
                    shared_manager_ = [ PFReconnectionManager new ];
                    [ PFReachability sharedReachability ].delegate = shared_manager_;
                 } );
   
   return shared_manager_;
}

-(PFAppDelegate*)currentAppDelegate
{
   return ( PFAppDelegate* )[ UIApplication sharedApplication ].delegate;
}

-(void)connectCreatedSession
{
   [ self.createdSession addDelegate: self ];
   
   if ( ![ self.createdSession connectToServerWithInfo: self.serverInfo ] )
   {
      [ self cancelReconnection ];
      [ self.currentAppDelegate logoutCurrentSession ];
      [ self.currentAppDelegate connectionFailedWithError: [ NSError traderErrorWithDescription: NSLocalizedString( @"CONNECTION_FAILED", nil ) ] ];
   }
}

-(void)cancelReconnection
{
   self.cancelObject.isCancelled = YES;
   
   [ self.createdSession removeDelegate: self ];
   self.oldSession.reconnectionBlock = nil;
   self.createdSession = nil;
   self.oldSession = nil;
   
   [ [ PFReconnectionBannerPresenter sharedPresenter ] dismissReconnection ];
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

#pragma mark - PFReachabilityDelegate

-(void)reachabilityStatusChanged:( PFReachabilityStatus )new_status_
{
   if ( [ PFSession sharedSession ] )
   {
      if ( new_status_ == PFNoReachability )
      {
         self.createdSession = [ PFSession new ];
         self.oldSession = [ PFSession sharedSession ];
         self.cancelObject = [ PFReconnectionCancelOblect new ];
         
         self.oldSession.reconnectionBlock = ^{ [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"RECONNECTING_ALERT_TEXT", nil ) ]; };
         [ self.currentAppDelegate disconnectCurrentSession ];
         [ PFReconnectionBannerPresenter enqueueReconnectionWithTitle: NSLocalizedString( @"RECONNECTING", nil ) ];
         
         PFReconnectionCancelOblect* block_cancel_object_ = self.cancelObject;
         __weak PFReconnectionManager* unsafe_self_ = self;
         
         dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ),
                        ^{
                           dispatch_after( dispatch_time( DISPATCH_TIME_NOW, ( int64_t )( 50.0 * NSEC_PER_SEC ) ), dispatch_get_main_queue(),
                                          ^{
                                             if ( !block_cancel_object_.isCancelled )
                                             {
                                                NSError* no_inet_error_ = [ NSError traderErrorWithDescription: NSLocalizedString( @"NO_INTERNET_CONNECTION", nil ) ];
                                                
                                                [ unsafe_self_ cancelReconnection ];
                                                [ unsafe_self_.currentAppDelegate logoutCurrentSession ];
                                                [ unsafe_self_.currentAppDelegate connectionFailedWithError: no_inet_error_ ];
                                             }
                                          } );
                        } );
      }
      else
      {
         self.cancelObject.isCancelled = YES;
         [ self connectCreatedSession ];
      }
   }
}

#pragma mark - PFSessionDelegate

-(void)didConnectSession:( PFSession* )session_
{
   [ self.createdSession logonWithLogin: self.login
                               password: self.password
                   verificationPassword: nil
                         verificationId: -1
                              ipAddress: [ [ PFIpManager sharedManager ] myIpAddress ] ];
}

-(void)session:( PFSession* )session_
didLogoutWithReason:( NSString* )reason_
{
   [ self.createdSession disconnect ];
   [ [ PFReconnectionBannerPresenter sharedPresenter ] dismissReconnection ];
   [ self.currentAppDelegate connectionFailedWithError: [ NSError traderErrorWithDescription: reason_ ] ];
}

-(void)session:( PFSession* )session_
didFailConnectWithError:( NSError* )error_
{
   [ self.createdSession disconnectServers ];
   
   if ( [ error_.domain isEqualToString: @"kCFStreamErrorDomainSSL" ] )
   {
      __weak PFReconnectionManager* unsafe_self_ = self;
      
      JFFAlertButton* continue_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"OK", nil )
                                                               action: ^( JFFAlertView* sender_ )
                                          {
                                             [ PFSession setUseUnsafeSSL: YES ];
                                             [ unsafe_self_ connectCreatedSession ];
                                          } ];
      
      JFFAlertButton* cancel_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CANCEL", nil )
                                                             action: ^( JFFAlertView* sender_ )
                                        {
                                           [ unsafe_self_ session: unsafe_self_.createdSession didLogoutWithReason: error_.description ];
                                        } ];
      
      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"SSL_CERTIFICATE_WARNING", nil )
                                              cancelButtonTitle: cancel_button_
                                              otherButtonTitles: continue_button_, nil ];
      [ alert_view_ show ];
   }
   else
   {
      [ self session: self.createdSession didLogoutWithReason: error_.description ];
   }
}

-(void)didFinishBlockTransferSession:( PFSession* )session_
{
   self.oldSession.reconnectionBlock = nil;
   
   [ self.createdSession removeDelegate: self ];
   [ self.currentAppDelegate applySession: self.createdSession ];
   [ self.oldSession.delegate didReconnectedSessionWithNewSession: self.createdSession ];
   [ self.oldSession removeAllDelegates ];
   
   [ [ PFLayoutManager currentLayoutManager ] updateMenuItems ];
   [ [ PFReconnectionBannerPresenter sharedPresenter ] dismissReconnection ];
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
         [ [ UIApplication sharedApplication ].keyWindow.rootViewController dismissViewControllerAnimated: YES completion: nil];
         
         if ( changed_ )
         {
            [ self.currentAppDelegate resetPasswordForLogin: self.login ];
            [ self session: self.createdSession didLogoutWithReason: NSLocalizedString( @"CHANGE_PASSWORD_OK", nil ) ];
         }
         else
         {
            [ self session: self.createdSession didLogoutWithReason: NSLocalizedString( @"CHANGE_PASSWORD_CANCELLED", nil ) ];
         }
      };
      
      PFChangePasswordViewController* change_password_controller_ = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ?
      [ PFChangePasswordViewController_iPad createAutoresetPasswordControllerWithSession: self.createdSession andDoneBlock: password_change_block_ ] :
      [ PFChangePasswordViewController createAutoresetPasswordControllerWithSession: self.createdSession andDoneBlock: password_change_block_ ];
      
      [ [ UIApplication sharedApplication ].keyWindow.rootViewController presentViewController: change_password_controller_
                                                                                      animated: YES
                                                                                    completion: nil ];
   }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:( UIAlertView* )alert_view_ clickedButtonAtIndex:( NSInteger )button_index_
{
   NSString* sms_password_ = [ [ alert_view_ textFieldAtIndex: 0 ] text ];
   
   if ( button_index_ == 1 && [ sms_password_ length ] > 0 )
   {
      [ self.createdSession logonWithLogin: self.login
                                  password: self.password
                      verificationPassword: sms_password_
                            verificationId: (int)alert_view_.tag
                                 ipAddress: [ [ PFIpManager sharedManager ] myIpAddress ] ];
   }
   else if ( button_index_ == 0 )
   {
      [ self session: self.createdSession didLogoutWithReason: NSLocalizedString(@"SMS_VERIFICATION_CANCELLED", nil) ];
   }
   else
   {
      [ self session: self.createdSession didLogoutWithReason: NSLocalizedString(@"EMPTY_PASSWORD", nil) ];
   }
}

@end
