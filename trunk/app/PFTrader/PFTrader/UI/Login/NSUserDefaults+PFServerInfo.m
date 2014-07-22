#import "NSUserDefaults+PFServerInfo.h"

#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

static NSString* const PFServerField = @"PFServerField";
static NSString* const PFSecureSwitch = @"PFSecureSwitch";

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
       }
       ];
   }
   
   [ self synchronize ];
}

-(PFServerInfo*)liveServerInfo
{
   [ self registerServerDefaults ];
   
   return [ [ PFServerInfo alloc ] initWithServers: [ self stringForKey: PFServerField ]
                                            secure: [ self boolForKey: PFSecureSwitch ] ];
}

-(PFServerInfo*)demoServerInfo
{
   [ self registerServerDefaults ];
   
   return [ [ PFServerInfo alloc ] initWithServers: [ self stringForKey: PFDemoServerField ]
                                            secure: [ self boolForKey: PFDemoSecureSwitch ] ];
}

@end
