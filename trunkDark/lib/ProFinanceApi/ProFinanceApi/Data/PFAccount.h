#import "../PFTypes.h"
#import "PFCrossType.h"
#import "PFQuoteDependence.h"
#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

typedef enum
{
    PFAccountTypeSingleCCY,
    PFAccountTypeMultiAsset,
    PFAccountTypeClosedFund,
    PFAccountTypeOpenFund,
} PFAccountType;

@protocol PFRule;
@class PFMessage;
@class PFPosition;
@class PFOrder;
@class PFTrade;
@class PFInstruments;
@protocol PFInstrument;
@class PFRule;
@class PFSymbols;
@class PFAssetAccount;
@class PFAccount;

@protocol PFAccount <NSObject>

-(PFDouble)balance;
-(PFDouble)netPl;
-(PFDouble)grossPl;
-(PFDouble)todayFees;
-(PFInteger)tradesCount;
-(PFDouble)amount;
-(PFDouble)precision;
-(PFDouble)blockedSum;
-(PFDouble)cashBalance;
-(PFDouble)blockedFunds;
-(PFDouble)blockedForOrders;
-(PFDouble)initMargin;
-(NSString*)currency;

-(PFCrossType)crossType;
-(PFDouble)crossInstrumentBid;

-(NSString*)name;
-(PFInteger)accountId;
-(PFDouble)tradingLevel;
-(PFDouble)warningLevel;
-(PFDouble)marginLevel;

-(PFDouble)leverage;
-(PFByte)type;
-(PFInteger)userId;
-(PFInteger)groupId;
-(PFByte)accountType;

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

-(NSArray*)orders;
-(NSArray*)allOrders;
-(NSArray*)positions;
-(NSArray*)trades;
-(NSArray*)operations;

-(int)positionSum;
-(int)orderSum;

-(PFInteger)commissionPlanId;
-(PFInteger)spreadPlanId;

-(PFByte)accountState;

-(PFBool)allowsOvernightTrading;
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
-(PFBool)allowTransfer;
-(PFBool)marginMode;
-(PFBool)riskFromEquity;
-(NSString*)baseCurrency;
-(NSArray*)tradeRouteNames;

-(PFDouble)investedFundCapital;
-(PFDouble)currentFundCapital;
-(PFDouble)fundCapitalGain;
-(PFDouble)startPammCapital;
-(PFAssetAccount*)currAssetAccount;
-(NSArray*)assetAccounts;
-(NSArray*)sortedAssetAccounts;
-(PFDouble)deficiencyMargin;
-(PFDouble)usedMargin;
-(PFDouble)maintanceMargin;
-(PFDouble)availableMargin;

-(PFDouble)sumPositivePositionsNetPL;
-(PFDouble)sumNegativePositionsNetPL;
-(PFDouble)sumPositiveFilledOrdersNetPL;
-(PFDouble)sumNegativeFilledOrdersNetPL;

-(PFDouble)realizedPositionsNetPl;
-(PFDouble)realizedFilledOrdersNetPl;

-(void)setCurrAssetAccountFromAccount: (id< PFAccount >)account_;
-(PFBool)allowInstrument: (id< PFInstrument >)instrument_;
-(PFAssetAccount*)assetAccountByCurrency:( NSString* )currency_;

@end

@protocol PFQuoteSubscriber;

@interface PFAccount : PFObject< PFAccount, PFQuoteDependence >

@property ( nonatomic, assign, readonly ) PFDouble balance;
@property ( nonatomic, assign, readonly ) PFDouble netPl;
@property ( nonatomic, assign, readonly ) PFDouble todayFees;
@property ( nonatomic, assign, readonly ) PFInteger tradesCount;
@property ( nonatomic, assign, readonly ) PFDouble amount;
@property ( nonatomic, assign, readonly ) PFDouble precision;
@property ( nonatomic, assign, readonly ) PFDouble blockedSum;
@property ( nonatomic, assign, readonly ) PFDouble cashBalance;
@property ( nonatomic, assign, readonly ) PFDouble blockedFunds;
@property ( nonatomic, assign, readonly ) PFDouble blockedForOrders;
@property ( nonatomic, assign, readonly ) PFDouble initMargin;
@property ( nonatomic, strong, readonly ) NSString* currency;

@property ( nonatomic, assign ) PFDouble currentFundCapital;
@property ( nonatomic, assign ) PFDouble startPammCapital;
@property ( nonatomic, strong ) PFAssetAccount* currAssetAccount;

@property ( nonatomic, assign ) PFCrossType crossType;
@property ( nonatomic, assign ) PFDouble crossInstrumentBid;

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFInteger accountId;
@property ( nonatomic, strong ) NSMutableDictionary* ruleByName;
@property ( nonatomic, assign, readonly ) PFDouble crossPrice;
@property ( nonatomic, assign ) PFDouble leverage;
@property ( nonatomic, assign ) PFByte type;
@property ( nonatomic, assign ) PFInteger userId;
@property ( nonatomic, assign ) PFInteger groupId;
@property ( nonatomic, assign ) PFByte accountType;

@property ( nonatomic, assign ) PFDouble tradingLevel;
@property ( nonatomic, assign ) PFDouble warningLevel;
@property ( nonatomic, assign ) PFDouble marginLevel;

@property ( nonatomic, assign, readonly ) PFDouble totalNetPl;
@property ( nonatomic, assign, readonly ) PFDouble totalGrossPl;
@property ( nonatomic, assign ) PFDouble profitForMargin;
@property ( nonatomic, assign ) PFDouble stockValue;

@property ( nonatomic, assign ) PFInteger commissionPlanId;
@property ( nonatomic, assign ) PFInteger spreadPlanId;

@property ( nonatomic, assign ) PFByte accountState;
@property ( nonatomic, strong ) NSArray* tradeRouteNames;

@property ( nonatomic, assign ) PFDouble sumPositivePositionsNetPL;
@property ( nonatomic, assign ) PFDouble sumNegativePositionsNetPL;
@property ( nonatomic, assign ) PFDouble sumPositiveFilledOrdersNetPL;
@property ( nonatomic, assign ) PFDouble sumNegativeFilledOrdersNetPL;

@property ( nonatomic, assign, readonly ) PFDouble equity;
@property ( nonatomic, assign, readonly ) PFDouble value;
@property ( nonatomic, assign, readonly ) PFDouble marginAvailable;
@property ( nonatomic, assign, readonly ) PFDouble currentMargin;
@property ( nonatomic, assign, readonly ) PFDouble marginWarning;
@property ( nonatomic, assign, readonly ) PFDouble stopTrading;
@property ( nonatomic, assign, readonly ) PFDouble stopOut;
@property ( nonatomic, assign, readonly ) PFDouble withdrawalAvailable;

@property ( nonatomic, assign ) PFBool allowsOvernightTrading;
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
@property ( nonatomic, assign, readonly ) PFBool allowTransfer;
@property ( nonatomic, assign, readonly ) PFBool marginMode;
@property ( nonatomic, assign, readonly ) PFBool riskFromEquity;

@property ( nonatomic, strong, readonly ) NSString* baseCurrency;
@property ( nonatomic, strong, readonly ) NSArray* assetAccounts;
@property ( nonatomic, strong, readonly ) NSArray* sortedAssetAccounts;

+(id)accountWithId:( PFInteger )account_id_;

-(PFPosition*)updatePositionWithMessage:( PFMessage* )message_;
-(PFOrder*)updateOrderWithMessage:( PFMessage* )message_;
-(PFTrade*)updateTradeWithMessage:( PFMessage* )message_;

-(void)updateOrder:( PFOrder* )order_;

-(void)removePosition:( PFPosition* )position_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

-(void)addRule:( PFRule* )rule_;

-(void)removeRule:( PFRule* )rule_;
-(PFRule* )getRule:( NSString* )ruleName andAccountId:(int)accId;

-(void)setCurrAssetAccountFromId: (PFInteger)asset_id_;

@end
