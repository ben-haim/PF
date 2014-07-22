#import "PFApi.h"

#import "PFApiDelegate.h"

#import "PFConnection.h"

#import "PFRequestHandler.h"

#import "PFMessageBuilder.h"
#import "PFMessage.h"
#import "PFField.h"

#import "PFUser.h"
#import "PFRejectMessage.h"
#import "PFRule.h"
#import "PFInstrument.h"

#import "PFServerInfo.h"

#import "NSBundle+PFResources.h"

#import <AsyncDispatcher/ADBlockWrappers.h>

static int verification_id_ = 1;
static NSString* PFTransferFinishedProperty = @"finishblocktransfer";
static NSString* PFRuleProperty = @"RULE";
static NSString* PFReportProperty = @"_REPORTKEY_";

static NSUInteger version_1_7_Major = 1;
static NSUInteger version_1_7_Minor = 7;

@interface PFApi ()< PFConnectionDelegate >

@property ( nonatomic, strong ) PFServerInfo* serverInfo;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, assign, getter=isConnected ) BOOL connected;
@property ( nonatomic, assign ) BOOL transferFinished;
@property ( nonatomic, strong ) PFConnection* connection;
@property ( nonatomic, strong ) PFMessageBuilder* messageBuilder;
@property ( nonatomic, assign ) PFInteger currentRequestId;
@property ( nonatomic, strong ) NSMutableDictionary* handlers;
@property ( nonatomic, strong ) NSDate* serverPingTime;
@property ( nonatomic, assign ) BOOL clientPingScheduled;
@property ( nonatomic, assign ) BOOL serverCheckScheduled;
@property ( nonatomic, assign ) int verificationId;

@end

@implementation PFApi

@synthesize serverInfo;
@synthesize login = _login;
@synthesize password = _password;
@synthesize connected;
@synthesize transferFinished;
@synthesize connection = _connection;
@synthesize messageBuilder = _messageBuilder;
@synthesize currentRequestId;
@synthesize handlers = _handlers;
@synthesize serverPingTime = _serverPingTime;
@synthesize clientPingScheduled;
@synthesize serverCheckScheduled;
@synthesize verificationId;

@synthesize delegate;

-(void)dealloc
{
   _connection.delegate = nil;
}

-(id)initWithDelegate:( id< PFApiDelegate > )delegate_
{
   self = [ super init ];
   if ( self )
   {
      self.delegate = delegate_;
   }
   return self;
}

+(id)apiWithDelegate:( id< PFApiDelegate > )delegate_
{
   return [ [ self alloc ] initWithDelegate: delegate_ ];
}

-(PFMessageBuilder*)messageBuilder
{
   if ( !_messageBuilder )
   {
      _messageBuilder = [ PFMessageBuilder new ];
   }
   return _messageBuilder;
}

-(PFConnection*)connection
{
   if ( !_connection )
   {
      _connection = [ PFConnection connectionWithDelegate: self ];
   }
   return _connection;
}

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_
{
   self.serverInfo = server_info_;

   self.connected = [ self.connection connectToHost: server_info_.host
                                               port: server_info_.port
                                             secure: server_info_.secure
                                            useHTTP: server_info_.useHTTP ];

   self.handlers = [ NSMutableDictionary dictionary ];

   return self.connected;
}

-(void)disconnect
{
   self.handlers = nil;

   self.login = nil;
   self.password = nil;

   self.connected = NO;
   self.transferFinished = NO;

   _connection.delegate = nil;
   [ _connection disconnect ];
   self.connection = nil;
}

-(BOOL)needStoreMessage:( PFMessage* )message_
{
   return ( message_.type == PFMessageLogon
           || message_.type == PFMessageLogout
           || message_.type == PFMessageRefuseOrderAction
           || message_.type == PFMessageOpenPosition
           || message_.type == PFMessageClosePosition
           || message_.type == PFMessageOpenOrder
           || message_.type == PFMessageCancelOrder
           || message_.type == PFMessageReplaceOrder
           || message_.type == PFMessageBusinessReject
           || message_.type == PFMessageTrade
           || message_.type == PFMessageNewOrder );
}

-(void)storeMessage:( PFMessage* )message_
        isMyMessage:( BOOL )is_my_
{
//   NSLog( @"%@: %@", is_my_ ? @"OUT" : @"IN", message_ );
   
   if ( [ self.delegate respondsToSelector: @selector(api:didProcessedMessage:) ] && [ self needStoreMessage: message_ ] )
   {
      static NSDateFormatter* date_formatter_ = nil;
      
      if ( !date_formatter_ )
      {
         date_formatter_ = [ [ NSDateFormatter alloc ] init ];
         date_formatter_.dateStyle = NSDateFormatterMediumStyle;
         date_formatter_.timeStyle = NSDateFormatterMediumStyle;
         date_formatter_.timeZone = [ NSTimeZone systemTimeZone ];
      }

      [ self.delegate api: self didProcessedMessage: [ NSString stringWithFormat: @"%@ %@: %@"
                                                      , [ date_formatter_ stringFromDate: [ NSDate date ] ]
                                                      , is_my_ ? @"OUT" : @"IN"
                                                      , message_ ] ];
   }
}

#pragma mark Commands

-(BOOL)handleMessage:( PFMessage* )message_
{
   PFIntegerField* request_field_ = [ message_ fieldWithId: PFFieldRequestId ];
   if ( !request_field_ )
      return NO;

   PFInteger request_id_ = [ request_field_ integerValue ];
   PFRequestHandler* handler_ = (self.handlers)[@(request_id_)];
   if ( !handler_ )
      return NO;

   handler_.doneBlock( message_ );

   [ self.handlers removeObjectForKey: @(request_id_) ];

   return YES;
}

-(void)addHandler:( PFRequestHandler* )handler_ forMessage:( PFMessage* )message_
{
   (self.handlers)[@(self.currentRequestId)] = handler_;

   [ [ message_ writeFieldWithId: PFFieldRequestId ] setIntegerValue: self.currentRequestId ];

   self.currentRequestId++;
}

-(void)sendMessage:( PFMessage* )message_ doneBlock:( PFRequestDoneBlock )done_block_
{
   NSAssert( self.isConnected, @"api should be connected before any command" );
   [ self storeMessage: message_ isMyMessage: YES ];

   if ( done_block_ )
   {
      PFRequestHandler* handler_ = [ PFRequestHandler new ];
      handler_.doneBlock = done_block_;

      [ self addHandler: handler_ forMessage: message_ ];
   }

   [ self.connection sendMessage: message_ ];
}

-(PFInteger)logonMode
{
   [ self doesNotRecognizeSelector: _cmd ];
   return 0;
}

-(void)logonWithLogin:( NSString* )login_
             password:( NSString* )password_
 verificationPassword:( NSString* )verification_password_
       verificationId:( int )verification_id_
            ipAddress:( NSString* )ip_address_
{
   self.login = login_;
   self.password = password_;
   
   [ self sendMessage: [ self.messageBuilder messageForHello ] doneBlock: ^(PFMessage* message_)
    {
       PFMessage* logon_message_ = [ self.messageBuilder messageForLogonWithLogin: login_
                                                                         password: password_
                                                             verificationPassword:( NSString* )verification_password_
                                                                             mode: [ self logonMode ]
                                                                   encryptionMode: [ (PFLongField*)[ message_ fieldWithId: PFFieldId ] longValue ]
                                                                    encryptionKey: [ [ message_ fieldWithId: PFFieldPassword ] stringValue ]
                                                                        ipAddress: ip_address_ ];
       
       [ self sendMessage: logon_message_ doneBlock: nil ];
       
    } ];
}

-(void)applyNewPassword:( NSString* )new_password_
            oldPassword:( NSString* )old_password_
   verificationPassword:(NSString *)verification_password_
                 userId:( int )user_id_
              accountId:( int )account_id_
{
   [ self sendMessage: [ self.messageBuilder messageForNewPassword: new_password_
                                                       oldPassword: old_password_
                                              verificationPassword: verification_password_
                                                            userId: user_id_ ]
            doneBlock: ^( PFMessage *message_ )
    {
       if ( message_.type == PFMessageBusinessReject )
       {
          // Syntetic error creation
          
          PFRejectMessage* reject_message_ = [ PFRejectMessage objectWithFieldOwner: message_ ];
          
          [ self. delegate api: self
   didLoadChangePasswordStatus: 3
                     andReason: (reject_message_.IsErrorCodeName) ? (reject_message_.nameErrorCode) : (reject_message_.comment) ];
       }
    } ];
}

-(void)ping
{
   [ self sendMessage: [ self.messageBuilder messageForPing ] doneBlock: nil ];
}

-(void)logout
{
   [ self sendMessage: [ self.messageBuilder messageForLogout ] doneBlock: nil ];
}

#pragma mark Ping

-(void)scheduleServerCheck
{
   if ( self.serverCheckScheduled )
      return;

   self.serverCheckScheduled = YES;

   NSTimeInterval server_check_duration_ = 500.0;

   ADQueueBlock check_block_ = ^()
   {
      self.serverCheckScheduled = NO;

      if ( !self.connected )
         return;

      NSTimeInterval time_since_server_ping_ = -[ self.serverPingTime timeIntervalSinceNow ];

      if ( !self.serverPingTime || time_since_server_ping_ > server_check_duration_ )
      {
         [ self.delegate api: self didLogoutWithReason: PFLocalizedString( @"SERVER_TIMEOUT", nil ) ];
      }
      else
      {
         [ self scheduleServerCheck ];
      }
   };

   ADDelayAsyncOnMainThread( check_block_, server_check_duration_ );
}

-(void)scheduleClientPing
{
   if ( self.clientPingScheduled )
      return;

   self.clientPingScheduled = YES;

   ADQueueBlock ping_block_ = ^()
   {
      self.clientPingScheduled = NO;

      if ( self.connected )
      {
         [ self ping ];
         [ self scheduleClientPing ];
      }
   };

   ADDelayAsyncOnMainThread( ping_block_, 30.0 );
}

#pragma mark PFConnectionDelegate

-(void)processMessage:( PFMessage* )message_
{
}

-(void)connection:( PFConnection* )connection_
didFailParseWithError:( NSError* )error_
{
   [ self.delegate api: self didFailParseWithError: error_ ];
}

-(void)connection:( PFConnection* )connection_
didReceiveMessage:( PFMessage* )message_
{
   PFShort message_type_ = message_.type;
   [ self storeMessage: message_ isMyMessage: NO ];
   
   [ self handleMessage: message_ ];
   
   if ( message_type_ == PFMessageLogon )
   {
      BOOL need_sms_verification_ = [ [ message_ fieldWithId: PFFieldNeedVerificationPassword ] boolValue ];
      BOOL need_change_password_ = [ [ message_ fieldWithId: PFFieldPasswordExpired ] boolValue ];
//      int max_server_field_number_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldMaxFieldIndex ] integerValue ];
      NSString* protocol_string_ = [ [ message_ fieldWithId: PFFieldProtocolId ] stringValue ];
      
      if ( need_sms_verification_ )
      {
         self.verificationId = ++verification_id_;
         [ self.delegate api: self needVerificationWithId: self.verificationId ];
      }
      else
      {
         [ self scheduleClientPing ];
         [ self scheduleServerCheck ];
         
         PFUser* user_ = [ PFUser objectWithFieldOwner: message_ ];

         NSArray* version_ = [protocol_string_ componentsSeparatedByString: @"."];
         NSUInteger v_major_ = [(NSNumber*)version_[0] integerValue];
         NSUInteger v_minor_ = [(NSNumber*)version_[1] integerValue];

         user_.wrongServer = (v_major_ > version_1_7_Major) || ((v_major_ == version_1_7_Major) && (v_minor_ > version_1_7_Minor));
//         user_.wrongServer = [ protocol_string_ isEqualToString: @"1.6" ] && max_server_field_number_ < 396;

         [ PFInstrument setServerTimeOffset: user_.timeZoneOffset ];
         
         if ( need_change_password_ )
         {
            [ self.delegate api: self changePasswordForUser: user_.userId ];
         }
         
         [ self.delegate api: self didLogonUser: user_ ];
      }
   }
   else if ( message_type_ == PFMessageLogout )
   {
      NSString* logout_text_ = NSLocalizedString( [ [ message_ fieldWithId: PFFieldText ] stringValue ], nil );
      [ self.delegate api: self didLogoutWithReason: logout_text_ ];
   }
   else if ( message_type_ == PFMessageProperty )
   {
      NSString* name_ = [ [ message_ fieldWithId: PFFieldName ] stringValue ];
      
      if ( [ name_ isEqualToString: PFTransferFinishedProperty ] )
      {
         self.transferFinished = YES;
         [ self.delegate didFinishTransferApi: self ];
      }
      else if ( [ name_ isEqualToString: PFRuleProperty ] )
      {
         PFRule* rule_ = [ PFRule objectWithFieldOwner: message_ ];
         [ self.delegate api: self didLoadRule: rule_ ];
      }
      else if ( [ name_ hasPrefix: PFReportProperty ] )
      {
         NSString* report_name_ = [ name_ stringByReplacingOccurrencesOfString: PFReportProperty withString: @"" ];
         [ self.delegate api: self didAllowReportWithName: report_name_ ];
      }
   }
   else if ( message_type_ == PFMessagePing )
   {
      self.serverPingTime = [ NSDate date ];
   }
   else if ( message_type_ == PFMessageBusinessReject )
   {
      PFRejectMessage* reject_message_ = [ PFRejectMessage objectWithFieldOwner: message_ ];
      [ self.delegate api: self didReceiveRejectMessage: reject_message_ ];
   }
   else if ( message_type_ == PFMessageRoute )
   {
      [ self.delegate api: self didLoadRouteMessage: message_ ];
   }
   else
   {
      [ self processMessage: message_ ];
   }
}

-(void)connection:( PFConnection* )connection_
 didFailWithError:( NSError* )error_
{
   [ self.delegate api: self didFailConnectWithError: error_ ];
}

-(void)didAcceptConnection:( PFConnection* )connection_
{
   [ self.delegate didConnectApi: self ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@<%p> = %@", NSStringFromClass( [ self class ] ), self, self.serverInfo ];
}

@end
