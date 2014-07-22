#import "PFServerInfo.h"

#include <arpa/inet.h>
#include <netdb.h>

typedef enum
{
   PFServerInfoHostIndex
   , PFServerInfoPortIndex
   , PFServerInfoIndexCount
} PFServerInfoIndex;

@interface PFServerInfo ()

@property ( nonatomic, strong ) NSArray* servers;
@property ( nonatomic, strong ) NSString* serversString;
@property ( nonatomic, strong ) NSString* activeServer;
@property ( nonatomic, assign ) BOOL secure;
@property ( nonatomic, assign ) BOOL useHTTP;
@property ( nonatomic, assign ) NSUInteger currentIndex;

@end

@implementation PFServerInfo

@synthesize activeServer;
@synthesize servers;
@synthesize serversString;
@synthesize secure;
@synthesize useHTTP;
@synthesize currentIndex;

-(void)populateServers
{
   self.currentIndex = 0;
   
   if ( self.serversString )
   {
      self.servers = [ self.serversString componentsSeparatedByString: @"," ];
      
      if ( self.servers && self.servers.count > self.currentIndex )
      {
         self.activeServer = [ self.servers objectAtIndex: self.currentIndex ];
      }
   }
}

-(id)initWithServers:( NSString* )server_
              secure:( BOOL )secure_
             useHTTP:( BOOL )use_http_
{
   self = [ super init ];
   if ( self )
   {
      self.serversString = server_;
      self.secure = secure_;
      self.useHTTP = use_http_;
      
      [ self populateServers ];
   }
   return self;
}

-(id)initWithCoder:( NSCoder* )coder_
{
   self = [ super init ];

   if ( self )
   {
      self.serversString = [ coder_ decodeObjectForKey: @"server" ];
      self.secure = [ coder_ decodeIntForKey: @"secure" ];
      self.useHTTP = [ coder_ decodeIntForKey: @"useHTTP" ];
      
      [ self populateServers ];
   }

   return self;
}

-(void)encodeWithCoder:( NSCoder* )coder_
{
   [ coder_ encodeObject: self.serversString forKey: @"server" ];
   [ coder_ encodeInt: self.secure forKey: @"secure" ];
   [ coder_ encodeInt: self.useHTTP forKey: @"useHTTP" ];
}

-(BOOL)seekToNextServer
{
   if ( self.currentIndex + 1 < self.servers.count )
   {
      self.activeServer = [ self.servers objectAtIndex: ++self.currentIndex ];
      return YES;
   }
   else
   {
      return NO;
   }
}

-(NSString*)componentAtIndex:( NSUInteger )component_index_
{
   static NSString* const host_port_separator_ = @":";
   NSArray* host_port_ = [ self.activeServer componentsSeparatedByString: host_port_separator_ ];
   return component_index_ < [ host_port_ count ] ? [ host_port_ objectAtIndex: component_index_ ] : nil;
}

-(NSString*)host
{
   return [ self componentAtIndex: PFServerInfoHostIndex ];
}

-(UInt16)port
{
   NSString* value_ = [ self componentAtIndex: PFServerInfoPortIndex ];
   return [ value_ length ] > 0 ? [ value_ integerValue ] : 80;
}

-(BOOL)isEqualToServerInfo:( PFServerInfo* )server_info_
{
   return [ self.host isEqualToString: server_info_.host ] && self.port == server_info_.port;
}

-(NSString*)ipAdressFromName:( NSString* )name_
{
   static NSString* const port_separator_ = @":";
   NSArray* componentes_ = [ name_ componentsSeparatedByString: port_separator_ ];
   
   NSString* host_name_;
   NSString* port_;
   
   if ( componentes_.count == 2 )
   {
      host_name_ = [ componentes_ objectAtIndex: 0 ];
      port_ = [ componentes_ objectAtIndex: 1 ];
   }
   else
   {
      host_name_ = name_;
      port_ = @"80";
   }
   
   NSError* error_;
   NSString* ip_pattern_ = @"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
   NSRegularExpression* ip_expression_ = [ NSRegularExpression regularExpressionWithPattern: ip_pattern_
                                                                                    options: 0
                                                                                      error: &error_];
   NSUInteger matches_count_ = [ ip_expression_ numberOfMatchesInString: host_name_
                                                                options: 0
                                                                  range: NSMakeRange(0, host_name_.length) ];
   
   NSString* ip_name_;
   
   // IP
   if ( matches_count_ == 1 )
   {
      ip_name_ = host_name_;
   }
   // Host name
   else
   {
      struct hostent* host_entry_ = gethostbyname([ host_name_ cStringUsingEncoding: NSUTF8StringEncoding ]);
      ip_name_ = [ NSString stringWithUTF8String: inet_ntoa(*((struct in_addr *)host_entry_->h_addr_list[0])) ];
   }

   return [ NSString stringWithFormat: @"%@:%@", ip_name_, port_ ];
}

-(BOOL)isEqualToServer:( NSString* )server_
{
   return [ [ self ipAdressFromName: self.activeServer ] isEqualToString: [ self ipAdressFromName: server_ ] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@; SSL=%d HTTP=%d", self.serversString, self.secure, self.useHTTP ];
}

@end
