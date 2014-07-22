#import <Foundation/Foundation.h>

#import "PFReachability.h"
#import <ProFinanceApi/ProFinanceApi.h>

@interface PFReconnectionManager : NSObject

@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, strong ) PFServerInfo* serverInfo;

+(PFReconnectionManager*)sharedManager;

-(void)cancelReconnection;

@end
