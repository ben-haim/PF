#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

enum
{
   PFInstrumentGeneral
   , PFInstrumentForex
   , PFInstrumentStocks
   , PFInstrumentFutures
   , PFInstrumentOptions
   , PFInstrumentCFDIndex
   , PFInstrumentForward
   , PFInstrumentCFDFutures
   , PFInstrumentIndices
};

enum
{
   PFInstrumentMarginTypePFS = 0
   , PFInstrumentMarginTypeMT = 1
   , PFInstrumentMarginTypeFutures = 2
   , PFInstrumentMarginTypeINT = 3
   , PFInstrumentMarginTypeStocks = 4
   , PFInstrumentMarginTypeExposition = 5
   , PFInstrumentMarginTypeOptions = 6
   , PFInstrumentMarginTypeMT4 = 10
};

enum
{
   PFTradeModeNotAllowed = 0
   , PFTradeModeTradingAllowed = 1
   , PFTradeModeOrdersAllowed = 2
   , PFTradeModeOrdersAndLargeTradesAllowed = 3
};

enum
{
   PFDeliveryStatusWaitForPrice = 0
   , PFDeliveryStatusDelivered = 1
   , PFDeliveryStatusReady = 2
};

enum
{
   PFMarginModeUseProfitLoss = 0
   , PFMarginModeUseProfit = 1
   , PFMarginModeUseLoss = 2
   , PFMarginModeDoNotUseProfitLoss = 3
};

@protocol PFInstrumentGroup;

@protocol PFInstrument <NSObject>

-(PFByte)type;

-(PFInteger)instrumentId;
-(PFInteger)baseInstrumentId;
-(PFInteger)groupId;

-(NSString*)name;
-(NSString*)overview;
-(NSArray*)routes;
-(NSArray*)tradeRouteNames;
-(NSArray*)infoRouteNames;
-(NSArray*)routeNames;
-(NSArray*)expirationDates;
-(NSArray*)lastTradeDates;
-(NSArray*)settlementDates;
-(NSArray*)noticeDates;
-(NSArray*)firstTradeDates;
-(NSArray*)autoCloseDates;
-(NSArray*)deliveryStatuses;
-(NSArray*)isContiniousContracts;
-(NSArray*)sessions;

-(PFDouble)pointSize;
-(PFLong)lotSize;

-(PFDouble)lotStep;
-(PFDouble)minimalLot;

-(PFByte)precision;
-(PFByte)marginMode;

-(PFByte)historyType;

-(PFDouble)pipsSize;
-(PFDouble)tickCoast;
-(PFDouble)profitWithGrossPl:( PFDouble )gross_pl_;

-(PFInteger)marginType;
-(PFByte)tradingBalance;
-(PFByte)tradeMode;
-(NSString*)deliveryMethod;
-(NSString*)exp1;
-(NSString*)exp2;
-(PFDouble)swapBuy;
-(PFDouble)swapSell;

-(PFBool)isForex;
-(PFBool)isFutures;
-(PFBool)isOption;

-(id< PFInstrumentGroup >)group;

-(NSArray*)symbols;
-(NSArray*)symbolsForRouteId:(PFInteger)route_id_;

@end

@class PFSymbol;

@interface PFInstrument : PFObject< PFInstrument >

@property ( nonatomic, assign ) PFByte type;

@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic, assign ) PFInteger baseInstrumentId;
@property ( nonatomic, assign ) PFInteger groupId;

@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong ) NSString* overview;
@property ( nonatomic, strong ) NSArray* routes;
@property ( nonatomic, strong ) NSArray* tradeRouteNames;
@property ( nonatomic, strong ) NSArray* infoRouteNames;

@property ( nonatomic, strong ) NSArray* expirationDates;
@property ( nonatomic, strong ) NSArray* lastTradeDates;
@property ( nonatomic, strong ) NSArray* settlementDates;
@property ( nonatomic, strong ) NSArray* noticeDates;
@property ( nonatomic, strong ) NSArray* firstTradeDates;
@property ( nonatomic, strong ) NSArray* autoCloseDates;
@property ( nonatomic, strong ) NSArray* deliveryStatuses;
@property ( nonatomic, strong ) NSArray* isContiniousContracts;

@property ( nonatomic, strong ) NSArray* sessions;

@property ( nonatomic, assign ) PFDouble pointSize;
@property ( nonatomic, assign ) PFLong lotSize;

@property ( nonatomic, assign ) PFDouble lotStep;
@property ( nonatomic, assign ) PFDouble minimalLot;

@property ( nonatomic, assign ) PFByte precision;
@property ( nonatomic, assign ) PFByte marginMode;

@property ( nonatomic, assign ) PFByte historyType;

@property ( nonatomic, assign, readonly ) PFBool isForex;
@property ( nonatomic, assign, readonly ) PFBool isFutures;
@property ( nonatomic, assign, readonly ) PFBool isOption;

@property ( nonatomic, assign, readonly ) PFDouble pipsSize;
@property ( nonatomic, assign ) PFDouble tickCoast;
@property ( nonatomic, assign ) PFInteger marginType;

@property ( nonatomic, assign ) PFByte tradingBalance;
@property ( nonatomic, assign ) PFByte tradeMode;
@property ( nonatomic, strong ) NSString* deliveryMethod;
@property ( nonatomic, strong ) NSString* exp1;
@property ( nonatomic, strong ) NSString* exp2;
@property ( nonatomic, assign ) PFDouble swapBuy;
@property ( nonatomic, assign ) PFDouble swapSell;

@property ( nonatomic, strong ) NSArray* symbols;

//!weak reference to group
@property ( nonatomic, weak, readonly ) id< PFInstrumentGroup > group;

-(void)connectToGroup:( id< PFInstrumentGroup > )group_;
-(void)disconnectFromGroup;
-(PFDouble)profitWithGrossPl:( PFDouble )gross_pl_;
-(void)synchronizeWithInstrument:( PFInstrument* )instrument_;

+(void)setServerTimeOffset:( int )server_offset_;

@end
