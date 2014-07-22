#import "PFServer.h"

#import "PFTradeApi.h"

#import "PFApiDelegate.h"

#import "PFSymbolsRouter.h"

#import "PFOrder.h"
#import "PFPosition.h"
#import "PFSymbol.h"

#import "PFServerInfo.h"

#import "NSError+ProFinanceApi.h"

@interface PFServer ()< PFApiDelegate >

@property ( nonatomic, strong ) PFServerInfo* serverInfo;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, strong ) NSString* password;
@property ( nonatomic, strong ) NSString* verificationPassword;
@property ( nonatomic, strong ) NSString* ipAddress;

@end

@implementation PFServer

@synthesize primaryApi;
@synthesize serverInfo;
@synthesize login;
@synthesize password;
@synthesize verificationPassword;
@synthesize ipAddress;
@synthesize delegate;

-(void)dealloc
{
   [ self disconnect ];
}

-(id)initWithApi:( PFTradeApi* )api_
{
   self = [ super init ];
   if ( self )
   {
      self.primaryApi = api_;
      self.primaryApi.delegate = self;
      self.serverInfo = api_.serverInfo;
   }
   return self;
}

+(id)serverWithPrimaryApi:( PFTradeApi* )api_
{
   return [ [ self alloc ] initWithApi: api_ ];
}

-(void)clean
{
   self.primaryApi.delegate = nil;
   self.primaryApi = nil;
}

-(BOOL)transferFinished
{
   return self.tradesTransferFinished && self.quotesTransferFinished;
}

-(BOOL)logonNodeApi:( PFApi* )api_
         serverInfo:( PFServerInfo* )server_info_
              error:( NSError** )error_
{
   api_.delegate = self;
   
   if ( ![ api_ connectToServerWithInfo: server_info_ ] )
   {
      if ( error_ )
      {
         *error_ = [ NSError connectionError ];
      }
      return NO;
   }
   
   [ api_ logonWithLogin: self.login password: self.password verificationPassword: self.verificationPassword verificationId: -1 ipAddress: self.ipAddress ];
   return YES;
}

-(BOOL)logonNodeApi:( PFApi* )api_
             server:( NSString* )server_
              error:( NSError** )error_
{
   PFServerInfo* server_info_ = [ [ PFServerInfo alloc ] initWithServers: server_
                                                                  secure: self.serverInfo.secure
                                                                 useHTTP: self.serverInfo.useHTTP ];

   return [ self logonNodeApi: api_
                   serverInfo: server_info_
                        error: error_ ];
}

#pragma mark abstract methods

-(id< PFTradeCommander >)commanderForAccountWithId:( PFInteger )account_id_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(id< PFQuoteCommander >)commanderForRouteWithId:( PFInteger )route_id_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(NSArray*)allApis
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(BOOL)tradesTransferFinished
{
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

-(BOOL)quotesTransferFinished
{
   [ self doesNotRecognizeSelector: _cmd ];
   return NO;
}

-(void)didFinishTransferApi:( PFApi* )api_
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(NSArray*)routersForSymbols:( NSArray* )symbols_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)logonServerWithLogin:( NSString* )login_
                   password:( NSString* )password_
       verificationPassword:( NSString* )verification_password_
             verificationId:( int )verification_id_
                  ipAddress:( NSString* )ip_address_
{
   [ self.primaryApi logonWithLogin: login_
                           password: password_
               verificationPassword: verification_password_
                     verificationId: verification_id_
                          ipAddress: ip_address_ ];
}

#pragma mark PFCommander

-(void)logonWithLogin:( NSString* )login_
             password:( NSString* )password_
 verificationPassword:( NSString* )verification_password_
       verificationId:( int )verification_id_
            ipAddress:( NSString* )ip_address_
{
   self.login = login_;
   self.password = password_;
   self.verificationPassword = verification_password_;
   self.ipAddress = ip_address_;

   [ self logonServerWithLogin: login_
                      password: password_
          verificationPassword: verification_password_
                verificationId: verification_id_
                     ipAddress: ip_address_ ];
}

-(void)applyNewPassword:( NSString* )new_password_
            oldPassword:( NSString* )old_password_
   verificationPassword:(NSString *)verification_password_
                 userId:( int )user_id_
              accountId:( int )account_id_
{
   [ [ self commanderForAccountWithId: account_id_ ] applyNewPassword: new_password_
                                                          oldPassword: old_password_
                                                 verificationPassword: verification_password_
                                                               userId: user_id_
                                                            accountId: account_id_ ];
}

-(void)logout
{
   for ( PFApi* api_ in self.allApis )
   {
      api_.delegate = nil;
      [ api_ logout ];
      [ api_ disconnect ];
   }
   
   [ self clean ];
}

-(void)disconnect
{
   for ( PFApi* api_ in self.allApis )
   {
      api_.delegate = nil;
      [ api_ disconnect ];
   }
   
   [ self clean ];
}

#pragma mark PFTradeCommander

-(void)reportTableForAccountWithId:( PFInteger )account_id_
                          criteria:( id< PFSearchCriteria > )criteria_
                         doneBlock:( PFReportDoneBlock )done_block_
{
   return [ [ self commanderForAccountWithId: account_id_ ] reportTableForAccountWithId: account_id_
                                                                               criteria: criteria_
                                                                              doneBlock: done_block_ ];
}

-(void)createOrder:( id< PFOrder > )order_
{
   return [ [ self commanderForAccountWithId: order_.accountId ] createOrder: order_ ];
}

-(void)replaceOrder:( id< PFOrder > )order_
      withDoneBlock:( PFReplaceOrderDoneBlock )done_block_
{
   return [ [ self commanderForAccountWithId: order_.accountId ] replaceOrder: order_ withDoneBlock: done_block_ ];
}

-(void)cancelOrder:( id< PFOrder > )order_
{
   return [ [ self commanderForAccountWithId: order_.accountId ] cancelOrder: order_ ];
}

-(void)closePosition:( id< PFPosition > )position_
{
   return [ [ self commanderForAccountWithId: position_.accountId ] closePosition: position_ ];
}

-(void)withdrawalForAccountId:( PFInteger )account_id_
                    andAmount:( PFDouble )amount_;
{
   return [ [ self commanderForAccountWithId: account_id_ ] withdrawalForAccountId: account_id_
                                                                         andAmount: amount_ ];
}

-(void)transferFromAccountId:( PFInteger )from_account_id_
                 toAccountId:( PFInteger )to_account_id_
                      amount:( PFDouble )amount_
{
   return [ [ self commanderForAccountWithId: from_account_id_ ] transferFromAccountId: from_account_id_
                                                                           toAccountId: to_account_id_
                                                                                amount: amount_ ];
}

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
               stopLossPrice:( PFDouble )stop_loss_price_
              stopLossOffset:( PFDouble )stop_loss_offset_
{
   return [ [ self commanderForAccountWithId: market_operation_.accountId ] updateMarketOperation: market_operation_
                                                                                    stopLossPrice: stop_loss_price_
                                                                                   stopLossOffset: stop_loss_offset_ ];
}

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
             takeProfitPrice:( PFDouble )take_profit_price_
{
   return [ [ self commanderForAccountWithId: market_operation_.accountId ] updateMarketOperation: market_operation_
                                                                                  takeProfitPrice: take_profit_price_ ];
}

-(void)storiesForAccountWithId:( PFInteger )account_id_
                      fromDate:( NSDate* )from_date_
                        toDate:( NSDate* )to_date_
{
   return [ [ self commanderForAccountWithId: account_id_ ] storiesForAccountWithId: account_id_
                                                                           fromDate: from_date_
                                                                             toDate: to_date_ ];
}

-(void)sendChatMessage:( id< PFChatMessage > )message_
      forAccountWithId:( PFInteger )account_id_
{
   return [ [ self commanderForAccountWithId: account_id_ ] sendChatMessage: message_
                                                           forAccountWithId: account_id_ ];
}

#pragma mark PFQuoteCommander

-(void)subscribeToSymbols:( NSArray* )symbols_
                     type:( PFSubscriptionType )subscription_type_
{
   NSArray* routers_ = [ self routersForSymbols: symbols_ ];
   for ( PFSymbolsRouter* router_ in routers_ )
   {
      [ router_.commander subscribeToSymbols: router_.symbols type: subscription_type_ ];
   }
}

-(void)unsubscribeFromSymbols:( NSArray* )symbols_
                         type:( PFSubscriptionType )subscription_type_
{
   NSArray* routers_ = [ self routersForSymbols: symbols_ ];
   for ( PFSymbolsRouter* router_ in routers_ )
   {
      [ router_.commander unsubscribeFromSymbols: router_.symbols type: subscription_type_ ];
   }
}

-(void)historyFilesForSymbol:( id< PFSymbol > )symbol_
                   accountId:( PFInteger )account_id_
                      period:( PFChartPeriodType )period_
                    fromDate:( NSDate* )from_date_
                      toDate:( NSDate* )to_date_
              timeZoneOffset:( PFInteger )time_zone_offset_
                   doneBlock:( PFChartFilesDoneBlock )done_block_
{
   return [  [ self commanderForRouteWithId: symbol_.quoteRouteId ] historyFilesForSymbol: symbol_
                                                                                accountId: account_id_
                                                                                   period: period_
                                                                                 fromDate: from_date_
                                                                                   toDate: to_date_
                                                                           timeZoneOffset: time_zone_offset_
                                                                                doneBlock: done_block_ ];
}

#pragma mark PFApiDelegate

-(BOOL)handleError:( NSError* )error_
           fromApi:( PFApi* )api_
{
   return NO;
}

-(void)api:( PFApi* )api_ didFailConnectWithError:( NSError* )error_
{
   if ( ![ self handleError: error_ fromApi: api_ ] )
   {
      [ self.delegate server: self didFailWithFatalError: error_ ];
   }
}

-(void)api:( PFApi* )api_ didFailParseWithError:( NSError* )error_
{
   if ( ![ self handleError: error_ fromApi: api_ ] )
   {
      [ self.delegate server: self didFailWithFatalError: error_ ];
   }
}

-(void)didConnectApi:( PFApi* )api_
{
}

-(BOOL)handleLogoutWithReason:( NSString* )reason_
                      fromApi:( PFApi* )api_
{
   return NO;
}

-(void)api:( PFApi* )api_ didProcessedMessage:( NSString* )message_
{
   [ self.delegate server: self didProcessMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLogoutWithReason:( NSString* )reason_
{
   if ( ![ self handleLogoutWithReason: reason_ fromApi: api_ ] )
   {
      [ self.delegate server: self didLogoutWithReason: reason_ ];
   }
}

-(void)api:( PFApi* )api_ needVerificationWithId:( int )verification_id_
{
   [ self.delegate server: self needVerificationWithId: verification_id_ ];
}

-(void)api:( PFApi* )api_ changePasswordForUser:( int )user_id_
{
   [ self.delegate server: self changePasswordForUser: user_id_ ];
}

-(void)api:( PFApi* )api_ didLoadQuoteMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadQuoteMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadTradeQuoteMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadTradeQuoteMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadLevel2Quote:( PFLevel2Quote* )quote_
{
   [ self.delegate server: self didLoadLevel2Quote: quote_ ];
}

-(void)api:( PFApi* )api_ didLoadLevel4Quote:( PFLevel4Quote* )quote_
{
   [ self.delegate server: self didLoadLevel4Quote: quote_ ];
}

-(void)api:( PFApi* )api_ didLoadLevel2QuotePackage:( PFLevel2QuotePackage* )package_
{
   [ self.delegate server: self didLoadLevel2QuotePackage: package_ ];
}

-(void)api:( PFApi* )api_ didLoadInstrument:( PFInstrument* )instrument_
{
//   if ( ! self.transferFinished )
   {
      [ self.delegate server: self didLoadInstrument: instrument_ ];
   }
}

-(void)api:( PFApi* )api_ didLoadInstrumentGroup:( PFInstrumentGroup* )group_
{
   [ self.delegate server: self didLoadInstrumentGroup: group_ ];
}

-(void)api:( PFApi* )api_ didLoadPositionMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadPositionMessage: message_ ];
}

-(void)api:( PFApi* )api_ didClosePositionWithId:( PFInteger )position_id_
{
   [ self.delegate server: self didClosePositionWithId: position_id_ ];
}

-(void)api:( PFApi* )api_ didLoadOrderMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadOrderMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadTradeMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadTradeMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadRouteMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadRouteMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadAccountMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadAccountMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadPammAccountStatusMessage:( PFMessage* )message_
{
    [ self.delegate server: self didLoadPammAccountStatusMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadStories:( NSArray* )stories_
{
   [ self.delegate server: self didLoadStories: stories_ ];
}

-(void)api:( PFApi* )api_ didReceiveErrorMessage:( NSString* )error_message_
{
   [ self.delegate server: self didReceiveErrorMessage: error_message_ ];
}

-(void)api:( PFApi* )api_ didReceiveRejectMessage:( PFRejectMessage* )reject_message_
{
   [ self.delegate server: self didReceiveRejectMessage: reject_message_ ];
}

-(void)api:( PFApi* )api_ didLoadReport:( PFReportTable* )report_
{
   [ self.delegate server: self didLoadReport: report_ ];
}

-(void)api:( PFApi* )api_ didLoadChatMessage:( PFChatMessage* )message_
{
   [ self.delegate server: self didLoadChatMessage: message_ ];
}

-(void)api:( PFApi* )api_ didLoadChangePasswordStatus:( int )change_password_status_ andReason:( NSString* )reason_
{
   [ self.delegate server: self didLoadChangePasswordStatus: change_password_status_ andReason: reason_ ];
}

-(void)api:( PFApi* )api_ didLoadRule:( PFRule* )rule_
{
   [ self.delegate server: self didLoadRule: rule_ ];
}

-(void)api:( PFApi* )api_ didAllowReportWithName:( NSString* )report_name_
{
   [ self.delegate server: self didAllowReportWithName: report_name_ ];
}

-(void)api:( PFApi* )api_ didLoadCommissionPlan:( PFCommissionPlan* )commission_plan_
{
   [ self.delegate server: self didLoadCommissionPlan: commission_plan_ ];
}

-(void)api:( PFApi* )api_ didLoadSpreadPlan:( PFSpreadPlan* )spread_plan_
{
   [ self.delegate server: self didLoadSpreadPlan: spread_plan_ ];
}

-(void)api:( PFApi* )api_ didLoadAssetType:( PFAssetType* )asset_type_
{
    [ self.delegate server: self didLoadAssetType: asset_type_ ];
}

-(void)api:( PFApi* )api_ didLoadTradeSessionContainer:( PFTradeSessionContainer* )trade_session_container_
{
   [ self.delegate server: self didLoadTradeSessionContainer: trade_session_container_ ];
}

-(void)api:( PFApi* )api_ didLoadCrossRatesMessage:( PFMessage* )message_
{
   [ self.delegate server: self didLoadCrossRatesMessage: message_ ];
}

-(void)api:( PFApi* )api_ overnightNotificationForAccountId:( PFInteger )account_id_ maintanceMargin:( PFDouble )maintance_margin_ availableMargin:( PFDouble )available_margin_ date:( NSDate* )date_
{
   [ self.delegate server: self overnightNotificationForAccountId: account_id_
          maintanceMargin: maintance_margin_
          availableMargin: available_margin_
                     date: date_ ];
}

@end
