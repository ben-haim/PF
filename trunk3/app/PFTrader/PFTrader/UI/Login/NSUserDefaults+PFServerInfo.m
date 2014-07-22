#import "NSUserDefaults+PFServerInfo.h"

#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

static NSString* const PFServerField = @"PFServerField";
static NSString* const PFSecureSwitch = @"PFSecureSwitch";
static NSString* const PFHTTPSwitch = @"PFHTTPSwitch";

static NSString* const PFDemoServerField = @"PFDemoServerField";
static NSString* const PFDemoSecureSwitch = @"PFDemoSecureSwitch";

@implementation NSUserDefaults (PFServerInfo)

-(void)registerServerDefaults
{
   NSString* demo_server_default_ = [ PFBrandingSettings sharedBranding ].defaultDemoServer;
   
   if ( demo_server_default_ )
   {
      [ self registerDefaults:
       @{ PFServerField: [ PFBrandingSettings sharedBranding ].defaultServer
       , PFSecureSwitch: @([ PFBrandingSettings sharedBranding ].useSecure)
       , PFHTTPSwitch: @([ PFBrandingSettings sharedBranding ].useHTTP)
       , PFDemoServerField: [ PFBrandingSettings sharedBranding ].defaultDemoServer
       , PFDemoSecureSwitch: @([ PFBrandingSettings sharedBranding ].useDemoSecure)
       }
       ];
   }
   else
   {
      [ self registerDefaults:
       @{ PFServerField: [ PFBrandingSettings sharedBranding ].defaultServer
       , PFSecureSwitch: @([ PFBrandingSettings sharedBranding ].useSecure)
       , PFHTTPSwitch: @([ PFBrandingSettings sharedBranding ].useHTTP)
       }
       ];
   }
   
   [ self synchronize ];
}

-(PFServerInfo*)liveServerInfo
{
   [ self registerServerDefaults ];
   
   return [ [ PFServerInfo alloc ] initWithServers: [ self stringForKey: PFServerField ]
                                            secure: [ self boolForKey: PFSecureSwitch ]
                                           useHTTP: [ self boolForKey: PFHTTPSwitch ] ];
}

-(PFServerInfo*)demoServerInfo
{
   [ self registerServerDefaults ];
   
   return [ [ PFServerInfo alloc ] initWithServers: [ self stringForKey: PFDemoServerField ]
                                            secure: [ self boolForKey: PFDemoSecureSwitch ]
                                           useHTTP: [ self boolForKey: PFHTTPSwitch ] ];
}

@end
