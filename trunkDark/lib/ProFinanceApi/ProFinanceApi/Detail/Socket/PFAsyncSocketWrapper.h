#import "PFSocket.h"

#import <Foundation/Foundation.h>

@class AsyncSocket;

@interface PFAsyncSocketWrapper : NSObject< PFSocket >

@property ( nonatomic, strong, readonly ) AsyncSocket* socket;
@property ( nonatomic, weak, readonly ) id< PFSocketDelegate > delegate;

+(id)socketWithDelegate:( id< PFSocketDelegate > )delegate_;

+(BOOL)useUnsafeSSL;
+(void)setUseUnsafeSSL:( BOOL )use_unsafe_;

-(void)onSocket:( AsyncSocket* )socket_ didReadData:( NSData* )data_ withTag:( long )tag_;

@end
