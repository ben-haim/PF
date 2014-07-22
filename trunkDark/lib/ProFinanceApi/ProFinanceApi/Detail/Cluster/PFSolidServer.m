#import "PFSolidServer.h"

#import "PFTradeApi.h"
#import "PFQuoteApi.h"

#import "PFSymbolsRouter.h"

@interface PFSolidServer ()

@property ( nonatomic, strong ) PFQuoteApi* quoteApi;

@end

@implementation PFSolidServer

@synthesize quoteApi;

-(void)clean
{
   [ super clean ];
   self.quoteApi = nil;
}

#pragma mark abstract methods

-(id< PFTradeCommander >)commanderForAccountWithId:( PFInteger )account_id_
{
   return self.primaryApi;
}

-(id< PFQuoteCommander >)commanderForRouteWithId:( PFInteger )route_id_
{
   return self.quoteApi;
}

-(id< PFCommander >)commanderForVerificationId:( PFInteger )verification_id_
{
   return self.primaryApi;
}

-(NSArray*)allApis
{
   return @[self.primaryApi, self.quoteApi];
}

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_
{
   if ( api_ == self.primaryApi )
   {
      PFQuoteApi* quote_api_ = [ PFQuoteApi new ];
      
      NSError* error_ = nil;
      if ( ![ self logonNodeApi: quote_api_ serverInfo: self.primaryApi.serverInfo error: &error_ ] )
      {
         [ self.delegate server: self didFailWithFatalError: error_ ];
         return;
      }

      self.quoteApi = quote_api_;
      [ self.delegate server: self didLogonUser: user_ ];
   }
}

-(BOOL)tradesTransferFinished
{
   return self.primaryApi.transferFinished;
}

-(BOOL)quotesTransferFinished
{
   return self.quoteApi.transferFinished;
}

-(void)didFinishTransferApi:( PFApi* )api_
{
   if ( api_ == self.quoteApi )
   {
      [ self.delegate didFinishQuoteTransferServer: self ];
   }
   else if ( api_ == self.primaryApi )
   {
      [ self.delegate didFinishTradeTransferServer: self ];
   }

   if ( self.transferFinished )
   {
      [ self.delegate didFinishTransferServer: self ];
   }
}

-(NSArray*)routersForSymbols:( NSArray* )symbols_
{
   return @[[ PFSymbolsRouter routerWithCommander: self.quoteApi symbols: symbols_ ]];
}

-(void)api:( PFApi* )api_ didLoadRouteMessage:( PFMessage* )message_
{
   if ( api_ == self.quoteApi )
   {
      [ self.delegate server: self didLoadRouteMessage: message_ ];
   }
}

@end
