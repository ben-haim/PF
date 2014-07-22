#import "PFServerFactory.h"

#import "PFApiDelegate.h"

#import "PFTradeApi.h"

#import "PFSolidServer.h"
#import "PFClusterServer.h"
#import "PFServerInfo.h"

#import "PFPrimaryServerDetails.h"

#import "NSError+ProFinanceApi.h"

@interface PFServerFactory ()< PFApiDelegate >

@property ( nonatomic, strong ) PFServerInfo* serverInfo;
@property ( nonatomic, strong ) PFTradeApi* tradeApi;
@property ( nonatomic, assign ) BOOL activeServerFinded;

@end

@implementation PFServerFactory

@synthesize serverInfo;
@synthesize tradeApi;
@synthesize delegate;

@synthesize activeServerFinded;

+(id)factoryWithServerInfo:( PFServerInfo* )server_info_
{
   PFServerFactory* factory_ = [ self new ];
   factory_.serverInfo = server_info_;
   factory_.activeServerFinded = NO;
   return factory_;
}

-(BOOL)connect
{
   NSAssert( !self.tradeApi, @"api already initialized" );

   self.tradeApi = [ PFTradeApi apiWithDelegate: self ];

   BOOL connected_ = [ self.tradeApi connectToServerWithInfo: self.serverInfo ];

   if ( connected_ )
   {
       [ self.tradeApi serverDetailsWithDoneBlock: ^( PFPrimaryServerDetails* details_, NSError* error_ )
        {
            self.activeServerFinded = YES;

            [ self disconnect ];

            self.tradeApi = [ PFTradeApi apiWithDelegate: self ];
            [ self.tradeApi connectToServerWithInfo: self.serverInfo ];

            [ self.delegate serverFactory: self
                         didConnectServer: details_.cluster ? [ PFClusterServer serverWithPrimaryApi: self.tradeApi ] : [ PFSolidServer serverWithPrimaryApi: self.tradeApi ] ];
        } ];
   }

   return connected_;
}

-(void)disconnect
{
   self.tradeApi.delegate = nil;
   [ self.tradeApi disconnect ];
   self.tradeApi = nil;
}

-(void)api:( PFApi* )api_ didFailConnectWithError:( NSError* )error_
{
   if ( !self.activeServerFinded && [ self.serverInfo seekToNextServer ] )
   {
      [ self disconnect ];
      [ self connect ];
   }
   else
   {
      [ self.delegate serverFactory: self
                   didFailWithError: error_ ];
   }
}

-(void)api:( PFApi* )api_ didFailParseWithError:( NSError* )error_
{
   [ self.delegate serverFactory: self
                didFailWithError: error_ ];
}

-(void)didConnectApi:( PFApi* )api_
{
}

@end
