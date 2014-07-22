#import <Foundation/Foundation.h>

@interface PFIpManager : NSObject

+(PFIpManager*)sharedManager;

-(NSString*)myIpAddress;

@end
