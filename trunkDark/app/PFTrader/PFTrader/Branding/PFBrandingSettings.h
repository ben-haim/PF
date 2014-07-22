#import <Foundation/Foundation.h>

@interface PFBrandingSettings : NSObject

@property ( nonatomic, strong ) NSString* dowJonesToken;
@property ( nonatomic, strong ) NSString* demoRegistrationServer;
@property ( nonatomic, strong ) NSArray* ipServices;

@property ( nonatomic, strong, readonly ) NSArray* defaultSymbols;
@property ( nonatomic, strong, readonly ) NSString* brandingServer;
@property ( nonatomic, strong, readonly ) NSString* brandingKey;
@property ( nonatomic, strong, readonly ) NSString* scriptsServer;
@property ( nonatomic, strong, readonly ) NSString* appID;
@property ( nonatomic, strong, readonly ) NSString* defaultServer;
@property ( nonatomic, strong, readonly ) NSString* defaultDemoServer;
@property ( nonatomic, assign, readonly ) BOOL useSecure;
@property ( nonatomic, assign, readonly ) BOOL useHTTP;
@property ( nonatomic, assign, readonly ) BOOL useDemoSecure;
@property ( nonatomic, assign, readonly ) BOOL useChat;
@property ( nonatomic, assign, readonly ) BOOL useNews;
@property ( nonatomic, assign, readonly ) BOOL useTransfer;
@property ( nonatomic, assign, readonly ) BOOL usePrivateLogs;

+(PFBrandingSettings*)sharedBranding;

@end
