#import <Foundation/Foundation.h>

@class PFServerInfo;

@interface NSUserDefaults (PFServerInfo)

-(PFServerInfo*)liveServerInfo;
-(PFServerInfo*)demoServerInfo;

@end
