#import "../PFTypes.h"
#import "PFCrossType.h"
#import "PFQuoteDependence.h"
#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

@protocol PFRule;

@protocol PFAccount <NSObject>

-(NSString*)name;
-(PFInteger)accountId;
-(PFDouble)balance;
-(PFDouble)netPl;
-(PFDouble)grossPl;
-(PFDouble)todayFees;
-(PFInteger)tradesCount;
-(PFDouble)amount;
-(PFCrossType)crossType;
-(PFInteger)crossInstrumentId;
-(PFDouble)crossInstrumentBid;
-(PFDouble)crossInstrumentAsk;
-(PFDouble)blockedBalance;
-(PFDouble)cashBalance;
-(PFDouble)blockedFunds;
-(PFDouble)ordersMargin;
-(PFDouble)positionsMargin;
-(PFDouble)tradingLevel;
-(PFDouble)warningLevel;
-(PFDouble)marginLevel;

-(NSString*)currency;
-(PFDouble)crossPrice;

-(PFDouble)equity;
-(PFDouble)value;
-(PFDouble)marginAvailable;
-(PFDouble)currentMargin;
-(PFDouble)marginWarning;
-(PFDouble)stopTrading;
-(PFDouble)stopOut;
-(PFDouble)withdrawalAvailable;

-(PFDouble)totalNetPl;
-(PFDouble)totalGrossPl;
-(PFDouble)profitForMargin;
-(PFDouble)stockValue;
-(PFDouble)investedFundCapital;
-(PFDouble)currentFundCapital;
-(PFDouble)fundCapitalGain;

-(NSArray*)orders;
-(NSArray*)allOrders;
-(NSArray*)positions;
-(NSArray*)trades;
-(NSArray*)operations;

-(PFInteger)spreadPlanId;

-(PFByte)accountState;

-(PFBool)allowsSLTP;
-(PFBool)allowsTrailingStop;
-(PFBool)allowsOCO;
-(PFBool)allowsChat;
-(PFBool)allowsNews;
-(PFBool)allowsLevel2;
-(PFBool)allowsOptions;
-(PFBool)allowsWithdrawal;
-(PFBool)allowsEventLog;
-(PFBool)allowsSymbolInfo;
-(PFBool)allowsTrading;
-(PFBool)notAllowOpenPositions;
-(PFBool)notAllowClosePositions;
-(PFBool)notAllowShortStock;

-(NSString*)baseCurrency;
-(NSArray*)tradeRouteNames;

-(PFDouble)currPammCapital;
-(PFDouble)startPammCapital;

@end

@class PFMessage;
@class PFPosition;
@class PFOrder;
@class PFTrade;
@class PFInstruments;
@class PFRule;
@class PFSymbols;

@protocol PFQuoteSubscriber;

@interface PFAccount : PFObject< PFAccount, PFQuoteDependence >

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFInteger accountId;
@property ( nonatomic, assign ) PFDouble balance;
@property ( nonatomic, assign ) PFDouble netPl;
@property ( nonatomic, assign ) PFDouble todayFees;
@property ( nonatomic, assign ) PFInteger tradesCount;
@property ( nonatomic, assign ) PFDouble amount;
@property ( nonatomic, assign ) PFDouble currPammCapital;
@property ( nonatomic, assign ) PFDouble startPammCapital;

@property ( nonatomic, assign ) PFCrossType crossType;
@property ( nonatomic, assign ) PFInteger crossInstrumentId;
@property ( nonatomic, assign ) PFDouble crossInstrumentBid;
@property ( nonatomic, assign ) PFDouble crossInstrumentAsk;
@property ( nonatomic, assign ) PFDouble priceForCrossPrice;
@property ( nonatomic, assign, readonly ) PFDouble crossPrice;
@property ( nonatomic, assign ) PFDouble blockedBalance;
@property ( nonatomic, assign ) PFDouble cashBalance;

@property ( nonatomic, assign ) PFDouble blockedFunds;
@property ( nonatomic, assign ) PFDouble ordersMargin;
@property ( nonatomic, assign ) PFDouble positionsMargin;

@property ( nonatomic, assign ) PFDouble tradingLevel;
@property ( nonatomic, assign ) PFDouble warningLevel;
@property ( nonatomic, assign ) PFDouble marginLevel;

@property ( nonatomic, assign ) PFDouble totalNetPl;
@property ( nonatomic, assign ) PFDouble totalGrossPl;
@property ( nonatomic, assign ) PFDouble profitForMargin;
@property ( nonatomic, assign ) PFDouble stockValue;

@property ( nonatomic, assign ) PFInteger spreadPlanId;

@property ( nonatomic, assign ) PFByte accountState;

@property ( nonatomic, strong ) NSString* currency;
@property ( nonatomic, strong ) NSArray* tradeRouteNames;

@property ( nonatomic, assign, readonly ) PFDouble equity;
@property ( nonatomic, assign, readonly ) PFDouble value;
@property ( nonatomic, assign, readonly ) PFDouble marginAvailable;
@property ( nonatomic, assign, readonly ) PFDouble currentMargin;
@property ( nonatomic, assign, readonly ) PFDouble marginWarning;
@property ( nonatomic, assign, readonly ) PFDouble stopTrading;
@property ( nonatomic, assign, readonly ) PFDouble stopOut;
@property ( nonatomic, assign, readonly ) PFDouble withdrawalAvailable;

@property ( nonatomic, assign, readonly ) PFBool allowsSLTP;
@property ( nonatomic, assign, readonly ) PFBool allowsTrailingStop;
@property ( nonatomic, assign, readonly ) PFBool allowsOCO;
@property ( nonatomic, assign, readonly ) PFBool allowsChat;
@property ( nonatomic, assign, readonly ) PFBool allowsNews;
@property ( nonatomic, assign, readonly ) PFBool allowsLevel2;
@property ( nonatomic, assign, readonly ) PFBool allowsOptions;
@property ( nonatomic, assign, readonly ) PFBool allowsWithdrawal;
@property ( nonatomic, assign, readonly ) PFBool allowsEventLog;
@property ( nonatomic, assign, readonly ) PFBool allowsSymbolInfo;
@property ( nonatomic, assign, readonly ) PFBool allowsTrading;
@property ( nonatomic, assign, readonly ) PFBool notAllowOpenPositions;
@property ( nonatomic, assign, readonly ) PFBool notAllowClosePositions;
@property ( nonatomic, assign, readonly ) PFBool notAllowShortStock;

@property ( nonatomic, strong, readonly ) NSString* baseCurrency;

+(id)accountWithId:( PFInteger )account_id_;

-(PFPosition*)updatePositionWithMessage:( PFMessage* )message_;
-(PFOrder*)updateOrderWithMessage:( PFMessage* )message_;
-(PFTrade*)updateTradeWithMessage:( PFMessage* )message_;

-(void)updateOrder:( PFOrder* )order_;

-(void)removePosition:( PFPosition* )position_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

-(void)addRule:( PFRule* )rule_;

@end
