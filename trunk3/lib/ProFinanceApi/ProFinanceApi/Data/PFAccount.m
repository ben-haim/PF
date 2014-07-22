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

#import "PFAssetAccount.h"
#import "PFAssetType.h"

#import "PFMetaObject.h"
#import "PFField.h"
#import "PFMessage.h"

@interface PFAccount ()< PFPositionsDelegate, PFOrdersDelegate, PFTradesDelegate, PFOrderHistoryDelegate >

@property ( nonatomic, strong ) PFOrders* mutableOrders;
@property ( nonatomic, strong ) PFPositions* mutablePositions;
@property ( nonatomic, strong ) PFTrades* mutableTrades;
@property ( nonatomic, strong ) PFOrderHistory* orderHistory;
@property ( nonatomic, strong ) NSMutableDictionary* mutableAssetAccounts;

@end

@implementation PFAccount

@synthesize crossType;
@synthesize crossInstrumentBid;

@synthesize accountId;
@synthesize name;
@synthesize tradingLevel;
@synthesize warningLevel;
@synthesize marginLevel;
@synthesize tradeRouteNames;

@synthesize leverage;
@synthesize type;
@synthesize userId;
@synthesize groupId;
@synthesize accountType;

@synthesize profitForMargin;
@synthesize stockValue;
@synthesize accountState;
@synthesize allowsOvernightTrading;

@synthesize mutableOrders;
@synthesize mutablePositions;
@synthesize mutableTrades;
@synthesize orderHistory;
@synthesize ruleByName;

@synthesize commissionPlanId;
@synthesize spreadPlanId;

@synthesize currentFundCapital;
@synthesize startPammCapital;

@synthesize mutableAssetAccounts;
@synthesize currAssetAccount;
@synthesize assetAccounts;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:
            [ PFMetaObjectField fieldWithId: PFFieldBid name: @"crossInstrumentBid" ],
            [ PFMetaObjectField fieldWithId: PFFieldCrossType name: @"crossType" ],
            [ PFMetaObjectField fieldWithId: PFFieldAllowOverhightTrading name: @"allowsOvernightTrading" ],
            [ PFMetaObjectField fieldWithId: PFFieldAccountId name: @"accountId" ],
            [ PFMetaObjectField fieldWithId: PFFieldName name: @"name" ],
            [ PFMetaObjectField fieldWithId: PFFieldTradingLevel name: @"tradingLevel" ],
            [ PFMetaObjectField fieldWithId: PFFieldWarningLevel name: @"warningLevel" ],
            [ PFMetaObjectField fieldWithId: PFFieldMarginLevel name: @"marginLevel" ],
            [ PFMetaObjectField fieldWithId: PFFieldCommissionPlanId name: @"commissionPlanId" ],
            [ PFMetaObjectField fieldWithId: PFFieldSpreadPlanId name: @"spreadPlanId" ],
            [ PFMetaObjectField fieldWithId: PFFieldAccountState name: @"accountState" ],
            [ PFMetaObjectField fieldWithId: PFFieldTradeRouteList name: @"tradeRouteNames" ],
            
            [ PFMetaObjectField fieldWithId: PFFieldLeverage name: @"leverage" ],
            [ PFMetaObjectField fieldWithId: PFFieldType name: @"type" ],
            [ PFMetaObjectField fieldWithId: PFFieldUserId name: @"userId" ],
            [ PFMetaObjectField fieldWithId: PFFieldGroupId name: @"groupId" ],
            [ PFMetaObjectField fieldWithId: PFFieldAccountType name: @"accountType" ],
            nil ] ];
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
      self.mutableAssetAccounts = [NSMutableDictionary new];
   }
   return self;
}
    
-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
    NSArray* asset_accaunt_groups_ = [field_owner_ groupFieldsWithId: PFGroupAssetAccount ];

    for (PFGroupField* asset_account_group_ in asset_accaunt_groups_) 
    {
        int asset_id_ = [(PFIntegerField*)[asset_account_group_ fieldWithId: PFFieldAssetId] integerValue];
        PFAssetAccount* current_asset_account_ = [ self.mutableAssetAccounts objectForKey: @(asset_id_) ];
        
        if ( !current_asset_account_ )
        {
            current_asset_account_ = [PFAssetAccount new];
            current_asset_account_.assetId = asset_id_;

            [ self.mutableAssetAccounts setObject: current_asset_account_ forKey: @(asset_id_) ];
        }
        
        [ current_asset_account_ readFromFieldOwner: asset_account_group_.fieldOwner ];
    }
}

-(void)setCurrAssetAccountFromId: (PFInteger)asset_id_
{
    self.currAssetAccount = [ self.mutableAssetAccounts objectForKey: @(asset_id_) ];
}

-(void)setCurrAssetAccountFromAccount: (id< PFAccount >)account_
{
    [self setCurrAssetAccountFromId: account_.currAssetAccount.assetId];
}

-(NSArray *)assetAccounts
{
    return self.mutableAssetAccounts.allValues;
}

-(NSArray *)sortedAssetAccounts
{
    return [self.mutableAssetAccounts.allValues sortedArrayUsingComparator:
            ^(PFAssetAccount* v1, PFAssetAccount* v2) { return [v1.currency compare: v2.currency]; } ];
}

+(id)accountWithId:( PFInteger )account_id_
{
   PFAccount* account_ = [ self new ];
   account_.accountId = account_id_;
   return account_;
}

-(PFDouble)netPl
{
    return self.currAssetAccount.dailyPnL;
}

-(PFInteger)tradesCount
{
    return self.currAssetAccount.tradesCount;
}

-(PFDouble)todayFees
{
    return self.currAssetAccount.todayFee;
}

-(PFDouble)balance
{
    return self.currAssetAccount.balance;
}

-(NSString*)currency
{
    return self.currAssetAccount.currency;
}

-(PFDouble)positionValue
{
    return self.currAssetAccount.positionValue;
}

-(PFDouble)initMargin
{
    return self.currAssetAccount.initMargin;
}

-(PFDouble)cashBalance
{
    return self.currAssetAccount.casheBalance;
}

-(PFDouble)deficiencyMargin
{
    return self.currAssetAccount.deficiencyMargin;
}

-(PFDouble)availableMargin
{
    return self.currAssetAccount.availableMargin;
}

-(PFDouble)maintanceMargin
{
    return self.currAssetAccount.maintanceMargin;
}

-(PFDouble)blockedForOrders
{
    return self.currAssetAccount.blockedForOrders;
}

-(PFDouble)amount
{
    return self.currAssetAccount.tradeAmount;
}

-(PFDouble)blockedSum
{
    return self.currAssetAccount.blockedSum;
}

-(PFDouble)blockedFunds
{
    return self.currAssetAccount.blockedFunds;
}

-(PFDouble)grossPl
{
    return self.currAssetAccount.dailyGrossPL;
}

-(PFDouble)totalGrossPl
{
    return self.currAssetAccount.grossPL;
}

-(PFDouble)totalNetPl
{
    return self.currAssetAccount.netPL;
}

-(PFDouble)precision
{
    return self.currAssetAccount.precision;
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

-(int)positionSum
{
    return self.currAssetAccount.positionSum;
}

-(int)orderSum
{
    return self.currAssetAccount.orderSum;
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
   if ( self.crossInstrumentBid == 0.0 )
   {
      return 1.0;
   }
   else if ( self.crossType == PFCrossTypeNo )
   {
      return self.crossInstrumentBid;
   }
   else if ( self.crossType == PFCrossTypeDirect )
   {
      return 1.0 / self.crossInstrumentBid;
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

-(PFBool)allowTransfer
{
    return [ [ self ruleForName: PFRuleTransfer ] boolValue ];
}

-(PFBool)allowInstrument: (id< PFInstrument >)instrument_
{
    return ((instrument_.deliveryMethodId == PFDeliveryMethodPhysicaly) && (self.accountType == PFAccountTypeMultiAsset)) ||
           ((instrument_.deliveryMethodId == PFDeliveryMethodCash)      && (self.accountType != PFAccountTypeMultiAsset));
}

-(PFBool)marginMode
{
    return [ [ self ruleForName: PFRuleMarginMode ] boolValue ];
}

-(PFBool)riskFromEquity
{
    return [ [ self ruleForName: PFRuleFunctionRiskFromEquity ] boolValue ];
}

-(NSString*)baseCurrency
{
   return [ [ self ruleForName: PFRuleBaseCurrency ] value ];
}

-(PFDouble)equity
{
    return self.currAssetAccount.accountEquity;
}

-(PFDouble)value
{
    return self.currAssetAccount.accountValue;
}

-(PFDouble)investedFundCapital
{
    return self.currAssetAccount.investedFundCapital;
}

-(PFDouble)fundCapitalGain
{
    return self.currAssetAccount.fundCapitalGain;
}

-(PFDouble)marginAvailable
{
    return self.currAssetAccount.marginAvaiable;
}

-(PFDouble)currentMargin
{
   return self.equity == 0.0
      ? 0.0
      : ( self.blockedForOrders + self.initMargin) * 100.0 / self.equity;
}

-(PFDouble)usedMargin
{
    return self.currAssetAccount.usedMargin;
}

-(PFDouble)marginWarning
{
    return self.currAssetAccount.marginWarning;
}

-(PFDouble)stopTrading
{
   return self.riskFromEquity
      ? self.equity * self.tradingLevel / 100.0
    : (self.blockedForOrders + self.initMargin) * 100.0 / self.tradingLevel;
}

-(PFDouble)stopOut
{
   return self.riskFromEquity
      ? self.equity * self.marginLevel / 100.0
    : (self.blockedForOrders + self.initMargin) * 100.0 / self.marginLevel;
}

-(PFDouble)withdrawalAvailable
{
    return self.currAssetAccount.withDrawalAvaiable;
}

-(id< PFRule >)ruleForName:( NSString* )name_
{
   // NSLog(@"%@",[ self.ruleByName objectForKey: name_ ]);
    return [ self.ruleByName objectForKey: name_ ];
}

-(void)addRule:( PFRule* )rule_
{
  // NSAssert( rule_.accountId == self.accountId, @"Incorrect rule" );
    [ self.ruleByName setObject: rule_ forKey: rule_.name ];
}
-(void)removeRule:( PFRule* )rule_
{
    //NSAssert( rule_.accountId == self.accountId, @"Incorrect rule" );
    
    [ self.ruleByName removeObjectForKey: rule_.name ];
}
-(PFRule* )getRule:( NSString* )ruleName andAccountId:(int)accId;
{
   //  NSAssert( accId== self.accountId, @"Incorrect rule" );
    return  [ self.ruleByName objectForKey: ruleName ];
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
