 #import "PFSession.h"

#import "PFServerFactory.h"
#import "PFServer.h"

#import "PFChartApi.h"

#import "PFUser.h"
#import "PFInstrument.h"
#import "PFInstruments.h"
#import "PFQuote.h"
#import "PFPositions.h"
#import "PFAccount.h"
#import "PFAccounts.h"
#import "PFOrders.h"
#import "PFOrder.h"
#import "PFTrade.h"
#import "PFTrades.h"
#import "PFPosition.h"
#import "PFStories.h"
#import "PFSymbols.h"
#import "PFSymbol.h"
#import "PFWatchlist.h"
#import "PFQuoteSubscriber.h"
#import "PFAsyncCalculator.h"
#import "PFCalculation.h"
#import "PFTrigger.h"
#import "PFRejectMessage.h"
#import "PFReportTable.h"
#import "PFChatMessage.h"
#import "PFChat.h"
#import "PFSearchCriteria.h"
#import "PFLevel2Quote.h"
#import "PFLevel3Quote.h"
#import "PFLevel2QuotePackage.h"
#import "PFLevel4Quote.h"
#import "PFLevel4QuotePackage.h"
#import "PFRule.h"
#import "PFDowJonesReader.h"
#import "PFCommissionPlan.h"
#import "PFCommissionPlans.h"
#import "PFSpreadPlan.h"
#import "PFSpreadPlans.h"
#import "PFAssetType.h"
#import "PFAssetTypes.h"
#import "PFTradeSessionContainer.h"
#import "PFTradeSession.h"
#import "PFCrossRates.h"
#import "PFOwnerType.h"
#import "PFAssetAccount.h"

#import "PFAccount+Update.h"

#import "NSError+ProFinanceApi.h"

#import "PFAsyncSocketWrapper.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>
#import <JFF/Utils/JFFMulticastDelegate.h>
#import <AsyncDispatcher/AsyncDispatcher.h>

static PFSession* shared_session_ = nil;

@interface PFSession ()< PFServerFactoryDelegate
, PFServerDelegate
, PFOrdersDelegate
, PFPositionsDelegate
, PFTradesDelegate
, PFAccountsDelegate
, PFWatchlistDelegate
, PFQuoteSubscriberDelegate
, PFAsyncCalculatorDelegate >

@property ( nonatomic, strong ) JFFMulticastDelegate* delegates;

@property ( nonatomic, strong ) PFServerFactory* serverFactory;
@property ( nonatomic, strong ) PFServer* server;
@property ( nonatomic, strong ) PFChartApi* chartApi;

@property ( nonatomic, strong ) PFInstruments* mutableInstruments;
@property ( nonatomic, strong ) PFAccounts* mutableAccounts;
@property ( nonatomic, strong ) PFStories* mutableStories;
@property ( nonatomic, strong ) PFSymbols* mutableSymbols;
@property ( nonatomic, strong ) NSMutableDictionary* watchlistById;
@property ( nonatomic, strong ) NSDictionary* subscriberByType;
@property ( nonatomic, strong ) PFChat* mutableChat;
@property ( nonatomic, strong ) PFAsyncCalculator* asyncCalculator;
@property ( nonatomic, strong ) PFUser* mutableUser;
@property ( nonatomic, strong ) NSMutableDictionary* mutableRules;
@property ( nonatomic, strong ) NSMutableArray * notMtableRules;
@property ( nonatomic, strong ) NSMutableSet* mutableAllowedReportTypes;
@property ( nonatomic, strong ) PFDowJonesReader* dowJonesReader;

@property ( nonatomic, strong ) PFCommissionPlans* commissionPlans;
@property ( nonatomic, strong ) PFSpreadPlans* spreadPlans;
@property ( nonatomic, strong ) NSMutableDictionary* tradeSessionContainers;
@property ( nonatomic, strong ) PFAssetTypes* assetTypes;

@property ( nonatomic, strong ) NSMutableArray* brockerMessages;
@property ( nonatomic, strong ) NSMutableArray* mutableEvents;

@end

@implementation PFSession

@synthesize delegates = _delegates;

@synthesize serverFactory;
@synthesize server;
@synthesize chartApi = _chartApi;

@synthesize mutableInstruments = _mutableInstruments;
@synthesize mutableAccounts = _mutableAccounts;
@synthesize mutableStories = _mutableStories;
@synthesize mutableSymbols = _mutableSymbols;
@synthesize watchlistById = _watchlistById;
@synthesize subscriberByType = _subscriberByType;
@synthesize mutableChat = _mutableChat;
@synthesize asyncCalculator;
@synthesize mutableUser;
@synthesize mutableRules = _mutableRules;
@synthesize notMtableRules = _not_mutable_rules;
@synthesize mutableAllowedReportTypes = _mutableAllowedReportTypes;

@synthesize dowJonesReader;
@synthesize dowJonesToken;
@synthesize defaultSymbolNames;

@synthesize commissionPlans = _commissionPlans;
@synthesize spreadPlans = _spreadPlans;
@synthesize assetTypes = _assetTypes;
@synthesize brockerMessages = _brockerMessages;
@synthesize mutableEvents = _mutableEvents;
@synthesize tradeSessionContainers = _tradeSessionContainers;

@synthesize needChangePassword;
@synthesize reconnectionBlock;

@dynamic delegate;

-(void)dealloc
{
   NSLog( @"PFSession dealloc" );
   [ self disconnect ];
}

+(BOOL)useUnsafeSSL
{
   return [ PFAsyncSocketWrapper useUnsafeSSL ];
}

+(void)setUseUnsafeSSL:( BOOL )use_unsafe_
{
   [ PFAsyncSocketWrapper setUseUnsafeSSL: use_unsafe_ ];
}

+(void)setSharedSession:( PFSession* )session_
{
   if ( shared_session_ != session_ )
   {
      shared_session_ = session_;
   }
}

+(PFSession*)sharedSession
{
   return shared_session_;
}

-(BOOL)executeReconnectionBlockIfExists
{
   if ( self.reconnectionBlock )
   {
      self.reconnectionBlock();
      return YES;
   }
   
   return NO;
}

-(PFServerInfo*)serverInfo
{
   return self.server.serverInfo;
}

-(NSArray*)events
{
   return self.mutableEvents;
}

-(NSMutableArray*)mutableEvents
{
   if ( !_mutableEvents )
   {
      _mutableEvents = [ NSMutableArray new ];
   }
   return _mutableEvents;
}

-(NSMutableArray*)brockerMessages
{
   if ( !_brockerMessages )
   {
      _brockerMessages = [ NSMutableArray new ];
   }
   return _brockerMessages;
}

-(void)displayWrongServerMessage
{
   [ self.delegate wrongServerWithSession: self ];
}

-(void)displayBrockerMessage:( PFChatMessage* )brocker_message_
{
   [ self.delegate session: self didReceiveBrockerMessage: brocker_message_.text
            withCancelMode: brocker_message_.type == PFChatMessageBrockerWelcome ];
}

-(NSString*)login
{
   return self.server.login;
}

-(NSString*)password
{
   return self.server.password;
}

-(NSMutableDictionary*)watchlistById
{
   if ( !_watchlistById )
   {
      _watchlistById = [ NSMutableDictionary new ];
   }
   return _watchlistById;
}

-(NSMutableDictionary*)tradeSessionContainers
{
   if ( !_tradeSessionContainers )
   {
      _tradeSessionContainers = [ NSMutableDictionary new ];
   }
   return _tradeSessionContainers;
}

-(PFCommissionPlans*) commissionPlans
{
   if ( !_commissionPlans )
   {
      _commissionPlans = [ PFCommissionPlans new ];
   }
   
   return _commissionPlans;
}

-(PFSpreadPlans*) spreadPlans
{
   if ( !_spreadPlans )
   {
      _spreadPlans = [ PFSpreadPlans new ];
   }
   
   return _spreadPlans;
}

-(PFAssetTypes*) assetTypes
{
    if ( !_assetTypes )
    {
        _assetTypes = [ PFAssetTypes new ];
    }
    
    return _assetTypes;
}

-(PFInstruments*)mutableInstruments
{
   if ( !_mutableInstruments )
   {
      _mutableInstruments = [ PFInstruments new ];
   }
   return _mutableInstruments;
}

-(id< PFInstruments >)instruments
{
   return self.mutableInstruments;
}

-(PFAccounts*)mutableAccounts
{
   if ( !_mutableAccounts )
   {
      _mutableAccounts = [ [ PFAccounts alloc ] initWithUserId: self.mutableUser.userId
                                                   instruments: self.mutableInstruments ];
   }
   return _mutableAccounts;
}

-(id<PFAccounts>)accounts
{
   return self.mutableAccounts;
}

-(PFStories*)mutableStories
{
   if ( !_mutableStories )
   {
      _mutableStories = [ PFStories new ];
   }
   return _mutableStories;
}

-(id<PFStories>)stories
{
   return self.mutableStories;
}

-(id<PFSymbols>)symbols
{
   return self.mutableSymbols;
}

-(NSArray*)optionSymbols
{
   return self.mutableSymbols.optionSymbols;
}

-(NSDictionary*)subscriberByType
{
   if ( !_subscriberByType )
   {
      _subscriberByType = @{
         @(PFSubscriptionTypeQuoteLevel1): [ PFQuoteSubscriber level1Subscriber ]
         , @(PFSubscriptionTypeQuoteLevel2): [ PFQuoteSubscriber level2Subscriber ]
         , @(PFSubscriptionTypeQuoteLevel3): [ PFQuoteSubscriber level3Subscriber ]
         , @(PFSubscriptionTypeQuoteLevel4): [ PFQuoteSubscriber level4Subscriber ]
      };
   }
   return _subscriberByType;
}

-(PFQuoteSubscriber*)mutableQuoteSubscriber
{
   return (self.subscriberByType)[@(PFSubscriptionTypeQuoteLevel1)];
}

-(PFQuoteSubscriber*)mutableLevel2QuoteSubscriber
{
   return (self.subscriberByType)[@(PFSubscriptionTypeQuoteLevel2)];
}

-(PFQuoteSubscriber*)mutableLevel4QuoteSubscriber
{
   return (self.subscriberByType)[@(PFSubscriptionTypeQuoteLevel4)];
}

-(PFQuoteSubscriber*)mutableLevel3QuoteSubscriber
{
   return (self.subscriberByType)[@(PFSubscriptionTypeQuoteLevel3)];
}

-(id< PFQuoteSubscriber >)quoteSubscriber
{
   return self.mutableQuoteSubscriber;
}

-(id< PFQuoteSubscriber >)level2QuoteSubscriber
{
   return self.mutableLevel2QuoteSubscriber;
}

-(id< PFQuoteSubscriber >)level4QuoteSubscriber
{
   return self.mutableLevel4QuoteSubscriber;
}

-(id< PFQuoteSubscriber >)level3QuoteSubscriber
{
   return self.mutableLevel3QuoteSubscriber;
}

-(id< PFUser >)user
{
   return self.mutableUser;
}

-(PFChat*)mutableChat
{
   if ( !_mutableChat )
   {
      _mutableChat = [ PFChat new ];
   }
   return _mutableChat;
}

-(id< PFChat >)chat
{
   return self.mutableChat;
}

-(NSMutableDictionary*)mutableRules
{
   if ( !_mutableRules )
   {
      _mutableRules = [ NSMutableDictionary new ];
   }
   return _mutableRules;
}
-(NSArray*)notMtableRules
{
    if(!_not_mutable_rules)
        _not_mutable_rules = [NSMutableArray  new];
    return _not_mutable_rules;
}

-(NSSet*)allowedReportTypes
{
   return self.mutableAllowedReportTypes;
}

-(NSArray*)supportedReportTypes
{
   NSArray* client_available_reports_ = @[ @(PFReportTableTypeAccountStatement)
                                           , @(PFReportTableTypeBalance)
                                           , @(PFReportTableTypeBalanceSummary)
                                           , @(PFReportTableTypeCommissions)
                                           , @(PFReportTableTypeTrades)
                                           , @(PFReportTableTypeOrderHistory) ];
   
   NSMutableArray* reports_ = [ NSMutableArray arrayWithCapacity: [ self.allowedReportTypes count ] ];
   for ( id report_type_ in client_available_reports_ )
   {
      if ( [ self.allowedReportTypes containsObject: report_type_ ] )
      {
         [ reports_ addObject: report_type_ ];
      }
   }
   
   return reports_;
}

-(NSMutableSet*)mutableAllowedReportTypes
{
   if ( !_mutableAllowedReportTypes )
   {
      _mutableAllowedReportTypes = [ NSMutableSet new ];
   }
   return _mutableAllowedReportTypes;
}

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_
{
   NSAssert( !self.server, @"already connected" );

   self.serverFactory = [ PFServerFactory factoryWithServerInfo: server_info_ ];
   self.serverFactory.delegate = self;
   return [ self.serverFactory connect ];
}

-(void)disconnectServers
{
   [ self stopAsyncCalculator ];
   
   self.serverFactory.delegate = nil;
   [ self.serverFactory disconnect ];
   self.serverFactory = nil;
   
   self.server.delegate = nil;
   [ self.server disconnect ];
   self.server = nil;
   
   [ self.dowJonesReader disconnect ];
   self.dowJonesReader = nil;
}

-(void)disconnect
{
   [ self disconnectServers ];

   self.chartApi = nil;
   self.mutableEvents = nil;
   self.brockerMessages = nil;
   self.mutableInstruments = nil;
   self.mutableAccounts = nil;
   self.mutableStories = nil;
   self.mutableSymbols = nil;
   self.watchlistById = nil;
   self.subscriberByType = nil;
   self.mutableChat = nil;
   self.mutableUser = nil;
   self.mutableRules = nil;
   self.mutableAllowedReportTypes = nil;
}

#pragma mark PFServerFactory

-(void)serverFactory:( PFServerFactory* )factory_
    didConnectServer:( PFServer* )server_
{
   self.server = server_;
   self.server.delegate = self;

   self.serverFactory.delegate = nil;
   self.serverFactory = nil;

   [ self.delegate didConnectSession: self ];
}

-(void)serverFactory:( PFServerFactory* )factory_
    didFailWithError:( NSError* )error_
{
   [ self.delegate session: self didFailConnectWithError: error_ ];
}

#pragma mark commands

-(void)logonWithLogin:( NSString* )login_
             password:( NSString* )password_
 verificationPassword:( NSString* )verification_password_
       verificationId:( int )verification_id_
            ipAddress:( NSString* )ip_address_
{
   [ self.server logonWithLogin: login_
                       password: password_
           verificationPassword: verification_password_
                 verificationId: verification_id_
                      ipAddress: ip_address_ ];
}

-(void)historyFromDate:( NSDate* )from_date_
                toDate:( NSDate* )to_date_
             doneBlock:( PFReportDoneBlock )done_block_
{
   [ self reportTableWithType: PFReportTableTypeTrades
                     fromDate: from_date_
                       toDate: to_date_
                    doneBlock: done_block_ ];
}

-(void)reportTableWithCriteria:( id< PFSearchCriteria > )criteria_
                     doneBlock:( PFReportDoneBlock )done_block_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server reportTableForAccountWithId: self.accounts.defaultAccount.accountId
                                       criteria: criteria_
                                      doneBlock: done_block_ ];
   }
}

-(void)reportTableWithType:( PFReportTableType )table_type_
                  fromDate:( NSDate* )from_date_
                    toDate:( NSDate* )to_date_
                 doneBlock:( PFReportDoneBlock )done_block_
{
   PFSearchCriteria* criteria_ = [ PFSearchCriteria new ];

   criteria_.fromDate = from_date_;
   criteria_.toDate = to_date_;
   criteria_.tableType = table_type_;

   [ self reportTableWithCriteria: criteria_ doneBlock: done_block_ ];
}

-(void)createOrder:( id< PFOrder > )order_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server createOrder: order_ ];
   }
}

-(void)replaceOrder:( id< PFOrder > )order_
          withOrder:( id< PFOrder > )new_order_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server replaceOrder: new_order_ withDoneBlock: ^{ [ self replaceMarketOperation: order_ withOperation: new_order_ ]; } ];
   }
}

-(void)cancelOrder:( id< PFOrder > )order_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server cancelOrder: order_ ];
   }
}

-(void)executeOrder:( id< PFOrder > )order_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      id< PFMutableOrder > market_order_ = [ order_ mutableOrder ];
      [ market_order_ setOrderType: PFOrderMarket ];
      [ self.server replaceOrder: market_order_ withDoneBlock: nil ];
   }
}

-(void)closePosition:( id< PFPosition > )position_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      PFPosition* current_position_ = [ self.mutableAccounts.positions positionWithId: position_.positionId ];
      
      if( current_position_ )
      {
         NSAssert( position_.amount <= current_position_.amount, @"invalid close amount" );
         [ self.server closePosition: position_ ];
      }
   }
}

-(void)cancelAllOrdersForAccount:( id< PFAccount > )account_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      NSArray* orders_ = account_ ? account_.orders : self.accounts.allOrders;
      
      for ( id< PFOrder > order_ in orders_ )
      {
         if ( [ self allowsTradingForSymbol: order_.symbol ] )
         {
            [ self cancelOrder: order_ ];
         }
      }
   }
}

-(void)closeAllPositionsForAccount:( id< PFAccount > )account_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      NSArray* positions_ = account_ ? account_.positions : self.accounts.allPositions;
      
      for ( id< PFPosition > position_ in positions_ )
      {
         if ( [ self allowsTradingForSymbol: position_.symbol ] )
         {
            [ self.server closePosition: position_ ];
         }
      }
   }
}

-(void)withdrawalForAccount:( id< PFAccount > )account_
                  andAmount:( PFDouble )amount_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server withdrawalForAccountId: account_.accountId
                                 andAmount: amount_ ];
   }
}

-(void)transferFromAccount:( id< PFAccount > )from_account_
                 toAccount:( id< PFAccount > )to_account_
                    amount:( PFDouble )amount_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server transferFromAccountId: from_account_.accountId
                              toAccountId: to_account_.accountId
                                   amount: amount_ ];
   }
}

-(void)historyForSymbol:( id< PFSymbol > )symbol_
                 period:( PFChartPeriodType )period_
               fromDate:( NSDate* )from_date_
                 toDate:( NSDate* )to_date_
              doneBlock:( PFHistoryDoneBlock )done_block_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.chartApi historyForInstrumentWithId: symbol_.instrumentId
                                       routeName: symbol_.routeName
                                          userId: self.accounts.defaultAccount.accountId
                                       sessionId: self.mutableUser.sessionId
                                          period: period_
                                            type: symbol_.barType
                                        fromDate: from_date_
                                          toDate: to_date_
                                       doneBlock: done_block_ ];
   }
}

-(void)historyReaderForSymbol:( id< PFSymbol > )symbol_
                       period:( PFChartPeriodType )period_
                     fromDate:( NSDate* )from_date_
                       toDate:( NSDate* )to_date_
                    doneBlock:( PFChartFilesDoneBlock )done_block_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      [ self.server historyFilesForSymbol: symbol_
                                accountId: self.accounts.defaultAccount.accountId
                                   period: period_
                                 fromDate: from_date_
                                   toDate: to_date_
                           timeZoneOffset: self.user.timeZoneOffset
                                doneBlock: done_block_ ];
   }
}

-(void)storiesFromDate:( NSDate* )from_date_
                toDate:( NSDate* )to_date_
{
   [ self.server storiesForAccountWithId: self.accounts.defaultAccount.accountId
                                fromDate: from_date_
                                  toDate: to_date_ ];
}

-(void)addTriggerBlock:( PFTriggerBlock )block_
    whenCancelledOrder:( id< PFOrder > )order_
{
   PFObjectPredicate cancel_predicate_ = ^BOOL( PFObject* object_ )
   {
      return order_.status == PFOrderStatusCancelled;
   };

   PFTrigger* trigger_ = [ PFTrigger triggerWithBlock: block_
                                            predicate: cancel_predicate_
                                             timelive: 10.0
                                    removeAfterInvoke: YES ];

   PFObject* object_ = ( PFObject* )order_;
   [ object_ addTrigger: trigger_ ];
}

-(void)replaceMarketOperation:( id< PFMarketOperation > )market_operation_
                withOperation:( id< PFMarketOperation > )new_market_operation_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      PFServer* server_ = self.server;
      
      if ( market_operation_.stopLossPrice != new_market_operation_.stopLossPrice || market_operation_.slTrailingOffset != new_market_operation_.slTrailingOffset )
      {
         if ( market_operation_.stopLossOrder )
         {
            if ( new_market_operation_.stopLossPrice != 0.0 || new_market_operation_.slTrailingOffset != 0.0 )
            {
               PFTriggerBlock trigger_block_ = ^()
               {
                  [ server_ updateMarketOperation: market_operation_
                                    stopLossPrice: new_market_operation_.stopLossPrice
                                   stopLossOffset: new_market_operation_.slTrailingOffset ];
               };
               
               [ self addTriggerBlock: trigger_block_
                   whenCancelledOrder: market_operation_.stopLossOrder ];
            }
            
            [ server_ cancelOrder: market_operation_.stopLossOrder ];
         }
         else if ( new_market_operation_.stopLossPrice != 0.0 || new_market_operation_.slTrailingOffset != 0.0 )
         {
            [ server_ updateMarketOperation: market_operation_
                              stopLossPrice: new_market_operation_.stopLossPrice
                             stopLossOffset: new_market_operation_.slTrailingOffset ];
         }
      }
      
      if ( market_operation_.takeProfitPrice != new_market_operation_.takeProfitPrice )
      {
         if ( market_operation_.takeProfitOrder )
         {
            if ( new_market_operation_.takeProfitPrice != 0.0 )
            {
               PFTriggerBlock trigger_block_ = ^()
               {
                  [ server_ updateMarketOperation: market_operation_
                                  takeProfitPrice: new_market_operation_.takeProfitPrice ];
               };
               
               [ self addTriggerBlock: trigger_block_
                   whenCancelledOrder: market_operation_.takeProfitOrder ];
            }
            
            [ server_ cancelOrder: market_operation_.takeProfitOrder ];
         }
         else if ( new_market_operation_.takeProfitPrice != 0.0 )
         {
            [ server_ updateMarketOperation: market_operation_
                            takeProfitPrice: new_market_operation_.takeProfitPrice ];
         }
      }
   }
}

-(void)replacePosition:( id< PFPosition > )position_
          withPosition:( id< PFPosition > )new_position_
{
   if ( !position_.stopLossOrder )
   {
      PFOrder* stop_loss_order_ = [ PFOrder stopOrderWithPosition: position_ ];
      if ( stop_loss_order_ )
      {
         [ self.mutableAccounts updateOrder: stop_loss_order_ delegate: self ];
      }
   }

   if ( !position_.takeProfitOrder )
   {
      PFOrder* take_profit_order_ = [ PFOrder limitOrderWithPosition: position_ ];
      if ( take_profit_order_ )
      {
         [ self.mutableAccounts updateOrder: take_profit_order_ delegate: self ];
      }
   }

   [ self replaceMarketOperation: position_ withOperation: new_position_ ];
}

-(void)sendChatMessageWithText:( NSString* )message_text_
{
   if ( ![ self executeReconnectionBlockIfExists ] )
   {
      if ( [ message_text_ length ] > 0 )
      {
         [ self.server sendChatMessage: [ PFChatMessage messageWithText: message_text_ fromUser: self.mutableUser ]
                      forAccountWithId: self.accounts.defaultAccount.accountId ];
      }
   }
}

-(void)logout
{
   [ self.server logout ];

   [ self disconnect ];
}


-(void)applyNewPassword:( NSString* )new_password_
            oldPassword:( NSString* )old_password_
   verificationPassword:( NSString* )verification_password_
                 userId:( int )user_Id_
{
   [ self.server applyNewPassword: new_password_
                      oldPassword: old_password_
             verificationPassword: verification_password_
                           userId: user_Id_
                        accountId: self.accounts.defaultAccount.accountId ];
}

-(void)selectDefaultAccount:( id< PFAccount > )default_account_
{
   self.mutableAccounts.defaultAccount = default_account_;

   for (PFSymbol* symbol_ in self.mutableSymbols.symbols )
   {
      symbol_.quote = [ self.spreadPlans createlevel1QuoteWithQuote: symbol_.realQuote AndSpreadPlan: self.accounts.defaultAccount.spreadPlanId ];
   }
   
   [ self.delegate session: self
   didSelectDefaultAccount: default_account_ ];
}

-(void)recalcSpreadChartQuotesWithQuotes: ( NSArray* )quotes_
                           AndInstrument: ( id<PFInstrument> )instrument_
{
   [ self.spreadPlans recalcChartQuotesWithQuotes: quotes_
                                    AndInstrument: instrument_
                                    AndSpreadPlan: self.accounts.defaultAccount.spreadPlanId ];
}

-(void)recalcSpreadLevel2QuotesWithBidQuotes: ( NSArray* )bid_quotes_
                                AndAskQuotes: ( NSArray* )ask_quotes_
                               AndInstrument: ( id<PFInstrument> )instrument_
                                AndLevel1Bid: ( double )bid_
                                AndLevel1Ask: ( double )ask_
{
   [ self.spreadPlans recalcLevel2QuotesWithBidQuotes: bid_quotes_
                                         AndAskQuotes: ask_quotes_
                                        AndInstrument: instrument_
                                        AndSpreadPlan: self.accounts.defaultAccount.spreadPlanId
                                         AndLevel1Bid: bid_
                                         AndLevel1Ask: ask_ ];
}

-(NSArray*)currentCommissionLevelForInstrument:( id< PFInstrument > )instrument_
{
   return [ self.commissionPlans commissionLevelWithInstrument: instrument_
                                             AndCommissionPlan: self.accounts.defaultAccount.commissionPlanId ];
}

-(id< PFAssetType >)assetTypeForCurrency:( NSString* )currency_
{
    return [self.assetTypes assetTypeWithCurrency: currency_ ];
}

-(id< PFTradeSessionContainer >)tradeSessionContainerForInstrument:( id< PFInstrument > )instrument_
{
   return (self.tradeSessionContainers)[@( instrument_.tradeSessionContainerId )];
}

-(double)transferCommission
{
   return [ self.commissionPlans transferCommissionWithCommissionPlan: self.accounts.defaultAccount.commissionPlanId ];
}

#pragma mark PFServerDelegate

-(void)server:( PFServer* )server_ didProcessMessage:( NSString* )message_
{
   [ self.delegate session: self didProcessMessage: message_ ];
}

-(void)server:( PFServer* )server_ didFailWithFatalError:( NSError* )error_
{
   [ self.delegate session: self didFailConnectWithError: error_ ];
}

-(void)server:( PFServer* )server_ didLogonUser:( PFUser* )user_
{
   self.mutableUser = user_;
   [ self.delegate didLogonSession: self ];
}

-(void)server:( PFServer* )server_
didLogoutWithReason:( NSString* )reason_
{
   [ self.delegate session: self didLogoutWithReason: reason_ ];
}

-(void)server:( PFServer* )server_ needVerificationWithId:( int )verification_id_
{
   [ self.delegate session: self needVerificationWithId: verification_id_ ];
}

-(void)server:( PFServer* )server_ changePasswordForUser:( int )user_id_
{
   self.needChangePassword = YES;
}

-(void)stopAsyncCalculator
{
   [ self.asyncCalculator removeAllCalculations ];
   [ self.asyncCalculator stop ];
}

-(void)addCalculationForAccount:( PFAccount* )account_
{
   __unsafe_unretained PFSession* unsafe_session_ = self;

   PFCalculationBlock update_positions_block_ = ^id()
   {
      return [ account_ update ];
   };

   PFCalculationDoneBlock done_positions_block_ = ^( id result_ )
   {
      PFSession* strong_session_ = unsafe_session_;

      NSArray* positions_ = ( NSArray* )result_;

      for ( PFPosition* position_ in positions_ )
      {
         [ strong_session_.delegate session: strong_session_
                          didUpdatePosition: position_
                                       type: PFPositionClientUpdate ];
      }

      [ strong_session_.delegate session: strong_session_ didUpdateAccount: account_ ];
   };

   [ self.asyncCalculator addCalculation: [ PFCalculation calculationWithBlock: update_positions_block_
                                                                     doneBlock: done_positions_block_ ] ];
}

-(void)startAsyncCalculator
{
   [ self stopAsyncCalculator ];

   self.asyncCalculator = [ PFAsyncCalculator new ];
   self.asyncCalculator.delegate = self;

   for ( PFAccount* account_ in self.mutableAccounts.accounts )
   {
      [ self addCalculationForAccount: account_ ];
   }

   [ self.asyncCalculator start ];
}

-(void)connectWatchlist:( PFWatchlist* )watchlist_
{
   [ watchlist_ connectToSession: self ];
   [ self.quoteSubscriber addDependence: watchlist_ forSymbols: watchlist_.symbols ];
}

-(void)didFinishQuoteTransferServer:( PFServer* )server_
{
   self.mutableSymbols = [ PFSymbols symbolsWithInstruments: self.mutableInstruments ];

   for ( PFWatchlist* watchlist_ in [ self.watchlistById allValues ] )
   {
      [ self connectWatchlist: watchlist_ ];
   }

   [ self.delegate session: self didLoadInstruments: self.instruments ];
}

-(id< PFWatchlist >)watchlistWithId:( NSString* )watchlist_id_
{
   return (self.watchlistById)[watchlist_id_];
}

-(void)addWatchlist:( PFWatchlist* )watchlist_
{
   if ( (self.watchlistById)[watchlist_.watchlistId] )
      return;

   (self.watchlistById)[watchlist_.watchlistId] = watchlist_;

   if ( self.server.quotesTransferFinished )
   {
      [ self connectWatchlist: watchlist_ ];
   }
   
   [ self.delegate session: self didAddWatchlist: watchlist_ ];
}

-(void)removeWatchlist:( PFWatchlist* )watchlist_
{
   [ self.watchlistById removeObjectForKey: watchlist_.watchlistId ];
}

-(void)didFinishTradeTransferServer:( PFServer* )server_
{
}

-(void)connectSubscriber:( PFQuoteSubscriber* )subscriber_
{
   subscriber_.delegate = self;
   NSArray* symbols_ = subscriber_.symbolIds;
   if ( [ symbols_ count ] > 0 )
   {
      [ self.server subscribeToSymbols: symbols_ type: subscriber_.subscriptionType ];
   }
}

-(void)addStories:( NSArray* )stories_
{
   if ( [ stories_ count ] > 0 )
   {
      [ self.mutableStories addStories: stories_ ];
      [ self.delegate session: self didLoadStories: stories_ ];
   }
}

-(void)scheduleDowJonesReadFromContext:( NSString* )alert_context_
{
   if ( !self.dowJonesReader )
      return;

   __unsafe_unretained PFSession* unsafe_session_ = self;
   
   PFDowJonesReader* reader_ = self.dowJonesReader;

   ADQueueBlock read_block_ = ^()
   {
      [ reader_ readNewsWithAlertContext: alert_context_
                               doneBlock: ^( NSArray* stories_, NSString* new_alert_context_, NSError* error_ )
       {
          [ unsafe_session_ addStories: stories_ ];
          [ unsafe_session_ scheduleDowJonesReadFromContext: new_alert_context_ ];
       }];
   };

   ADDelayAsyncOnMainThread( read_block_, 60.0 );
}

-(void)didFinishTransferServer:( PFServer* )server_
{
    //TODO
    /*
     DONT forget!!!!
   all  users rules and accounts storage now in account object
     */
  
    for(PFRule * r in self.notMtableRules){
        if(r.ownerType == OWNER_ACCOUNT ||
           r.ownerType == OWNER_USER ||
           r.ownerType == OWNER_USER_GROUP)
        {
            [self.mutableAccounts addRule:r withTransferFinished:YES];
            (self.mutableRules)[r.name] = r;
        }
    }
    
   if ( self.needChangePassword )
   {
      [ self.delegate session: self changePasswordForUser: self.user.userId ];
      return;
   }
   
   [ self.mutableAccounts connectToSymbols: self.symbols ];
   
   //Add symbol connections for positions
   for ( PFPosition* position_ in self.mutableAccounts.positions.positions )
   {
      [ self.mutableQuoteSubscriber addSymbolConnection: position_ ];
   }
   
   //Add symbol connections for orders
   for (PFOrder* order_ in self.mutableAccounts.orders.orders )
   {
      [ self.mutableQuoteSubscriber addSymbolConnection: order_ ];
   }
   
   //Bound orders
   for (PFOrder* order_ in self.mutableAccounts.orders.orders )
   {
      [ self bound: YES order: order_ ];
   }

   //Ready for subscribe
   [ self connectSubscriber: self.mutableQuoteSubscriber ];
   [ self connectSubscriber: self.mutableLevel2QuoteSubscriber ];
   [ self connectSubscriber: self.mutableLevel4QuoteSubscriber ];
   [ self connectSubscriber: self.mutableLevel3QuoteSubscriber ];

   if ( self.allowsNews )
   {
      [ self storiesFromDate: [ [ NSDate date ] dateByAddingTimeInterval: -1*24*60*60 ]
                      toDate: [ NSDate date ] ];
   }

   self.dowJonesReader = [ PFDowJonesReader readerWithPublicToken: self.dowJonesToken ];
   [ self.dowJonesReader readNewsWithAlertContext: nil
                                        doneBlock: ^( NSArray* stories_, NSString* alert_context_, NSError* error_ )
    {
       [ self addStories: stories_ ];
       [ self scheduleDowJonesReadFromContext: alert_context_ ];
    }];

   [ self.delegate session: self didLoadAccounts: self.accounts ];
   
   [ self.delegate didFinishBlockTransferSession: self ];
   [ self startAsyncCalculator ];
    [ self.delegate didClientLaunchedSession: self ];
   
   if ( self.user.wrongServer )
      [ self displayWrongServerMessage ];
   
   
   for ( PFChatMessage* brocker_message_ in self.brockerMessages )
   {
      [ self displayBrockerMessage: brocker_message_ ];
   }
   self.brockerMessages = nil;
    
   for (PFInstrument* instr in [self.instruments instruments]) {
      instr.assetExp1 = [self.assetTypes assetTypeWithCurrency: instr.exp1];
      instr.assetExp2 = [self.assetTypes assetTypeWithCurrency: instr.exp2];
   }

   for (PFAccount* account_ in [self.accounts accounts])
   {
      for (PFAssetAccount* asset_account_ in account_.assetAccounts)
      {
         asset_account_.assetType = [self.assetTypes assetTypeWithId: asset_account_.assetId];
      }
      account_.currAssetAccount = (account_.sortedAssetAccounts)[0];
   }
}

-(void)server:( PFServer* )server_ didLoadQuoteMessage:( PFMessage* )message_
{
   NSArray* symbols_array_ = [ self.mutableSymbols updateWithQuoteMessage: message_ ];
   
   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      symbol_.quote = [ self.spreadPlans createlevel1QuoteWithQuote: symbol_.realQuote AndSpreadPlan: self.accounts.defaultAccount.spreadPlanId ];
      symbol_.quote.localDate = [ NSDate date ];
      
      ADAsyncOnMainThread(^()
                          {
                             [ self.delegate session: self
                                              symbol: symbol_
                                        didLoadQuote: symbol_.quote ];
                          });
   }   
}

-(void)server:( PFServer* )server_ didLoadTradeQuoteMessage:( PFMessage* )message_
{
   NSArray* symbols_array_ = [ self.mutableSymbols updateWithTradeQuoteMessage: message_ ];
   
   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      [ self.delegate session: self
                       symbol: symbol_
            didLoadTradeQuote: symbol_.tradeQuote ];
   }
}

-(void)server:( PFServer* )server_ didLoadLevel2Quote:( PFLevel2Quote* )quote_
{
   NSArray* symbols_array_ = [ self.mutableSymbols addSymbolConnectionByQuoteRouteId: quote_ ];

   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      [ self.delegate session: self
                       symbol: symbol_
        didUpdateLevel2Quotes: symbol_.level2Quotes ];
   }
}

-(void)server:( PFServer* )server_ didLoadLevel2QuotePackage:( PFLevel2QuotePackage* )package_
{
   NSArray* symbols_array_ = [ self.mutableSymbols addSymbolConnectionByQuoteRouteId: package_ ];

   for ( PFSymbol* symbol_ in symbols_array_ )
   {
      [ self.delegate session: self
                       symbol: symbol_
        didUpdateLevel2Quotes: symbol_.level2Quotes ];
   }
}

-(void)server:( PFServer* )server_ didLoadLevel4Quote:( PFLevel4Quote* )quote_
{
   [ self.mutableSymbols addSymbolConnectionByQuoteRouteId: quote_ ];
}

-(void)server:( PFServer* )server_ didLoadInstrument:( PFInstrument* )instrument_
{
   PFInstrument* founded_instrument_ = [ self.mutableInstruments instrumentWithId: instrument_.instrumentId ];
   NSArray* old_symbols_ = founded_instrument_ ? [ founded_instrument_.symbols copy ] : nil;
   NSArray* old_modes_ = [ old_symbols_ map: ^id( id object_ ) { return @( (NSInteger)[ object_ tradeMode ] ); } ];
   
   [ self.mutableInstruments addInstrument: instrument_ ];
   
   if ( instrument_.symbols.count > 0 && old_symbols_.count > 0 )
   {
      for ( PFSymbol* symbol_ in instrument_.symbols )
      {
         NSUInteger index_ = [ old_symbols_ indexOfObject: symbol_ ];
         if ( index_ != NSNotFound && [ old_modes_[index_] integerValue ] != PFTradeModeTradingHalt && symbol_.tradeMode == PFTradeModeTradingHalt )
         {
            [ self.delegate session: self didReceiveTradingHaltForSymbol: symbol_ ];
         }
      }
   }
}

-(void)server:( PFServer* )server_ didLoadInstrumentGroup:( PFInstrumentGroup* )group_
{
   [ self.mutableInstruments addInstrumentGroup: group_ ];
}

-(void)server:( PFServer* )server_ didLoadPositionMessage:( PFMessage* )message_
{
   [ self.mutableAccounts updatePositionWithMessage: message_ delegate: self ];
}

-(void)server:( PFServer* )server_ didClosePositionWithId:( PFInteger )position_id_
{
   PFPosition* position_ = [ self.mutableAccounts.positions positionWithId: position_id_ ];
   if ( position_ )
   {
      [ self.mutableAccounts removePosition: position_ delegate: self ];
   }
}

-(void)server:( PFServer* )server_ didLoadOrderMessage:( PFMessage* )message_
{
   [ self.mutableAccounts updateOrderWithMessage: message_ delegate: self ];
}

-(void)server:( PFServer* )server_ didLoadTradeMessage:( PFMessage* )message_
{
   [ self.mutableAccounts updateTradeWithMessage: message_ delegate: self ];
}

-(void)server:( PFServer* )server_ didLoadRouteMessage:( PFMessage* )route_message_
{
   [ self.mutableInstruments updateRouteWithMessage: route_message_ ];
}

-(void)server:( PFServer* )server_ didLoadAccountMessage:( PFMessage* )account_message_
{
   [ self.mutableAccounts updateAccountWithMessage: account_message_ delegate: self ];
}

-(void)server:( PFServer* )server_ didLoadPammAccountStatusMessage:( PFMessage* )pamm_account_status_message_
{
   [self.mutableAccounts updatePammAccountStatusesWithMessage: pamm_account_status_message_ delegate: self];
}

-(void)server:( PFServer* )server_ didLoadStories:( NSArray* )stories_
{
   [ self addStories: stories_ ];
}

-(void)server:( PFServer* )server_ didReceiveErrorMessage:( NSString* )message_
{
   if ( [ message_ length ] > 0 )
   {
      [ self.mutableEvents addObject: [ PFReportTable reportWithString: message_ ] ];
      [ self.delegate session: self didReceiveErrorMessage: message_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadReport:( PFReportTable* )report_
{
   [ self.mutableEvents addObject: report_ ];
   [ self.delegate session: self didLoadReport: report_ ];
}

-(void)server:( PFServer* )server_ didReceiveRejectMessage:( PFRejectMessage* )reject_message_
{
   NSString* message_text_ = (reject_message_.IsErrorCodeName) ? (reject_message_.nameErrorCode) : (reject_message_.comment);
   
   if ( [ message_text_ length ] > 0 )
   {
      [ self.mutableEvents addObject: [ PFReportTable reportWithString: message_text_ ] ];
      [ self.delegate session: self didReceiveErrorMessage: message_text_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadChatMessage:( PFChatMessage* )message_
{
   if ( message_.type == PFChatMessageBrockerUrgent || message_.type == PFChatMessageBrockerWelcome || message_.type == PFChatMessageBrockerPeriodic )
   {
      if ( server_.transferFinished )
      {
         [ self displayBrockerMessage: message_ ];
      }
      else
      {
         [ self.brockerMessages addObject: message_ ];
      }
   }
   else
   {
      [ self.mutableChat addMessage: message_ ];
      [ self.delegate session: self didLoadChatMessage: message_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadRule:( PFRule* )rule_
{
    
    [self.notMtableRules addObject:rule_];
    
    PFRule* existingRule =nil;
    for(int i =0;i<_not_mutable_rules.count;i++){
        if([[(self.notMtableRules)[i] name] isEqualToString:rule_.name]){
          existingRule = (self.mutableRules)[[rule_ name]];
           break;
        }
        
    }
    
    BOOL haveToReplace = NO;
    
if(existingRule)
    haveToReplace = [PFRule compareOwnerTypes:existingRule.ownerType withNew:rule_.ownerType];

    if(haveToReplace)
    {

        
//        if(existingRule)
//        {
//            
//      NSLog(@"RULE______");
//      NSLog(@"%@",[existingRule name]);
//      NSLog(@"%@",[existingRule value]);
//      NSLog(@"%d",[existingRule ownerType]);
//            
//      NSLog(@"REPLACED TO_____");
//      NSLog(@"%@",[rule_ value]);
//      NSLog(@"%d",[rule_ ownerType]);
 
//        }
       
        
        [self.notMtableRules removeObject:existingRule];
        [self.notMtableRules addObject:rule_];
       //  [self.mutableRules removeObjectForKey:[rule_ name]];
   
      // [ self.mutableRules setObject: rule_ forKey: rule_.name ];
        
    }else if(!existingRule) {
//       [ self.mutableAccounts addRule: rule_ withTransferFinished: server_.transferFinished ];
       [self.notMtableRules addObject:rule_];
        // [ self.mutableRules setObject: rule_ forKey: rule_.name ];
        
    }
//    NSLog(@"________");
//     NSLog(@"Account:%lld",[rule_ accountId]);
//      NSLog(@"%@",[rule_ name]);
//     NSLog(@"Value:%@",[rule_ value]);
//     NSLog(@"OwnerType:%d",[rule_ ownerType]);
 
    
    
//    if(existingRule)
//    {
//        haveToReplace=[self compareOwnerTypes:[existingRule ownerType] withNew:rule_.ownerType];
//        [self.mutableRules removeObjectForKey:[rule_ name]];
//    }
//    
//    else
//    {
//    
//        existingRule = [ self.mutableAccounts getRuleByName:rule_.name andAccountId:rule_.accountId];
//
//    }
    
  //  NSLog(@"________");
  //  NSLog(@"%@",[existingRule name]);
    
//   if ( rule_.accountId != -1 )
//   {
//       [ self.mutableAccounts addRule: rule_ withTransferFinished: server_.transferFinished ];
//      // Some rules must be duplicated in Session Level
//      if ( [ self.user.accountIdStrings containsObject: [ NSString stringWithFormat: @"%lld", rule_.accountId ] ] &&
//          [ [ NSArray arrayWithObjects: PFRuleFunctionChat
//             , PFRuleFunctionNews
//             , PFRuleFunctionEventLog
//             , nil ] containsObject: rule_.name ] )
//      {
//         [ self.mutableRules setObject: rule_ forKey: rule_.name ];
//      }
//      
//   }
//   else
//   {
//      [ self.mutableRules setObject: rule_ forKey: rule_.name ];
//   }
}
//-(BOOL)compareOwnerTypes: (OwnerType)existing withNew:(OwnerType)newOwnerType{
//  //  BOOL res = NO;
//    
//    return ((existing == OWNER_USER || existing == OWNER_USER_GROUP) && (newOwnerType == OWNER_ACCOUNT || newOwnerType == OWNER_USER))?
//    YES:
//     NO;
//    
//
//    
//   //  res;
//}


-(id< PFRule >)ruleForName:( NSString* )name_
{
   return (self.mutableRules)[name_];
}

-(PFBool)allowsChat
{
   return [ [ self ruleForName: PFRuleFunctionChat ] boolValue ];
}

-(PFBool)allowsNews
{
   return [ [ self ruleForName: PFRuleFunctionNews ] boolValue ];
}

-(PFBool)allowsEventLog
{
   return [ [ self ruleForName: PFRuleFunctionEventLog ] boolValue ];
}

-(BOOL)allowsTradingForSymbol:( id< PFSymbol > )symbol_
{
   return symbol_.allowsTrading;
}

-(BOOL)allowsMarketOperation:( PFTradeSessionAllowedOperationType )market_operation_
                   forSymbol:( id< PFSymbol > )symbol_
{
   BOOL allows_by_trading_halt_ = market_operation_ == PFTradeSessionAllowedOperationTypeCancel ? YES : NO;
   
   BOOL allows_by_rules_ = ( [ self.accounts.defaultAccount.tradeRouteNames containsObject: symbol_.routeName ]
                            && [ [ self tradeSessionContainerForInstrument: symbol_.instrument ].currentTradeSession.allowedOperations containsObject: @( market_operation_ ) ] );
   
   return ( symbol_.tradeMode == PFTradeModeTradingHalt ? ( allows_by_trading_halt_ && allows_by_rules_ ) : allows_by_rules_ );
}

-(BOOL)allowsPlaceOperationsForSymbol:( id< PFSymbol > )symbol_
{
   return [ self allowsMarketOperation: PFTradeSessionAllowedOperationTypeOrderEntry
                             forSymbol: symbol_ ];
}

-(BOOL)allowsModifyOperationsForSymbol:( id< PFSymbol > )symbol_
{
   return [ self allowsMarketOperation: PFTradeSessionAllowedOperationTypeModify
                             forSymbol: symbol_ ];
}

-(BOOL)allowsPlaceOperationsGivenAccountForSymbol:( id< PFSymbol > )symbol_
{
   return [ self allowsMarketOperation: PFTradeSessionAllowedOperationTypeOrderEntry
                             forSymbol: symbol_ ] && [self.accounts.defaultAccount allowInstrument: symbol_.instrument ];
}

-(BOOL)allowsCancelOperationsForSymbol:( id< PFSymbol > )symbol_
{
   return [ self allowsMarketOperation: PFTradeSessionAllowedOperationTypeCancel
                             forSymbol: symbol_ ];
}

-(double)priceForCurrency:( NSString* )base_currency_
               toCurrency:( NSString* )to_currency_
{
   return [ [ PFCrossRates sharedRates ] priceForCurrency: base_currency_
                                               toCurrency: to_currency_ ];
}

-(void)server:( PFServer* )server_ didAllowReportWithName:( NSString* )report_name_
{
   PFReportTableType table_type_ = PFReportTableTypeWithReportName( report_name_ );
   if ( table_type_ != PFReportTableTypeUndefined )
   {
      [ self.mutableAllowedReportTypes addObject: @(table_type_) ];
   }
}

-(void)server:( PFServer* )server_ didLoadCommissionPlan:( PFCommissionPlan* )commission_plan_
{
   if ( commission_plan_.isValid )
   {
      [ self.commissionPlans addCommissionPlan: commission_plan_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadSpreadPlan:( PFSpreadPlan* )spread_plan_
{
   if ( spread_plan_.isValid )
   {
      [ self.spreadPlans addSpreadPlan: spread_plan_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadAssetType:(PFAssetType *)asset_type_
{
     [ self.assetTypes addAssetType: asset_type_ ];
}

-(void)server:( PFServer* )server_ didLoadTradeSessionContainer:( PFTradeSessionContainer* )trade_session_container_
{
   BOOL main_session_started_ = NO;
   
   if ( trade_session_container_ )
   {
      PFTradeSessionContainer* existing_container_ = (self.tradeSessionContainers)[@( trade_session_container_.tradeSessionContainerId )];
      
      if ( existing_container_ )
      {
         PFTradeSessionDayPeriodType old_period_type_ = existing_container_.currentTradeSession.dayPeriodType;
         
         [ existing_container_ updateWithContainer: trade_session_container_ ];
         
         PFTradeSessionDayPeriodType current_period_type_ = existing_container_.currentTradeSession.dayPeriodType;
         main_session_started_ = ( ( old_period_type_ != current_period_type_ ) && current_period_type_ == PFTradeSessionDayPeriodTypeMain );
      }
      else
      {
         (self.tradeSessionContainers)[@( trade_session_container_.tradeSessionContainerId )] = trade_session_container_;
         main_session_started_ = trade_session_container_.currentTradeSession.dayPeriodType == PFTradeSessionDayPeriodTypeMain;
      }
   }
   
   if ( main_session_started_ )
   {
      [ self.delegate didStartMainPeriodInTradeSessionContainer: trade_session_container_ ];
   }
}

-(void)server:( PFServer* )server_ didLoadChangePasswordStatus:( int )change_password_status_ andReason:( NSString* )reason_
{
   [ self.delegate session: self
  loadChangePasswordStatus: change_password_status_
                    reason: reason_ ];
}

-(void)server:( PFServer* )server_ didLoadCrossRatesMessage:( PFMessage* )message_
{
   [ [ PFCrossRates sharedRates ] updateWithMessage: message_ ];
}

-(void)server:( PFServer* )server_ overnightNotificationForAccountId:( PFInteger )account_id_
maintanceMargin:( PFDouble )maintance_margin_
availableMargin:( PFDouble )available_margin_
         date:( NSDate* )date_
{
   [ self.delegate session: self overnightNotificationForAccountId: account_id_ maintanceMargin: maintance_margin_ availableMargin: available_margin_ date: date_ ];
}

#pragma mark PFOrdersDelegate

-(id<PFSessionDelegate>)transferFinishedDelegate
{
   return self.server.transferFinished ? self.delegate : nil;
}

-(void)bound:( BOOL )bound_
       order:( PFOrder* )order_
{
   PFInteger bounded_id_ = order_.boundToOrderId;
   if ( bounded_id_ == -1 || order_.openOrder )
      return;
   
   PFPosition* base_position_ = [ self.mutableAccounts.positions positionWithId: bounded_id_ ];
   
   // for one position mode
   if ( !base_position_ )
   {
      base_position_ = [ self.mutableAccounts.positions positionWithOpenOrderId: bounded_id_ ];
   }
   
   [ base_position_ bound: bound_ order: order_ ];
   if ( base_position_ )
   {
      [ self.transferFinishedDelegate session: self didUpdatePosition: base_position_ type: PFPositionServerUpdate ];
      return;
   }

   PFOrder* base_order_ = [ self.mutableAccounts.orders orderWithId: bounded_id_ ];
   [ base_order_ bound: bound_ order: order_ ];
   if ( base_order_ )
   {
      [ self.transferFinishedDelegate session: self didUpdateOrder: base_order_ ];
   }
}

-(void)orders:( PFOrders* )orders_
didUpdateOrder:( PFOrder* )order_
{
   [ self.transferFinishedDelegate session: self didUpdateOrder: order_ ];
   [ self bound: YES order: order_ ];
}

-(void)orders:( PFOrders* )orders_
didRemoveOrder:( PFOrder* )order_
{
   if ( order_.strikePrice > 0.0 )
   {
      [ self.mutableLevel4QuoteSubscriber removeSymbolConnection: order_ ];
   }
   else
   {
      [ self.mutableQuoteSubscriber removeSymbolConnection: order_ ];
   }
   
   [ self.transferFinishedDelegate session: self didRemoveOrder: order_ ];
   [ self bound: NO order: order_ ];
}

-(void)orders:( PFOrders* )orders_
  didAddOrder:( PFOrder* )order_
{
   if ( order_.strikePrice > 0.0 )
   {
      [ self.mutableLevel4QuoteSubscriber addSymbolConnection: order_ ];
   }
   else
   {
      [ self.mutableQuoteSubscriber addSymbolConnection: order_ ];
   }
   
   [ self.transferFinishedDelegate session: self didAddOrder: order_ ];
   [ self bound: YES order: order_ ];
}

#pragma mark PFPositionsDelegate

-(void)openPositions:( PFPositions* )positions_
   didUpdatePosition:( PFPosition* )position_
{
   [ self.transferFinishedDelegate session: self
                         didUpdatePosition: position_
                                      type: PFPositionServerUpdate ];
}

-(void)openPositions:( PFPositions* )positions_
   didRemovePosition:( PFPosition* )position_
{
   if ( position_.strikePrice > 0.0 )
   {
      [ self.mutableLevel4QuoteSubscriber removeSymbolConnection: position_ ];
   }
   else
   {
      [ self.mutableQuoteSubscriber removeSymbolConnection: position_ ];
   }
   
   [ self.transferFinishedDelegate session: self didRemovePosition: position_ ];
}

-(void)openPositions:( PFPositions* )positions_
      didAddPosition:( PFPosition* )position_
{
   if ( position_.strikePrice > 0.0 )
   {
      [ self.mutableLevel4QuoteSubscriber addSymbolConnection: position_ ];
   }
   else
   {
      [ self.mutableQuoteSubscriber addSymbolConnection: position_ ];
   }
   
   [ self.transferFinishedDelegate session: self didAddPosition: position_ ];
}

#pragma mark PFTradesDelegate

-(void)trades:( PFTrades* )trades_ didAddTrade:( PFTrade* )trade_
{
   [ self.delegate session: self didAddTrade: trade_ ];
}

#pragma mark PFAccountsDelegate

-(void)accounts:( PFAccounts* )accounts_
didUpdateAccount:( PFAccount* )account_
{
   [ self.transferFinishedDelegate session: self didUpdateAccount: account_ ];
}

-(void)accounts:( PFAccounts* )accounts_
  didAddAccount:( PFAccount* )account_
{
   [ self.transferFinishedDelegate session: self didAddAccount: account_ ];
}

#pragma mark - PFWatchlistDelegate

-(void)watchlist:( PFWatchlist* )watchlist_
    didAddSymbol:( id< PFSymbol > )symbol_
{
   [ self.mutableQuoteSubscriber addDependence: watchlist_ forSymbol: symbol_ ];
   [ self.delegate session: self watchlist: watchlist_ didAddSymbol: symbol_ ];
}

-(void)watchlist:( PFWatchlist* )watchlist_
 didRemoveSymbols:( NSArray* )symbols_
{
   [ self.mutableQuoteSubscriber removeDependence: watchlist_ forSymbols: symbols_ ];
   [ self.delegate session: self watchlist: watchlist_ didRemoveSymbols: symbols_ ];
}

#pragma mark PFQuoteSubscriberDelegate

-(void)quoteSubscriber:( PFQuoteSubscriber* )subscriber_
    didAddSymbolWithId:( id< PFSymbolId > )symbol_id_
{
   [ self.server subscribeToSymbols: @[symbol_id_] type: subscriber_.subscriptionType ];
}

-(void)quoteSubscriber:( PFQuoteSubscriber* )subscriber_
 didRemoveSymbolWithId:( id< PFSymbolId > )symbol_id_
{
   [ self.server unsubscribeFromSymbols: @[symbol_id_] type: subscriber_.subscriptionType ];
}

#pragma mark PFAsyncCalculatorDelegate

-(void)asyncCalculator:( PFAsyncCalculator* )calculator_
didPerformCalculations:( NSArray* )calculations_
{
   //NSLog( @"didPerformCalculations time: %@", [ NSDate date ] );
}

#pragma mark delegates

-(id< PFSessionDelegate >)delegate
{
   return ( id< PFSessionDelegate > )self.delegates;
}

-(JFFMulticastDelegate*)delegates
{
   if ( !_delegates )
   {
      _delegates = [ JFFMulticastDelegate new ];
   }
   return _delegates;
}

-(void)addDelegate:( id< PFSessionDelegate > )delegate_
{
   [ self.delegates addDelegate: delegate_ ];
}

-(void)removeDelegate:( id< PFSessionDelegate > )delegate_
{
   [ self.delegates removeDelegate: delegate_ ];
}

-(void)removeAllDelegates
{
   [ self.delegates removeAllDelegates ];
}

@end
