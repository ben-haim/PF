#import <Foundation/Foundation.h>

@class ServerConnection;
@class PFMessage;

@protocol PFServerConnectionDelegate< NSObject >

-(void)serverConnection:( ServerConnection* )connection_
      didReceiveMessage:( PFMessage* )message_;

@end
