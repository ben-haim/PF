#import "PFTypes.h"

#import "Data/PFChartPeriodType.h"
#import "Data/PFDoneBlockDefs.h"
#import "Data/PFPositionUpdateType.h"
#import "Data/PFReportTableType.h"
#import "Data/PFWatchlist.h"

#import <Foundation/Foundation.h>

typedef void (^PFReconnectionBlock)();

@protocol PFAccount;
@protocol PFAccounts;

@protocol PFPosition;
@protocol PFOrder;
@protocol PFTrade;

@protocol PFInstrument;
@protocol PFInstruments;
@protocol PFStories;

@protocol PFSymbol;
@protocol PFSymbols;

@protocol PFUser;
@protocol PFChat;

@protocol PFReportTable;
@protocol PFSearchCriteria;
@protocol PFQuote;

@protocol PFQuoteSubscriber;

@protocol PFSessionDelegate;
@protocol PFCommissionGroup;

@protocol PFTradeSessionContainer;

@protocol PFAssetType;

@class PFWatchlist;
@class PFServerInfo;

@interface PFSession : NSObject< PFWatchlistDelegate >

@property ( nonatomic, strong, readonly ) id< PFSessionDelegate > delegate;
@property ( nonatomic, strong, readonly ) id< PFUser > user;
@property ( nonatomic, strong, readonly ) id< PFChat > chat;
@property ( nonatomic, strong, readonly ) id< PFAccounts > accounts;
@property ( nonatomic, strong, readonly ) id< PFInstruments > instruments;
@property ( nonatomic, strong, readonly ) id< PFStories > stories;
@property ( nonatomic, strong, readonly ) id< PFSymbols > symbols;
@property ( nonatomic, strong, readonly ) NSArray* optionSymbols;
@property ( nonatomic, strong, readonly ) id< PFQuoteSubscriber > quoteSubscriber;
@property ( nonatomic, strong, readonly ) id< PFQuoteSubscriber > level2QuoteSubscriber;
@property ( nonatomic, strong, readonly ) id< PFQuoteSubscriber > level3QuoteSubscriber;
@property ( nonatomic, strong, readonly ) id< PFQuoteSubscriber > level4QuoteSubscriber;
@property ( nonatomic, strong, readonly ) NSSet* allowedReportTypes;
@property ( nonatomic, strong, readonly ) NSArray* supportedReportTypes;
@property ( nonatomic, strong, readonly ) NSArray* events;


@property ( nonatomic, strong, readonly ) PFServerInfo* serverInfo;
@property ( nonatomic, strong, readonly ) NSString* login;
@property ( nonatomic, strong, readonly ) NSString* password;

@property ( nonatomic, strong ) NSString* dowJonesToken;
@property ( nonatomic, strong ) NSArray* defaultSymbolNames;
@property ( nonatomic, copy ) PFReconnectionBlock reconnectionBlock;

@property ( nonatomic, assign ) BOOL needChangePassword;

@property ( nonatomic, assign, readonly ) PFBool allowsChat;
@property ( nonatomic, assign, readonly ) PFBool allowsNews;
@property ( nonatomic, assign, readonly ) PFBool allowsEventLog;

@property ( nonatomic, assign, readonly ) double transferCommission;

+(void)setSharedSession:( PFSession* )session_;
+(PFSession*)sharedSession;

-(id< PFWatchlist >)watchlistWithId:( NSString* )watchlist_id_;

-(void)addWatchlist:( PFWatchlist* )watchlist_;
-(void)removeWatchlist:( PFWatchlist* )watchlist_;

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_;
-(void)disconnect;
-(void)disconnectServers;

-(void)selectDefaultAccount:( id< PFAccount > )default_account_;

-(void)logonWithLogin:( NSString* )login_
             password:( NSString* )password_
 verificationPassword:( NSString* )verification_password_
       verificationId:( int )verification_id_
            ipAddress:( NSString* )ip_address_;

-(void)historyFromDate:( NSDate* )from_date_
                toDate:( NSDate* )to_date_
             doneBlock:( PFReportDoneBlock )done_block_;

-(void)reportTableWithType:( PFReportTableType )table_type_
                  fromDate:( NSDate* )from_date_
                    toDate:( NSDate* )to_date_
                 doneBlock:( PFReportDoneBlock )done_block_;

-(void)reportTableWithCriteria:( id< PFSearchCriteria > )criteria_
                     doneBlock:( PFReportDoneBlock )done_block_;

-(void)createOrder:( id< PFOrder > )order_;
-(void)replaceOrder:( id< PFOrder > )order_
          withOrder:( id< PFOrder > )new_order_;

-(void)executeOrder:( id< PFOrder > )order_;
-(void)cancelOrder:( id< PFOrder > )order_;

-(void)closePosition:( id< PFPosition > )position_;

-(void)cancelAllOrdersForAccount:( id< PFAccount > )account_;

-(void)closeAllPositionsForAccount:( id< PFAccount > )account_;

-(void)withdrawalForAccount:( id< PFAccount > )account_
                  andAmount:( PFDouble )amount_;

-(void)transferFromAccount:( id< PFAccount > )from_account_
                 toAccount:( id< PFAccount > )to_account_
                    amount:( PFDouble )amount_;

-(void)historyForSymbol:( id< PFSymbol > )symbol_
                 period:( PFChartPeriodType )period_
               fromDate:( NSDate* )from_date_
                 toDate:( NSDate* )to_date_
              doneBlock:( PFHistoryDoneBlock )done_block_;

-(void)historyReaderForSymbol:( id< PFSymbol > )symbol_
                       period:( PFChartPeriodType )period_
                     fromDate:( NSDate* )from_date_
                       toDate:( NSDate* )to_date_
                    doneBlock:( PFChartFilesDoneBlock )done_block_;

-(void)replacePosition:( id< PFPosition > )position_
          withPosition:( id< PFPosition > )new_position_;

-(void)sendChatMessageWithText:( NSString* )message_text_;

-(void)logout;

-(void)applyNewPassword:( NSString* )new_password_
            oldPassword:( NSString* )old_password_
   verificationPassword:( NSString* )verification_password_
                 userId:( int )user_Id_;

-(void)addDelegate:( id< PFSessionDelegate > )delegate_;
-(void)removeDelegate:( id< PFSessionDelegate > )delegate_;
-(void)removeAllDelegates;

-(void)recalcSpreadChartQuotesWithQuotes: ( NSArray* )quotes_
                           AndInstrument: ( id<PFInstrument> )instrument_;

-(void)recalcSpreadLevel2QuotesWithBidQuotes: ( NSArray* )bid_quotes_
                                AndAskQuotes: ( NSArray* )ask_quotes_
                               AndInstrument: ( id<PFInstrument> )instrument_
                                AndLevel1Bid: ( double )bid_
                                AndLevel1Ask: ( double )ask_;

-(NSArray*)currentCommissionLevelForInstrument:( id< PFInstrument > )instrument_;
-(id< PFTradeSessionContainer >)tradeSessionContainerForInstrument:( id< PFInstrument > )instrument_;

-(id< PFAssetType >)assetTypeForCurrency:( NSString* )currency_;

-(BOOL)allowsTradingForSymbol:( id< PFSymbol > )symbol_;
-(BOOL)allowsPlaceOperationsForSymbol:( id< PFSymbol > )symbol_;
-(BOOL)allowsPlaceOperationsGivenAccountForSymbol:( id< PFSymbol > )symbol_;
-(BOOL)allowsModifyOperationsForSymbol:( id< PFSymbol > )symbol_;
-(BOOL)allowsCancelOperationsForSymbol:( id< PFSymbol > )symbol_;

-(double)priceForCurrency:( NSString* )base_currency_
               toCurrency:( NSString* )to_currency_;

+(BOOL)useUnsafeSSL;
+(void)setUseUnsafeSSL:( BOOL )use_unsafe_;

@end

@protocol PFChatMessage;
@protocol PFLevel3Quote;
@protocol PFLevel2QuotePackage;
@protocol PFLevel4Quote;

@protocol PFSessionDelegate <NSObject>

@optional

-(void)didConnectSession:( PFSession* )session_;

-(void)session:( PFSession* )session_
didFailConnectWithError:( NSError* )error_;

-(void)didLogonSession:( PFSession* )session_;

-(void)session:( PFSession* )session_
needVerificationWithId:( int )verification_id_;

-(void)session:( PFSession* )session_
changePasswordForUser:( int )user_id_;

-(void)session:( PFSession* )session_
loadChangePasswordStatus:( int )change_password_status_
        reason:( NSString* )reason_;

-(void)session:( PFSession* )session_
didLogoutWithReason:( NSString* )reason_;

-(void)session:( PFSession* )session_
didLoadInstruments:( id< PFInstruments > )instruments_;

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_;

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
didLoadTradeQuote:( id< PFLevel3Quote > )trade_quote_;

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
didUpdateLevel2Quotes:( id< PFLevel2QuotePackage > )quotes_;

-(void)session:( PFSession* )session_
didUpdatePosition:( id< PFPosition > )position_
          type:( PFPositionUpdateType )type_;

-(void)session:( PFSession* )session_
didRemovePosition:( id< PFPosition > )position_;

-(void)session:( PFSession* )session_
  didAddPosition:( id< PFPosition > )position_;

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_;

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_;

-(void)session:( PFSession* )session_
didUpdateOrder:( id< PFOrder > )order_;

-(void)session:( PFSession* )session_
   didAddTrade:( id< PFTrade > )trade_;

-(void)session:( PFSession* )session_
didLoadAccounts:( id< PFAccounts > )accounts_;

-(void)session:( PFSession* )session_
 didAddAccount:( id< PFAccount > )account_;

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_;

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_;

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories_;

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
  didAddSymbol:( id< PFSymbol > )symbol_;

-(void)session:( PFSession* )session_
     watchlist:( id< PFWatchlist > )watchlist_
didRemoveSymbols:( NSArray* )symbols_;

-(void)session:( PFSession* )session_
didReceiveErrorMessage:( NSString* )message_;

-(void)session:( PFSession* )session_
didReceiveBrockerMessage:( NSString* )message_
withCancelMode:( BOOL )cancel_mode_;

-(void)session:( PFSession* )session_
 didLoadReport:( id< PFReportTable > )report_;

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_;

-(void)session:( PFSession* )session_
didReceiveTradingHaltForSymbol:( id< PFSymbol > )symbol_;

-(void)didFinishBlockTransferSession:( PFSession* )session_;

-(void)didClientLaunchedSession:( PFSession* )session_;

-(void)didStartMainPeriodInTradeSessionContainer:( id< PFTradeSessionContainer > )trade_session_container_;

-(void)session:( PFSession* )session_
didProcessMessage:( NSString* )message_;

-(void)wrongServerWithSession:( PFSession* )session_;

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_;

-(void)session:( PFSession* )session_
didAddWatchlist:( id< PFWatchlist > )watchlist_;

-(void)session:( PFSession* )session_ overnightNotificationForAccountId:( PFInteger )account_id_
maintanceMargin:( PFDouble )maintance_margin_
availableMargin:( PFDouble )available_margin_
          date:( NSDate* )date_;

@end
