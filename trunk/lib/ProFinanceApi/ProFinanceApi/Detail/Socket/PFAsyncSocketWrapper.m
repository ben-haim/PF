#import "PFAsyncSocketWrapper.h"

#import "NSError+ProFinanceApi.h"

#import <AsyncSocket/AsyncSocket.h>

static BOOL use_unsafe_SSL_ = NO;

@interface PFAsyncSocketWrapper ()

@property ( nonatomic, strong ) AsyncSocket* socket;
@property ( nonatomic, weak ) id< PFSocketDelegate > delegate;

@end

@implementation PFAsyncSocketWrapper

@synthesize socket = _socket;
@synthesize delegate;

+(BOOL)useUnsafeSSL
{
   return use_unsafe_SSL_;
}

+(void)setUseUnsafeSSL:( BOOL )use_unsafe_
{
   use_unsafe_SSL_ = use_unsafe_;
}

-(void)dealloc
{
   _socket.delegate = nil;
}

+(id)socketWithDelegate:( id< PFSocketDelegate > )delegate_
{
   PFAsyncSocketWrapper* socket_ = [ PFAsyncSocketWrapper new ];
   socket_.delegate = delegate_;
   return socket_;
}

-(void)disconnect
{
   _socket.delegate = nil;
   [ _socket disconnect ];
   _socket = nil;
}

-(BOOL)connectToHost:( NSString* )host_
                port:( NSInteger )port_
              secure:( BOOL )secure_
{
   NSAssert( !self.socket, @"already connected" );

   NSError* error_ = nil;

   self.socket = [ [ AsyncSocket alloc ] initWithDelegate: self ];
   BOOL result_ = [ self.socket connectToHost: host_
                                       onPort: port_
                                  withTimeout: 15.0
                                        error: &error_ ];

   if ( error_ )
   {
      self.socket.delegate = nil;
      self.socket = nil;

      [ self.delegate socket: self didFailWithError: [ NSError connectionError ] ];
   }
   else if ( secure_ )
   {
      NSDictionary* options_ = use_unsafe_SSL_ ?
      [ NSDictionary dictionaryWithObject: [ NSNumber numberWithBool: NO ]
                                   forKey: ( NSString* )kCFStreamSSLValidatesCertificateChain ] :
      [ NSDictionary dictionaryWithObject: ( NSString* )kCFStreamSocketSecurityLevelNegotiatedSSL
                                   forKey: ( NSString* )kCFStreamSSLLevel ];

      [ self.socket startTLS: options_ ];
   }

   return result_;
}

-(void)onSocketDidDisconnect:( AsyncSocket* )socket_
{
}

-(void)onSocket:(AsyncSocket *)socket_ willDisconnectWithError:(NSError *)error_
{
//   if ( !error_ )
//   {
//      error_ = [ NSError connectionError ];
//   }

   [ self.delegate socket: self didFailWithError: [ NSError connectionError ] ];
}

-(void)onSocket:(AsyncSocket *)socket_ didConnectToHost:(NSString *)host port:(UInt16)port
{
   [ self.delegate didConnectSocket: self ];
}

-(void)onSocket:(AsyncSocket *)socket_ didReadData:(NSData*)data_ withTag:(long)tag
{
   [ self.delegate socket: self didReceiveData: data_ ];
   [ self.socket readDataWithTimeout: -1 tag: 10 ];
}

-(void)onSocket:(AsyncSocket *)socket_ didWriteDataWithTag:(long)tag
{
	[ self.socket readDataWithTimeout: -1 tag: 10 ];
}

-(void)onSocketDidSecure:(AsyncSocket *)sock
{
}

-(void)sendData:( NSData* )data_
{
	[ self.socket writeData: data_ withTimeout: -1 tag: 0 ];
}

@end