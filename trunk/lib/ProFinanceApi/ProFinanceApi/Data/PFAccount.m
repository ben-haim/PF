#import "PFAccount.h"

#import "PFOrders.h"
#import "PFOrder.h"

#import "PFPosition.h"
#import "PFPositions.h"

#import "PFTrade.h"
#import "PFTrades.h"

#import "PFOrderHistory.h"

#import "PFInstruments.h"
#import "PFInstrument.h"
#import "PFSymbol.h"
#import "PFQuote.h"
#import "PFRule.h"

#import "PFQuoteSubscriber.h"

#import "PFMetaObject.h"
#import "PFField.h"

@interface PFAccount ()< PFPositionsDelegate, PFOrdersDelegate, PFTradesDelegate, PFOrderHistoryDelegate >

@property ( nonatomic, strong ) PFOrders* mutableOrders;
@property ( nonatomic, strong ) PFPositions* mutablePositions;
@property ( nonatomic, strong ) PFTrades* mutableTrades;
@property ( nonatomic, strong ) PFOrderHistory* orderHistory;
@property ( nonatomic, strong ) NSMutableDictionary* ruleByName;

@end

@implementation PFAccount

@synthesize accountId;
@synthesize name;
@synthesize balance;
@synthesize netPl;
@synthesize todayFees;
@synthesize tradesCount;
@synthesize amount;
@synthesize crossType;
@synthesize crossInstrumentId;
@synthesize crossInstrumentBid;
@synthesize crossInstrumentAsk;
@synthesize priceForCrossPrice;
@synthesize blockedBalance;
@synthesize cashBalance;
@synthesize blockedFunds;
@synthesize ordersMargin;
@synthesize positionsMargin;
@synthesize tradingLevel;
@synthesize warningLevel;
@synthesize marginLevel;
@synthesize currency;
@synthesize tradeRouteNames;

@synthesize totalNetPl;
@synthesize totalGrossPl;
@synthesize profitForMargin;
@synthesize stockValue;
@synthesize accountState;

@synthesize mutableOrders;
@synthesize mutablePositions;
@synthesize mutableTrades;
@synthesize orderHistory;
@synthesize ruleByName;

@synthesize spreadPlanId;
@synthesize currPammCapital;
@synthesize startPammCapital;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldAccountId name: @"accountId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCurrency name: @"currency" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBalance name: @"balance" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPnl name: @"netPl" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTodayFees name: @"todayFees" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeCount name: @"tradesCount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAmount name: @"amount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCrossType name: @"crossType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCrossInstrumentId name: @"crossInstrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBid name: @"crossInstrumentBid" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAsk name: @"crossInstrumentAsk" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBlockedSum name: @"blockedBalance" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCashBalance name: @"cashBalance" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLockedForPamm name: @"blockedFunds" ]
            , [ PFMetaObjectField fieldWithId: PFFieldLockedForOrders name: @"ordersMargin" ]
            , [ PFMetaObjectField fieldWithId: PFFieldUsedMargin name: @"positionsMargin" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradingLevel name: @"tradingLevel" ]
            , [ PFMetaObjectField fieldWithId: PFFieldWarningLevel name: @"warningLevel" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMarginLevel name: @"marginLevel" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCommissionPlanId name: @"spreadPlanId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAccountState name: @"accountState" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTradeRouteList name: @"tradeRouteNames" ]
            , nil ] ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.crossType = PFCrossTypeNo;
      self.mutableOrders = [ PFOrders new ];
      self.mutablePositions = [ PFPositions new ];
      self.mutableTrades = [ PFTrades new ];
      self.orderHistory = [ PFOrderHistory new ];
      self.ruleByName = [ NSMutableDictionary new ];
      self.currPammCapital = 0;
      self.startPammCapital = 0;
   }
   return self;
}

+(id)accountWithId:( PFInteger )account_id_
{
   PFAccount* account_ = [ self new ];
   account_.accountId = account_id_;
   return account_;
}

-(PFDouble)grossPl
{
   return self.netPl + self.todayFees;
}

-(NSArray*)orders
{
   return self.mutableOrders.activeOrders;
}

-(NSArray*)allOrders
{
   return self.mutableOrders.orders;
}

-(NSArray*)positions
{
   return self.mutablePositions.positions;
}

-(NSArray*)trades
{
   return self.mutableTrades.trades;
}

-(NSArray*)operations
{
   return self.orderHistory.orders;
}

-(PFPosition*)updatePositionWithMessage:( PFMessage* )message_
{
   return [ self.mutablePositions updatePositionWithMessage: message_ delegate: self ];
}

-(void)removePosition:( PFPosition* )position_
{
   NSAssert( position_.accountId == self.accountId, @"incorrect account" );
   [ self.mutablePositions removePosition: position_ delegate: self ];
}

-(PFOrder*)updateOrderWithMessage:( PFMessage* )message_
{
   return [ self.mutableOrders updateOrderWithMessage: message_ delegate: self ];
}

-(void)updateOrder:( PFOrder* )order_
{
   return [ self.mutableOrders updateOrder: order_ delegate: self ];
}

-(PFTrade*)updateTradeWithMessage:( PFMessage* )message_
{
   return [ self.mutableTrades updateTradeWithMessage: message_ delegate: self ];
}

-(PFDouble)crossPrice
{
   if ( self.priceForCrossPrice == 0.0 )
   {
      return 1.0;
   }
   else if ( self.crossType == PFCrossTypeNo )
   {
      return self.priceForCrossPrice;
   }
   else if ( self.crossType == PFCrossTypeDirect )
   {
      return 1.0 / self.priceForCrossPrice;
   }

   return 1.0;
}

-(PFBool)allowsSLTP
{
   return [ [ self ruleForName: PFRuleFunctionSLTP ] boolValue ];
}

-(PFBool)allowsTrailingStop
{
   return [ [ self ruleForName: PFRuleFunctionTrailingStop ] boolValue ];
}

-(PFBool)allowsOCO
{
   return [ [ self ruleForName: PFRuleFunctionOCO ] boolValue ];
}

-(PFBool)allowsChat
{
   return [ [ self ruleForName: PFRuleFunctionChat ] boolValue ];
}

-(PFBool)allowsNews
{
   return [ [ self ruleForName: PFRuleFunctionNews ] boolValue ];
}

-(PFBool)allowsLevel2
{
   return [ [ self ruleForName: PFRuleFunctionLevel2 ] boolValue ];
}

-(PFBool)allowsOptions
{
   return [ [ self ruleForName: PFRuleFunctionOptions ] boolValue ];
}

-(PFBool)allowsWithdrawal
{
   return [ [ self ruleForName: PFRuleFunctionWithdrawal ] boolValue ];
}

-(PFBool)allowsEventLog
{
   return [ [ self ruleForName: PFRuleFunctionEventLog ] boolValue ];
}

-(PFBool)allowsSymbolInfo
{
   return [ [ self ruleForName: PFRuleFunctionSymbolInfo ] boolValue ];
}

-(PFBool)allowsTrading
{
    return [ [ self ruleForName: PFRuleFunctionTrading ] boolValue ];
}

-(PFBool)notAllowOpenPositions
{
    return [ [ self ruleForName: PFRuleFunctionNotAllowOpenPosition ] boolValue ];
}

-(PFBool)notAllowClosePositions
{
    return [ [ self ruleForName: PFRuleFunctionClosePositionsDisable ] boolValue ];
}

-(PFBool)notAllowShortStock
{
    return [ [ self ruleForName: PFRuleFunctionNotAllowShortStock ] boolValue ];
}

-(NSString*)baseCurrency
{
   return [ [ self ruleForName: PFRuleBaseCurrency ] value ];
}

-(PFDouble)value
{
   return self.equity + self.stockValue + self.currPammCapital + self.blockedFunds;
}

-(PFDouble)investedFundCapital
{
   NSLog(@"currPammCapital=%f blockedFunds=%f startPammCapital=%f", self.currPammCapital, self.blockedFunds, self.startPammCapital);
   return self.blockedFunds + self.startPammCapital;
}

-(PFDouble)currentFundCapital
{
   return self.currPammCapital;
}

-(PFDouble)fundCapitalGain
{
   return self.currPammCapital - self.startPammCapital;
}

-(PFDouble)equity
{
   return self.balance + self.totalGrossPl;
}

-(PFDouble)marginAvailable
{
   return ( ( self.balance + self.profitForMargin ) * self.tradingLevel / 100.0 ) - self.positionsMargin - self.ordersMargin;
}

-(PFDouble)currentMargin
{
   return self.equity == 0.0
      ? 0.0
      : ( self.ordersMargin + self.positionsMargin) * 100.0 / self.equity;
}

-(PFBool)riskFromEquity
{
   return [ [ self ruleForName: PFRuleFunctionRiskFromEquity ] boolValue ];
}

-(PFDouble)marginWarning
{
   return self.riskFromEquity
      ? self.equity * self.warningLevel / 100.0
      : (self.ordersMargin + self.positionsMargin) * 100.0 / self.warningLevel;
}

-(PFDouble)stopTrading
{
   return self.riskFromEquity
      ? self.equity * self.tradingLevel / 100.0
      : (self.ordersMargin + self.positionsMargin) * 100.0 / self.tradingLevel;
}

-(PFDouble)stopOut
{
   return self.riskFromEquity
      ? self.equity * self.marginLevel / 100.0
      : (self.ordersMargin + self.positionsMargin) * 100.0 / self.marginLevel;
}

-(PFDouble)withdrawalAvailable
{
   return fmin( self.equity - self.ordersMargin -self.positionsMargin, self.cashBalance );
}

-(id< PFRule >)ruleForName:( NSString* )name_
{
   return [ self.ruleByName objectForKey: name_ ];
}

-(void)addRule:( PFRule* )rule_
{
   NSAssert( rule_.accountId == self.accountId, @"Incorrect rule" );

   [ self.ruleByName setObject: rule_ forKey: rule_.name ];
}

-(void)connectToSymbols:( PFSymbols* )symbols_
{
   [ self.mutablePositions connectToSymbols: symbols_ ];
   [ self.mutableOrders connectToSymbols: symbols_ ];
   [ self.mutableTrades connectToSymbols: symbols_ ];
}

#pragma mark PFPositionsDelegate

-(void)openPositions:( PFPositions* )positions_
   didUpdatePosition:( PFPosition* )position_
{
   [ position_ connectToAccount: self ];
}

-(void)openPositions:( PFPositions* )positions_
   didRemovePosition:( PFPosition* )position_
{
   [ position_ disconnectFromAccount ];
}

-(void)openPositions:( PFPositions* )positions_
      didAddPosition:( PFPosition* )position_
{
   [ position_ connectToAccount: self ];
}

#pragma mark PFOrdersDelegate

-(void)orders:( PFOrders* )orders_
didUpdateOrder:( PFOrder* )order_
{
   [ self.orderHistory addOrder: order_ delegate: self ];
   [ order_ connectToAccount: self ];
}

-(void)orders:( PFOrders* )orders_
didRemoveOrder:( PFOrder* )order_
{
   [ self.orderHistory addOrder: order_ delegate: self ];
   [ order_ disconnectFromAccount ];
}

-(void)orders:( PFOrders* )orders_
  didAddOrder:( PFOrder* )order_
{
   [ self.orderHistory addOrder: order_ delegate: self ];
   [ order_ connectToAccount: self ];
}

#pragma mark PFTradesDelegate

-(void)trades:( PFTrades* )trades_
  didAddTrade:( PFTrade* )trade_
{
   [ trade_ connectToAccount: self ];
}

#pragma mark PFOrderHistory

-(void)orderHistory:( PFOrderHistory* )history_
        didAddOrder:( PFOrder* )order_
{
}

#pragma mark PFQuoteDependence

-(NSString*)dependenceIdentifier
{
   return [ NSString stringWithFormat: @"account_%d", self.accountId ];
}

@end
