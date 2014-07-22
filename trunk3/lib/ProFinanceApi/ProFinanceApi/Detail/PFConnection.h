#import <Foundation/Foundation.h>

@class PFMessage;

@protocol PFConnectionDelegate;

@interface PFConnection : NSObject

@property ( nonatomic, assign ) id< PFConnectionDelegate > delegate;

+(id)connectionWithDelegate:( id< PFConnectionDelegate > )delegate_;

-(BOOL)connectToHost:( NSString* )host_
                port:( UInt16 )port_
              secure:( BOOL )secure_
             useHTTP:( BOOL )use_http_;

-(void)sendMessage:( PFMessage* )message_;

-(void)disconnect;

@end


@protocol PFConnectionDelegate <NSObject>

-(void)connection:( PFConnection* )connection_
didFailParseWithError:( NSError* )error_;

@optional

-(void)connection:( PFConnection* )connection_
didReceiveMessage:( PFMessage* )message_;

-(void)connection:( PFConnection* )connection_
 didFailWithError:( NSError* )error_;

-(void)didAcceptConnection:( PFConnection* )connection_;

@end
