#import "PFAppDelegate.h"

#import "PFLoginViewController.h"
#import "PFLoadViewController.h"
#import "PFModalWindow.h"
#import "CustomIOS7AlertView.h"

#import "PFSystemHelper.h"
#import "PFSettings.h"
#import "PFLayoutManager.h"
#import "PFVersionManager.h"
#import "PFBrandingSettings.h"
#import "PFPrivateLogsManager.h"
#import "PFSoundManager.h"
#import "PFReconnectionManager.h"
#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <NotificationBanner/NotificationBanner.h>
#import <JFFMessageBox/JFFMessageBox.h>

static NSString* const PFAutoLockSwitch = @"PFAutoLockSwitch";

@interface PFAppDelegate ()< PFLoginViewControllerDelegate, PFLoadViewControllerDelegate, PFSessionDelegate, PFBrandingManagerDelegate, UIWebViewDelegate >

@property ( nonatomic, strong ) PFLoginViewController* loginController;
@property ( nonatomic, strong ) PFLoadViewController* loadController;
@property ( nonatomic, assign ) UIBackgroundTaskIdentifier backGroundTaskId;

@property ( nonatomic, strong ) NSString* connectionLogin;
@property ( nonatomic, strong ) NSString* connectionPassword;
@property ( nonatomic, strong ) PFServerInfo* connectionServerInfo;

@end

@implementation PFAppDelegate

@synthesize window;

@synthesize loginController = _loginController;
@synthesize loadController = _loadController;
@synthesize backGroundTaskId;

@synthesize connectionLogin;
@synthesize connectionPassword;
@synthesize connectionServerInfo;

-(PFLoginViewController*)loginController
{
   if ( !_loginController )
   {
      _loginController = [ [ PFLayoutManager currentLayoutManager ] loginViewController ];
      _loginController.delegate = self;
   }
   return _loginController;
}

-(void)disconnectCurrentSession
{
   PFSession* session_ = [ PFSession sharedSession ];
   
   if ( session_ )
   {
      [ UIApplication sharedApplication ].idleTimerDisabled = NO;
      
      [ session_ disconnectServers ];
      [ session_ removeDelegate: self ];
   }
}

-(void)logoutSession:( PFSession* )session_
{
   [ [ PFReconnectionManager sharedManager ] cancelReconnection ];
   [ self disconnectCurrentSession ];
   [ session_ disconnect ];
   [ session_ removeDelegate: [ PFSoundManager sharedManager ] ];
   [ PFSession setSharedSession: nil ];
   
   for ( MZFormSheetController* sheet_controller_ in [ MZFormSheetController formSheetControllersStack ] )
   {
      [ sheet_controller_ mz_dismissFormSheetControllerAnimated: NO completionHandler: nil ];
   }
   
   self.window.rootViewController = self.loginController;
}

-(void)logoutCurrentSession
{
   [ self logoutSession: [ PFSession sharedSession ] ];
}

-(void)resetPasswordForLogin:( NSString* )login_
{
   [ self.loginController resetPasswordForLogin: login_ ];
}

-(void)applySession:( PFSession* )session_
{
   [ UIApplication sharedApplication ].idleTimerDisabled = NO;
   [ UIApplication sharedApplication ].idleTimerDisabled = ![ self shouldAutoLock ];
   
   session_.defaultSymbolNames = [ PFBrandingSettings sharedBranding ].defaultSymbols;
   [ PFSession setSharedSession: session_ ];
   [ session_ addDelegate: self ];
   [ session_ addDelegate: [ PFSoundManager sharedManager ] ];
}

-(void)connectionFailedWithError:( NSError* )error_
{
   self.window.rootViewController = self.loginController;
   [ error_ showAlertWithTitle: nil ];
}

-(BOOL)shouldAutoLock
{
   [ [ NSUserDefaults standardUserDefaults ] synchronize ];
   return [ [ NSUserDefaults standardUserDefaults ] boolForKey: PFAutoLockSwitch ];
}

-(void)showMessage:( NSString* )message_
         withTitle:( NSString* )title_
{
   UILocalNotification* local_notification_ = [ UILocalNotification new ];
   if ( local_notification_ )
   {
      local_notification_.alertBody = message_ ? [ title_ stringByAppendingFormat: @". %@", message_ ] : title_;
      [ [ UIApplication sharedApplication ] presentLocalNotificationNow: local_notification_ ];
   }
   
   [ JCNotificationBannerPresenter enqueueNotificationWithTitle: NSLocalizedString( title_, nil )
                                                        message: message_
                                                     tapHandler: nil ];
}

#pragma mark - PFLoginViewControllerDelegate

-(void)loginViewController:( PFLoginViewController* )controller_
        logonUserWithLogin:( NSString* )login_
                  password:( NSString* )password_
                serverInfo:( PFServerInfo* )server_info_
{
   self.connectionLogin = login_;
   self.connectionPassword = password_;
   self.connectionServerInfo = server_info_;
   
   self.loadController = [ [ PFLayoutManager currentLayoutManager ] loadViewControllerWithLogin: login_
                                                                                       password: password_
                                                                                     serverInfo: server_info_ ];

   self.loadController.delegate = self;
   self.window.rootViewController = self.loadController;
}

#pragma mark - PFLoadViewControllerDelegate

-(void)loadViewController:( PFLoadViewController* )controller_
          didLogonSession:( PFSession* )session_
{
   [ self applySession: session_ ];
   
   self.loadController.delegate = nil;
   self.loadController = nil;
   
   self.loginController.delegate = nil;
   self.loginController = nil;
   
   [ PFReconnectionManager sharedManager ].login = self.connectionLogin;
   [ PFReconnectionManager sharedManager ].password = self.connectionPassword;
   [ PFReconnectionManager sharedManager ].serverInfo = self.connectionServerInfo;
   
   self.window.rootViewController = [ [ PFLayoutManager currentLayoutManager ] menuViewController ];
}

-(void)loadViewController:( PFLoadViewController* )controller_
         didFailWithError:( NSError* )error_
{
   self.loadController.delegate = nil;
   self.loadController = nil;
   self.window.rootViewController = self.loginController;
   
   [ self connectionFailedWithError: error_ ];
}

-(void)loadViewController:( PFLoadViewController* )controller_
didChangePasswordForLogin:( NSString* )login_
{
   [ self resetPasswordForLogin: login_ ];
}

-(void)didCancelLoadViewController:( PFLoadViewController* )controller_
{
   self.loadController.delegate = nil;
   self.loadController = nil;
   
   self.window.rootViewController = self.loginController;
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didProcessMessage:( NSString* )message_
{
   if ( [ [ PFBrandingSettings sharedBranding ] usePrivateLogs ] )
   {
      [ [ PFPrivateLogsManager manager ] writeToLog: message_ ];
   }
}

-(void)session:( PFSession* )session_
didLogoutWithReason:( NSString* )reason_
{
   if ( !session_.reconnectionBlock )
   {
      [ JFFAlertView showAlertWithTitle: nil description: reason_ ];
      [ self logoutSession: session_ ];
   }
}

-(void)session:( PFSession* )session_
didReceiveErrorMessage:( NSString* )message_
{
   if ( [ message_ length ] > 0 )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( message_, nil ) ];
   }
}

-(void)session:( PFSession* )session_
didReceiveBrockerMessage:( NSString* )message_
withCancelMode:( BOOL )cancel_mode_
{
   if ( [ message_ length ] > 0 )
   {
      UIView* message_view_ = [ [ UIView alloc ] initWithFrame: CGRectMake( 0, 0, 290, 200 ) ];
      UIWebView* message_browser_ = [ [ UIWebView alloc ] initWithFrame: CGRectMake( 10, 10, 270, 180 ) ];
      message_browser_.delegate = self;
      [ message_browser_ loadHTMLString: message_ baseURL: nil ];
      [ message_view_ addSubview: message_browser_ ];
      
      CustomIOS7AlertView* alert_view_ = [ [ CustomIOS7AlertView alloc ] initWithParentView: self.window.rootViewController.view ];
      [ alert_view_ setContainerView: message_view_ ];
      [ alert_view_ setButtonTitles: [ NSMutableArray arrayWithObjects: NSLocalizedString( @"OK", nil ), NSLocalizedString( @"CANCEL", nil ), nil ] ];
      [ alert_view_ setDelegate: self ];
      [ alert_view_ setUseMotionEffects: YES ];
      
      [ alert_view_ show ];
   }
}

-(void)session:( PFSession* )session_ overnightNotificationForAccountId:( PFInteger )account_id_
maintanceMargin:( PFDouble )maintance_margin_
availableMargin:( PFDouble )available_margin_
          date:( NSDate* )date_
{
   NSString* date_string_ = [ NSString stringWithFormat: NSLocalizedString( @"OVERNIGHT_WARNING", nil ), [ date_ shortTimestampString ] ];
   NSString* account_string_ = [ NSString stringWithFormat: @"%@: %@", NSLocalizedString( @"ACCOUNT", nil ), [ [ PFSession sharedSession ].accounts accountNameWithId: account_id_ ] ];
   NSString* available_string_ = [ NSString stringWithFormat: @"%@: %@", NSLocalizedString( @"AVAILABLE_MARGIN", nil ), [ NSString stringWithMoney: available_margin_ ] ];
   NSString* maintance_string_ = [ NSString stringWithFormat: @"%@: %@", NSLocalizedString( @"MAINTANCE_MARGIN", nil ), [ NSString stringWithMoney: maintance_margin_ ] ];
   NSString* overnight_string_ = [ NSString stringWithFormat: @"%@: %@", NSLocalizedString( @"OVERNIGHT_MARGIN", nil ), [ NSString stringWithMoney: available_margin_ - maintance_margin_ ] ];
   
   [ JFFAlertView showAlertWithTitle: nil
                         description: [ NSString stringWithFormat: @"%@\n\n%@\n%@\n%@\n%@"
                                       , date_string_
                                       , account_string_
                                       , available_string_
                                       , maintance_string_
                                       , overnight_string_ ] ];
}

-(void)wrongServerWithSession:(PFSession *)session_
{
   JFFAlertButton* button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CANCEL", nil )
                                                   action: ^( JFFAlertView* sender_ ) { [ self logoutCurrentSession ]; } ];
   
   JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                     message: NSLocalizedString( @"WRONG_SERVER_TEXT", nil )
                                           cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                           otherButtonTitles: button_, nil ];
   
   [ alert_view_ show ];
}

-(void)session:( PFSession* )session_
 didLoadReport:( id< PFReportTable > )report_
{
   [ self showMessage: nil withTitle: report_.name ];
}

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_
{
   if ( message_.senderId != session_.user.userId )
   {
      [ self showMessage: NSLocalizedString( @"NEW_CHAT_MESSAGE", nil ) withTitle: message_.text ];
   }
}

-(void)session:( PFSession* )session_
didReceiveTradingHaltForSymbol:( id< PFSymbol > )symbol_
{
    if ( [ PFSettings sharedSettings ].showTradingHalt )
    {
        NSString* alert_title_ = [ NSString stringWithFormat: @"%@ - %@", NSLocalizedString( @"TRADING_HALT_TITLE", nil ), symbol_.name ];
        NSString* alert_text_ = [ NSString stringWithFormat: NSLocalizedString( @"TRADING_HALT_TEXT_FORMAT", nil ), symbol_.name ];
        
        JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: alert_title_
                                                          message: alert_text_
                                                cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                                otherButtonTitles: nil ];
        
        [ alert_view_ show ];
    }
}

#pragma mark - CustomIOS7AlertViewDelegate

-(void)customIOS7dialogButtonTouchUpInside:( CustomIOS7AlertView* )alert_view_ clickedButtonAtIndex:( NSInteger )button_index_
{
   [ alert_view_ close ];
   
   if ( button_index_ == 1 )
   {
      [ self logoutCurrentSession ];
   }
}

#pragma mark - PFBrandingManagerDelegate

-(void)brandingManager:( PFBrandingManager* )branding_manager_
      didFailWithError:( NSError* )error_
{
   
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:( UIWebView* )web_view_ shouldStartLoadWithRequest:( NSURLRequest* )request_ navigationType:( UIWebViewNavigationType )type_
{
   if ( type_ == UIWebViewNavigationTypeLinkClicked )
   {
      [ [ UIApplication sharedApplication ] openURL: [ request_ URL ] ];
      return NO;
   }
   
   return YES;
}

#pragma mark - UIApplicationDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   if ( useFlatUI() )
   {
      [ [ UITextField appearance ] setKeyboardAppearance: UIKeyboardAppearanceDark ];
   }
   
   [ [ NSUserDefaults standardUserDefaults ] registerDefaults: @{ PFAutoLockSwitch: @(YES) } ];
   [ PFVersionManager checkVersion ];
   
   self.window = [ [ UIWindow alloc ] initWithFrame: [ [ UIScreen mainScreen ] bounds ] ];
   // Override point for customization after application launch.
   
   self.window.rootViewController = self.loginController;
   [ self.window makeKeyAndVisible ];
   
   if ( [ PFBrandingSettings sharedBranding ].brandingServer.length > 0 && [ PFBrandingSettings sharedBranding ].brandingKey.length > 0 )
   {
      [ [ [ PFBrandingManager alloc ] initWithDelegate: self
                                        brandingServer: [ PFBrandingSettings sharedBranding ].brandingServer
                                           brandingKey: [ PFBrandingSettings sharedBranding ].brandingKey ] getBrandingWithDoneBlock: ^(NSDictionary *result_, NSError *error_)
       {
          [ PFBrandingSettings sharedBranding ].dowJonesToken = [ result_ objectForKey: @"BRANDING_DOWJONES_ENCRYPTED_TOKEN" ];
          [ PFBrandingSettings sharedBranding ].demoRegistrationServer = [ result_ objectForKey: @"BRANDING_DEMOREGISTRATION_URL" ];
          [ PFBrandingSettings sharedBranding ].ipServices = [ [ result_ objectForKey: @"BRANDING_IP_SERVICE_URL" ] componentsSeparatedByString: @";" ];
          
          self.loginController.registerButton.hidden = [ [ PFBrandingSettings sharedBranding ].demoRegistrationServer isEqualToString: @"0" ];
          
       } ];
   }
   
   return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   if ( [ [ UIDevice currentDevice ] isMultitaskingSupported ] )
   {
      self.backGroundTaskId = [ [ UIApplication sharedApplication ] beginBackgroundTaskWithExpirationHandler:
                               ^{
                                  [ self logoutCurrentSession ];
                                  
                                  [ [ UIApplication sharedApplication ] endBackgroundTask: self.backGroundTaskId ];
                                  self.backGroundTaskId = UIBackgroundTaskInvalid;
                               }];
      
//       //Background tasks require you to use asyncrous tasks
//       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//       ^{
//       NSLog(@"\n\nRunning in the background!\n\n");
//       
//       [ [ UIApplication sharedApplication ] endBackgroundTask: self.backGroundTaskId ];
//       self.backGroundTaskId = UIBackgroundTaskInvalid;
//       });
   }
   else
   {
      [ self logoutCurrentSession ];
   }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   [ [ UIApplication sharedApplication ] endBackgroundTask: self.backGroundTaskId ];
   self.backGroundTaskId = UIBackgroundTaskInvalid;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   [ PFSoundManager destroySharedManager ];
}

@end
