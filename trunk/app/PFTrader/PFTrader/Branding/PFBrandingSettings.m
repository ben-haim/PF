#import "PFBrandingSettings.h"

static NSString* const PFScriptsServer = @"PFScriptsServer";
static NSString* const PFAppID = @"PFAppID";
static NSString* const PFDefaultServer = @"PFDefaultServer";
static NSString* const PFDefaultSymbols = @"PFDefaultSymbols";
static NSString* const PFUseChat = @"PFUseChat";
static NSString* const PFUseNews = @"PFUseNews";
static NSString* const PFUseSecure = @"PFUseSecure";
static NSString* const PFUseBrandingSecure = @"PFUseBrandingSecure";
static NSString* const PFUseTransfer = @"PFUseTransfer";
static NSString* const PFUseDemoSecure = @"PFUseDemoSecure";
static NSString* const PFDefaultDemoServer = @"PFDefaultDemoServer";
static NSString* const PFUsePrivateLogs = @"PFUsePrivateLogs";
static NSString* const PFUseChangePassword = @"PFUseChangePassword";
static NSString* const PFBrandingServer = @"PFBrandingServer";
static NSString* const PFBrandingKey = @"PFBrandingKey";
static NSString* const PFShowFundValues = @"PFShowFundValues";
static NSString* const PFShowEquityValue = @"PFShowEquityValue";
static NSString* const PFUseValidityIOC = @"PFUseValidityIOC";

@interface PFBrandingSettings ()

@property ( nonatomic, strong ) NSDictionary* settings;

@end

@implementation PFBrandingSettings

@synthesize settings;

@synthesize dowJonesToken;
@synthesize demoRegistrationServer;
@synthesize ipServices;

-(id)initWithContentsOfFile:( NSString* )file_
{
   self = [ super init ];
   if ( self )
   {
      self.settings = [ NSDictionary dictionaryWithContentsOfFile: file_ ];
   }
   return self;
}

+(PFBrandingSettings*)sharedBranding
{
   static PFBrandingSettings* settings_ = nil;
   if ( !settings_ )
   {
      settings_ = [ [ self alloc ] initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"PFBrandingSettings"
                                                                                              ofType: @"plist" ] ];
   }
   return settings_;
}

-(NSString*)scriptsServer
{
   return [ self.settings objectForKey: PFScriptsServer ];
}

-(NSString*)brandingServer
{
   return [ self.settings objectForKey: PFBrandingServer ];
}

-(BOOL)useBrandingSecure
{
   return [ self.settings objectForKey: PFUseBrandingSecure ];
}

-(BOOL)useValidityIOC
{
    return [ [ self.settings objectForKey: PFUseValidityIOC ]  boolValue ];
}

-(BOOL)showFundValues
{
    return [ [ self.settings objectForKey: PFShowFundValues ] boolValue ];
}

-(BOOL)showEquityValue
{
    return [ [ self.settings objectForKey: PFShowEquityValue ] boolValue ];
}

-(NSString*)brandingKey
{
   return [ self.settings objectForKey: PFBrandingKey ];
}

-(NSString*)appID
{
   return [ self.settings objectForKey: PFAppID ];
}

-(BOOL)useChat
{
   return [ [ self.settings objectForKey: PFUseChat ] boolValue ];
}

-(BOOL)useNews
{
   return [ [ self.settings objectForKey: PFUseNews ] boolValue ];
}

-(BOOL)useSecure
{
   return [ [ self.settings objectForKey: PFUseSecure ] boolValue ];
}

-(BOOL)useTransfer
{
   return [ [ self.settings objectForKey: PFUseTransfer ] boolValue ];
}

-(BOOL)useChangePassword
{
   return [ [ self.settings objectForKey: PFUseChangePassword ] boolValue ];
}

-(NSString*)defaultServer
{
   NSString* s = [ self.settings objectForKey: PFDefaultServer ];
   return s;
}

-(NSArray*)defaultSymbols
{
   return [ self.settings objectForKey: PFDefaultSymbols ];
}

-(BOOL)useDemoSecure
{
   return [ [ self.settings objectForKey: PFUseDemoSecure ] boolValue ];
}

-(NSString*)defaultDemoServer
{
   return [ self.settings objectForKey: PFDefaultDemoServer ];
}

-(BOOL)usePrivateLogs
{
   return [ [ self.settings objectForKey: PFUsePrivateLogs ] boolValue ];
}

@end
