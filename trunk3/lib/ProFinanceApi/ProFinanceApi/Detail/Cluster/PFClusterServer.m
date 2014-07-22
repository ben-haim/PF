#import "PFClusterServer.h"

#import "PFTradeApi.h"
#import "PFQuoteApi.h"

#import "PFUser.h"

#import "PFSymbol.h"
#import "PFSymbolId.h"

#import "PFServerInfo.h"

#import "PFField.h"
#import "PFMessage.h"

#import "PFSymbolsRouter.h"
#import "PFApiCluster.h"
#import "PFQuoteServerDetails.h"
#import "PFClusterNode.h"

#import "PFApi+Classification.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFClusterServer ()

@property ( nonatomic, strong ) NSMutableDictionary* tradeApiByAccount;
@property ( nonatomic, strong ) NSMutableDictionary* quoteApiByRoute;

@property ( nonatomic, strong ) PFApiCluster* tradesCluster;
@property ( nonatomic, strong ) PFApiCluster* quotesCluster;

@property ( nonatomic, strong ) PFUser* user;

@end

@implementation PFClusterServer

@synthesize tradeApiByAccount = _tradeApiByAccount;
@synthesize quoteApiByRoute = _quoteApiByRoute;

@synthesize tradesCluster = _tradesCluster;
@synthesize quotesCluster = _quotesCluster;

@synthesize user;

@synthesize delegate;

-(void)logonServerWithLogin:(NSString *)login_
                   password:(NSString *)password_
       verificationPassword:(NSString *)verification_password_
             verificationId:(int)verification_id_
                  ipAddress:(NSString *)ip_address_
{
   if ( [ verification_password_ length ] > 0 && verification_id_ > 1 )
   {
      [ [ self commanderForVerificationId: verification_id_ ] logonWithLogin: login_
                                                                    password: password_
                                                        verificationPassword: verification_password_
                                                              verificationId: verification_id_
                                                                   ipAddress: ip_address_ ];
   }
   else
   {
      [ super logonServerWithLogin: login_
                          password: password_
              verificationPassword: verification_password_
                    verificationId: verification_id_
                         ipAddress: ip_address_ ];
   }

}

-(NSMutableDictionary*)tradeApiByAccount
{
   if ( !_tradeApiByAccount )
   {
      _tradeApiByAccount = [ NSMutableDictionary new ];
   }
   return _tradeApiByAccount;
}

-(NSMutableDictionary*)quoteApiByRoute
{
   if ( !_quoteApiByRoute )
   {
      _quoteApiByRoute = [ NSMutableDictionary new ];
   }
   return _quoteApiByRoute;
}

-(PFApiCluster*)tradesCluster
{
   if ( !_tradesCluster )
   {
      _tradesCluster = [ PFApiCluster new ];
   }
   return _tradesCluster;
}

-(PFApiCluster*)quotesCluster
{
   if ( !_quotesCluster )
   {
      _quotesCluster = [ PFApiCluster new ];
   }
   return _quotesCluster;
}

-(void)clean
{
   [ super clean ];

   self.tradeApiByAccount = nil;
   self.quoteApiByRoute = nil;
   self.tradesCluster = nil;
   self.quotesCluster = nil;
   self.user = nil;
}

#pragma mark abstract methods

-(id< PFTradeCommander >)commanderForAccountWithId:( PFInteger )account_id_
{
   return [ self.tradeApiByAccount objectForKey: @(account_id_) ];
}

-(id< PFQuoteCommander >)commanderForRouteWithId:( PFInteger )route_id_
{
   return [ self.quoteApiByRoute objectForKey: @(route_id_) ];
}

-(id< PFCommander >)commanderForVerificationId:( PFInteger )verification_id_
{
   for (PFApi* api_ in self.tradesCluster.apis )
   {
      if ( api_.verificationId == verification_id_ )
         return api_;
   }
   
   return self.primaryApi.verificationId == verification_id_ ? self.primaryApi : nil;
}

-(NSArray*)allApis
{
   return [ self.tradesCluster.apis arrayByAddingObjectsFromArray: self.quotesCluster.apis ];
}

-(NSArray*)logonServers:( NSSet* )servers_
  withPrimaryServerInfo:( PFServerInfo* )primary_server_info_
                  login:( NSString* )login_
               password:( NSString* )password_
                  error:( NSError** )error_
        useClusterNodes:( BOOL )use_cluster_nodes_
{
   static PFByte trade_mode_ = 2;
   NSMutableArray* filtered_servers_ = [ NSMutableArray arrayWithCapacity: [ servers_ count ] ];
   
   if ( use_cluster_nodes_ )
   {
      for ( PFClusterNode* node_ in servers_ )
      {
         if ( node_.connectionMode & trade_mode_ )
         {
            NSString* server_adress_ = primary_server_info_.secure ? node_.adressPFIXS : node_.adressPFIX;
            
            if ( server_adress_ )
               [ filtered_servers_ addObject: server_adress_ ];
         }
      }
   }
   else
   {
      filtered_servers_ = [ [ servers_ allObjects ] mutableCopy ];
   }
   
   NSMutableArray* node_apis_ = [ NSMutableArray arrayWithCapacity: [ servers_ count ] ];
   
   for ( NSString* server_ in filtered_servers_ )
   {
      if ( [ primary_server_info_ isEqualToServer: server_ ] )
         continue;

      PFApi* node_api_ = [ PFTradeApi new ];
      if ( ![ self logonNodeApi: node_api_ server: server_ error: error_ ] )
         return nil;

      [ node_apis_ addObject: node_api_ ];
   }
   
   return node_apis_;
}

-(PFApiCluster*)clusterForApi:( PFApi* )api_
{
   return api_.isTradeApi ? self.tradesCluster : self.quotesCluster;
}

-(void)scheduleLogout
{
   [ self.delegate server: self didLogoutWithReason: @"scheduleLogout" ];
}

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_
{
   BOOL authenticated_before_ = self.user != nil;

   if ( api_ == self.primaryApi )
   {
      NSError* error_ = nil;
      NSArray* apis_ = [ self logonServers: user_.nodes.count > 0 ? user_.nodes : user_.servers
                     withPrimaryServerInfo: self.serverInfo
                                     login: api_.login
                                  password: api_.password
                                     error: &error_
                           useClusterNodes: user_.nodes.count > 0 ];

      if ( error_ )
      {
         [ self.delegate server: self didFailWithFatalError: error_ ];
         return;
      }

      PFApiCluster* trades_cluster_ = [ PFApiCluster clusterWithApis: apis_ ];

      if ( !user_.isAuthenticated )
      {
         //Don't listen primary trade api
         self.primaryApi.delegate = nil;
         self.primaryApi = nil;
      }
      else
      {
         self.user = user_;
         [ trades_cluster_ addApi: self.primaryApi ];
      }

      self.tradesCluster = trades_cluster_;
   }
   else
   {
      self.user = user_;
   }

   if ( !authenticated_before_ && self.user )
   {
      [ self.delegate server: self didLogonUser: user_ ];
   }
}

-(BOOL)tradesTransferFinished
{
   return self.tradesCluster.transferFinished;
}

-(BOOL)quotesTransferFinished
{
   /*quotes finished only when read all trades finished routes reading*/
   return self.tradesCluster.transferFinished && self.quotesCluster.transferFinished;
}

-(void)didFinishTransferApi:( PFApi* )api_
{
   BOOL trades_finished_before_ = self.tradesTransferFinished;
   BOOL quotes_finished_before_ = self.quotesTransferFinished;

   PFApiCluster* cluster_ = [ self clusterForApi: api_ ];
   [ cluster_ transferFinishedApi: api_ ];
   NSLog( @"didFinishTransferApi Cluster: %@", cluster_ );

   if ( !trades_finished_before_ && self.tradesTransferFinished )
   {
      [ self.delegate didFinishTradeTransferServer: self ];
   }

   if ( !quotes_finished_before_ && self.quotesTransferFinished )
   {
      [ self.delegate didFinishQuoteTransferServer: self ];
   }

   if ( self.transferFinished )
   {
      [ self.delegate didFinishTransferServer: self ];
   }
}

-(NSArray*)routersForSymbols:( NSArray* )symbols_
{
   NSMutableDictionary* routers_ = [ NSMutableDictionary new ];
   for ( id< PFSymbolId > symbol_id_ in symbols_ )
   {
      PFSymbolsRouter* router_ = [ routers_ objectForKey: @(symbol_id_.routeId) ];

      if ( !router_ )
      {
         router_ = [ PFSymbolsRouter routerWithCommander: [ self commanderForRouteWithId: symbol_id_.routeId ]
                                                 symbols: nil ];

         [ routers_ setObject: router_ forKey: @(symbol_id_.routeId) ];
      }

      [ router_ addSymbol: symbol_id_ ];
   }
   return [ routers_ allValues ];
}

-(void)api:( PFApi* )api_ didLoadAccountMessage:( PFMessage* )message_
{
   PFInteger account_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldAccountId ] integerValue ];
   [ self.tradeApiByAccount setObject: api_ forKey: @(account_id_) ];
   [ self.delegate server: self didLoadAccountMessage: message_ ];
}

-(void)logonForRouteWithId:( PFInteger )route_id_
          availableServers:( NSArray* )servers_
{
   PFQuoteApi* api_ = [ self.quoteApiByRoute objectForKey: @(route_id_) ];

   if ( api_ )
   {
      PFQuoteServerDetails* server_details_ =
      [ servers_ firstMatch:
       ^BOOL( id server_ )
       {
          return [ [ server_ server ] isEqualToString: api_.serverInfo.activeServer ];
       }];

      if ( server_details_ )
         return;

      api_ = nil;
      [ self.quoteApiByRoute removeObjectForKey: @(route_id_) ];
   }

   if ( api_ )
      return;

   PFQuoteServerDetails* less_loaded_server_ = [ PFQuoteServerDetails lessLoadedServerFrom: servers_ ];
   api_ = ( PFQuoteApi* )[ self.quotesCluster apiWithServer: less_loaded_server_.server ];
   if ( api_ )
   {
      [ self.quoteApiByRoute setObject: api_ forKey: @(route_id_) ];
      return;
   }

   api_ = [ PFQuoteApi new ];
   NSError* error_ = nil;
   if ( ![ self logonNodeApi: api_ server: less_loaded_server_.server error: &error_ ] )
   {
      [ self.delegate server: self didFailWithFatalError: error_ ];
   }
   else
   {
      [ self.quotesCluster addApi: api_ ];
      [ self.quoteApiByRoute setObject: api_ forKey: @(route_id_) ];
   }
}

-(void)api:( PFApi* )api_ didLoadRouteMessage:( PFMessage* )message_
{
   if ( !api_.isTradeApi )
   {
      [ self.delegate server: self didLoadRouteMessage: message_ ];
      return;
   }

   NSArray* quote_servers_;
   
   NSArray* quote_server_groups_ = [ message_ groupFieldsWithId: PFGroupClusterNode ];
   
   if ( [ quote_server_groups_ count ] > 0 )
   {
      quote_servers_ =
      [ quote_server_groups_ map:
       ^id( PFGroupField* qoute_server_group_ )
       {
          PFClusterNode* quote_node_ =  [ self.user clusterNodeWithId: [ [ PFClusterNode objectWithFieldOwner: qoute_server_group_.fieldOwner ] nodeId ] ];
          //! while on server bug, we always connect on HostNode (set in load index to 0)
          PFQuoteServerDetails* server_details_ = [ [ PFQuoteServerDetails alloc ] initWithServer: self.serverInfo.secure ? quote_node_.adressPFIXS : quote_node_.adressPFIX
                                                                                             load: quote_node_.isHostNode ? 0 : 100 /*quote_node_.loadIndex*/ ];
          return server_details_;
       } ];
   }
   else
   {
      quote_servers_ =
      [ [ [ message_ fieldWithId: PFFieldServerIds ] arrayValue ] map:
       ^id( id server_ )
       {
          return [ [ PFQuoteServerDetails alloc ] initWithString: ( NSString* )server_ ];
       }];
   }

   PFInteger route_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldRouteId ] integerValue ];
   [ self logonForRouteWithId: route_id_ availableServers: quote_servers_ ];
}

-(void)removeQuoteApi:( PFApi* )api_
{
   NSMutableDictionary* routes_for_modification_ = [ self.quoteApiByRoute mutableCopy ];

   for ( id route_id_ in self.quoteApiByRoute )
   {
      PFApi* current_api_ = [ self.quoteApiByRoute objectForKey: route_id_ ];
      if ( current_api_ == api_ )
      {
         [ routes_for_modification_ removeObjectForKey: route_id_ ];
      }
   }

   api_.delegate = nil;
   self.quoteApiByRoute = routes_for_modification_;
   [ self.quotesCluster removeApi: api_ ];
}

-(BOOL)handleError:( NSError* )error_
           fromApi:( PFApi* )api_
{
   if ( api_.isTradeApi )
      return NO;

   [ self removeQuoteApi: api_ ];
   return YES;
}

-(BOOL)handleLogoutWithReason:( NSString* )reason_
                      fromApi:( PFApi* )api_
{
   if ( api_.isTradeApi )
      return NO;

   [ self removeQuoteApi: api_ ];
   return YES;
}

@end
