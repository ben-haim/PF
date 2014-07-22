#import "PFConnection.h"

#import "PFMessage.h"

#import "PFAsyncSocketWrapper.h"
#import "PFHTTPAsyncSocketWrapper.h"

#import "NSError+ProFinanceApi.h"
#import "NSBundle+PFResources.h"

#import <AsyncDispatcher/AsyncDispatcher.h>

@interface PFConnection ()< PFSocketDelegate >

@property ( nonatomic, strong ) id< PFSocket > socket;
@property ( nonatomic, strong ) NSData* tail;
@property ( nonatomic, strong ) id< ADQueue > parseQueue;

@property ( nonatomic, assign ) BOOL useHTTPConnection;

@end

@implementation PFConnection

@synthesize delegate;
@synthesize socket = _socket;
@synthesize tail = _tail;
@synthesize parseQueue;
@synthesize useHTTPConnection;

-(void)dealloc
{
   [ self disconnect ];
}

-(id)initWithDelegate:( id< PFConnectionDelegate > )delegate_
{
   self = [ super init ];
   if ( self )
   {
      self.delegate = delegate_;
   }
   return self;
}

+(id)connectionWithDelegate:( id< PFConnectionDelegate > )delegate_
{
   return [ [ self alloc ] initWithDelegate: delegate_ ];
}

-(id< PFSocket >)socket
{
   if ( !_socket )
   {
      _socket = self.useHTTPConnection ? [ PFHTTPAsyncSocketWrapper new ] : [ PFAsyncSocketWrapper new ];
      [ _socket setDelegate: self ];
   }
   return _socket;
}

-(void)disconnect
{
   self.tail = nil;
   [ _socket setDelegate: nil ];
   [ _socket disconnect ];
   _socket = nil;

   [ self.parseQueue cancel ];
   self.parseQueue = nil;
}

-(BOOL)connectToHost:( NSString* )host_
                port:( UInt16 )port_
              secure:( BOOL )secure_
             useHTTP:( BOOL )use_http_
{
   self.useHTTPConnection = use_http_;
   
	BOOL connected_ = [ self.socket connectToHost: host_
                                            port: port_
                                          secure: secure_ ];

   if ( connected_ )
   {
      [ self.parseQueue cancel ];
      self.parseQueue = ADCreateSequenceQueue( @"PFConnection.parseQueue" );
   }

   return connected_;
}

-(void)processData:( NSData* )data_
{
   NSData* response_data_ = data_;
   
   if ( self.tail )
   {
      NSMutableData* joined_data_ = [ NSMutableData dataWithData: self.tail ];
      [ joined_data_ appendData: data_ ];
      response_data_ = joined_data_;
   }
   
   @try
   {
      NSData* tail_ = nil;
      NSArray* messages_ = [ NSArray arrayOfMessagesWithData: response_data_ tail: &tail_ ];
      self.tail = tail_;
      
      //NSLog( @"Messages count: %d", [ messages_ count ] );
      
      for ( PFMessage* message_ in messages_ )
      {
         if ( message_.type == PFMessageLevel1Quote || message_.type == PFMessageLevel4Quote )
         {
            [ self.delegate connection: self didReceiveMessage: message_ ];
         }
         else
         {
            ADAsyncOnMainThread( ^() { [ self.delegate connection: self didReceiveMessage: message_ ]; } );
         }
      }
   }
   @catch ( NSException* exception_ )
   {
      ADAsyncOnMainThread(^() { [ self.delegate connection: self didFailParseWithError: [ NSError PFErrorWithDescription: [ exception_ reason ] ] ]; } );
   }
}

-(void)sendMessage:( PFMessage* )message_
{
   [ self.socket sendData: [ message_ data ] ];
}

#pragma mark - PFSocketDelegate

-(void)didConnectSocket:( id< PFSocket > )socket_
{
   [ self.delegate didAcceptConnection: self ];
}

-(void)socket:( id< PFSocket > )socket_ didFailWithError:( NSError* )error_
{
    //! Don't change!!! If just run in main thread, then the latest messages from the socket will not processed 
   [ self.parseQueue async: ^(){ ADAsyncOnMainThread(^() { [ self.delegate connection: self didFailWithError: error_ ]; } ); } ];
}

-(void)socket:( id< PFSocket > )socket_ didReceiveData:( NSData* )data_
{
   [ self.parseQueue async: ^(){ [ self processData: data_ ]; } ];
}

@end

@implementation NSObject (PFConnectionDelegate)

-(void)connection:( PFConnection* )connection_
didReceiveMessage:( PFMessage* )message_
{
}

-(void)connection:( PFConnection* )connection_
 didFailWithError:( NSError* )error_
{
}

-(void)didAcceptConnection:( PFConnection* )connection_
{
}

@end


