#import <Foundation/Foundation.h>

@interface PFServerInfo : NSObject

@property ( nonatomic, strong, readonly ) NSString* host;
@property ( nonatomic, assign, readonly ) UInt16 port;
@property ( nonatomic, assign, readonly ) BOOL secure;
@property ( nonatomic, strong, readonly ) NSString* activeServer;

-(id)initWithServers:( NSString* )servers_
              secure:( BOOL )secure_;

-(BOOL)isEqualToServerInfo:( PFServerInfo* )server_info_;

-(BOOL)isEqualToServer:( NSString* )server_;

-(BOOL)seekToNextServer;

@end
