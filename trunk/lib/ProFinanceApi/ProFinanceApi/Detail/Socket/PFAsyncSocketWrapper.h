#import "PFSocket.h"

#import <Foundation/Foundation.h>

@interface PFAsyncSocketWrapper : NSObject< PFSocket >

+(id)socketWithDelegate:( id< PFSocketDelegate > )delegate_;

+(BOOL)useUnsafeSSL;
+(void)setUseUnsafeSSL:( BOOL )use_unsafe_;

@end
