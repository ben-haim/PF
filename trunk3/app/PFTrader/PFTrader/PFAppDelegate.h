#import <UIKit/UIKit.h>

@class PFSession;

@interface PFAppDelegate : UIResponder <UIApplicationDelegate>

@property ( nonatomic, strong ) UIWindow *window;

-(void)applySession:( PFSession* )session_;
-(void)disconnectCurrentSession;
-(void)logoutCurrentSession;
-(void)resetPasswordForLogin:( NSString* )login_;
-(void)connectionFailedWithError:( NSError* )error_;

@end
