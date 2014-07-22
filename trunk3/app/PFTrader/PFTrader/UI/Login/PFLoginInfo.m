#import "PFLoginInfo.h"

#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface PFLoginInfo ()

@property ( nonatomic, strong ) PFKeychainItemWrapper* passwordKeyChainWrapper;
@property ( nonatomic, strong ) PFKeychainItemWrapper* demoPasswordKeyChainWrapper;

@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, assign ) BOOL rememberPassword;

@property ( nonatomic, strong ) NSString* demoLogin;
@property ( nonatomic, strong ) NSString* demoPassword;
@property ( nonatomic, assign ) BOOL rememberDemoPassword;

@end

@implementation PFLoginInfo

@synthesize login;
@synthesize password;
@synthesize rememberPassword;

@synthesize demoLogin;
@synthesize demoPassword;
@synthesize rememberDemoPassword;

@synthesize passwordKeyChainWrapper;
@synthesize demoPasswordKeyChainWrapper;

-(NSString*)demoPassword
{
   return [ self.demoPasswordKeyChainWrapper objectForKey: (__bridge id)kSecValueData ];
}

-(void)setDemoPassword:( NSString* )demo_password_
{
   if ( [ demo_password_ length ] > 0 )
   {
      [ self.demoPasswordKeyChainWrapper setObject: demo_password_ forKey: (__bridge id)kSecValueData ];
   }
   else
   {
      [ self.demoPasswordKeyChainWrapper resetKeychainItem ];
   }
}

-(NSString*)password
{
   return [ self.passwordKeyChainWrapper objectForKey: (__bridge id)kSecValueData ];
}

-(void)setPassword:( NSString* )password_
{
   if ( [ password_ length ] > 0 )
   {
      [ self.passwordKeyChainWrapper setObject: password_ forKey: (__bridge id)kSecValueData ];
   }
   else
   {
      [ self.passwordKeyChainWrapper resetKeychainItem ];
   }
}

-(void)createPasswordKeyChain
{
   self.passwordKeyChainWrapper = [ [ PFKeychainItemWrapper alloc ] initWithIdentifier: @"PFTraderPassword" accessGroup: nil ];
   [ self.passwordKeyChainWrapper setObject:@"PFTrader_APP_CREDENTIALS" forKey: (__bridge id)kSecAttrService ];
}

-(void)createDemoPasswordKeyChain
{
   self.demoPasswordKeyChainWrapper = [ [ PFKeychainItemWrapper alloc ] initWithIdentifier: @"PFTraderDemoPassword" accessGroup: nil ];
   [ self.demoPasswordKeyChainWrapper setObject:@"PFTrader_APP_DEMO_CREDENTIALS" forKey: (__bridge id)kSecAttrService ];
}

-(id)initWithLogin:( NSString* )login_
          password:( NSString* )password_
  rememberPassword:( BOOL )remember_password_
         demoLogin:( NSString* )demo_login_
      demoPassword:( NSString* )demo_password_
rememberDemoPassword:( BOOL )remember_demo_password_

{
   self = [ super init ];

   if ( self )
   {
      [ self createPasswordKeyChain ];
      [ self createDemoPasswordKeyChain ];
      
      self.login = login_;
      self.password = password_;
      self.rememberPassword = remember_password_;
      
      self.demoLogin = demo_login_;
      self.demoPassword = demo_password_;
      self.rememberDemoPassword = remember_demo_password_;
   }

   return self;
}

-(id)initWithLogin:( NSString* )login_
          password:( NSString* )password_
         demoLogin:( NSString* )demo_login_
      demoPassword:( NSString* )demo_password_
{
   return [ self initWithLogin: login_
                      password: password_
              rememberPassword: [ password_ length ] > 0
                     demoLogin: demo_login_
                  demoPassword: demo_password_
          rememberDemoPassword: [ demo_password_ length ] > 0 ];
}

-(id)initWithCoder:( NSCoder* )coder_
{
   self = [ super init ];

   if ( self )
   {
      [ self createPasswordKeyChain ];
      [ self createDemoPasswordKeyChain ];
      
      self.login = [ coder_ decodeObjectForKey: @"login" ];
      self.rememberPassword = [ coder_ decodeBoolForKey: @"rememberPassword" ];
      
      self.demoLogin = [ coder_ decodeObjectForKey: @"demoLogin" ];
      self.rememberDemoPassword = [ coder_ decodeBoolForKey: @"rememberDemoPassword" ];
   }

   return self;
}

-(void)encodeWithCoder:( NSCoder* )coder_
{
   [ coder_ encodeObject: self.login forKey: @"login" ];
   [ coder_ encodeBool: self.rememberPassword forKey: @"rememberPassword" ];
   
   [ coder_ encodeObject: self.demoLogin forKey: @"demoLogin" ];
   [ coder_ encodeBool: self.rememberDemoPassword forKey: @"rememberDemoPassword" ];
}

+(id)loginInfoWithContentsOfFile:( NSString* )path_
{
   NSData* data_ = [ NSData dataWithContentsOfFile: path_ ];
   if ( !data_ )
      return nil;

   return [ NSKeyedUnarchiver unarchiveObjectWithData: data_ ];
}

-(void)writeToFile:( NSString* )path_
{
   [ NSKeyedArchiver archiveRootObject: self toFile: path_ ];
}

@end
