#import <Foundation/Foundation.h>

@class PFServerInfo;

@interface PFLoginInfo : NSObject

@property ( nonatomic, strong, readonly ) NSString* login;
@property ( nonatomic, strong, readonly ) NSString* password;
@property ( nonatomic, assign, readonly ) BOOL rememberPassword;

@property ( nonatomic, strong, readonly ) NSString* demoLogin;
@property ( nonatomic, strong, readonly ) NSString* demoPassword;
@property ( nonatomic, assign, readonly ) BOOL rememberDemoPassword;

-(id)initWithLogin:( NSString* )login_
          password:( NSString* )password_
         demoLogin:( NSString* )demo_login_
      demoPassword:( NSString* )demo_password_;

+(id)loginInfoWithContentsOfFile:( NSString* )path_;

-(void)writeToFile:( NSString* )path_;

@end
