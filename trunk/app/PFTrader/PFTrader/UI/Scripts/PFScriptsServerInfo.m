#import "PFScriptsServerInfo.h"

#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <URLHelpers/URLHelpers.h>

static NSString* const PFScriptsLoginField = @"PFScriptsLoginField";
static NSString* const PFScriptsPasswordField = @"PFScriptsPasswordField";

@interface PFScriptsServerInfo ()

@property ( nonatomic, strong ) NSString* server;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;

@end

@implementation PFScriptsServerInfo

@synthesize server;
@synthesize login;
@synthesize password;

-(id)initWithServer:( NSString* )server_
              login:( NSString* )login_
           password:( NSString* )password_
{
   self = [ super init ];
   if ( self )
   {
      self.server = server_;
      self.login = login_;
      self.password = password_;
   }
   return self;
}

-(id)init
{
   NSString* server_ = [ PFBrandingSettings sharedBranding ].scriptsServer;
   if ( server_.length == 0 )
      return nil;

   NSUserDefaults* user_defaults_ = [ NSUserDefaults standardUserDefaults ];
   [ user_defaults_ synchronize ];

   return [ self initWithServer: server_
                          login: [ user_defaults_ stringForKey: PFScriptsLoginField ]
                       password: [ user_defaults_ stringForKey: PFScriptsPasswordField ] ];
}

-(NSURL*)scriptsURLForSession:( PFSession* )session_
{
   NSMutableDictionary* arguments_ = [ NSMutableDictionary dictionaryWithObjectsAndKeys: session_.serverInfo.activeServer, @"connURL"
                                      , session_.serverInfo.secure ? @"True" : @"False", @"connSecure"
                                      , session_.login, @"connLogin"
                                      , session_.password, @"connPassword"
                                      , nil ];

   [ arguments_ setIfNotNilObject: self.login forKey: @"uLogin" ];
   [ arguments_ setIfNotNilObject: self.password forKey: @"uPassword" ];

   return [ NSURL URLWithString: self.server arguments: arguments_ ];
}

@end
