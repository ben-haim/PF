//
//  PFAssetAccount.m
//  ProFinanceApi
//
//  Created by VitaliyK on 11.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFAssetAccount.h"
#import "PFAssetType.h"
#import "PFAccount.h"

#import "PFMetaObject.h"
#import "PFField.h"
#import "PFMessage.h"

@implementation PFAssetAccount

@synthesize assetId;
@synthesize balance;
@synthesize blockedSum;
@synthesize blockedForOrders;
@synthesize blockedFunds;
@synthesize availableMargin;
@synthesize maintanceMargin;
@synthesize deficiencyMargin;
@synthesize surplusMargin;
@synthesize beginBalance;
@synthesize dailyPnL;
@synthesize todayFee;
@synthesize creditBalance;
@synthesize casheBalance;
@synthesize reservedBalance;
@synthesize initMargin;
@synthesize tradesCount;
@synthesize tradeAmount;

// calculable variables
@synthesize orderSum;
@synthesize positionSum;
@synthesize positionValue;
@synthesize grossPL;
@synthesize netPL;
@synthesize balancePlusAllRisks;
@synthesize marginAvaiable;
@synthesize stopTrading;
@synthesize stopOut;
@synthesize withDrawalAvaiable;
@synthesize stocksValue;
@synthesize usedMargin;

@synthesize accountEquity;
@synthesize accountValue;
@synthesize fundCapitalGain;
@synthesize currentFundCapital;
@synthesize startFundCapital;
@synthesize investedFundCapital;
@synthesize dailyGrossPL;
@synthesize marginWarning;
@synthesize assetType = _assetType;
@synthesize precision;
@synthesize currency;

-(void)recalculateValues: (PFAccount*) account_ 
{
    self.accountEquity = balance + grossPL;
    self.accountValue = positionValue + availableMargin + currentFundCapital + blockedFunds;
    self.fundCapitalGain = currentFundCapital - startFundCapital;
    self.investedFundCapital = blockedFunds + startFundCapital;
    self.dailyGrossPL = dailyPnL + todayFee;
    self.marginWarning = (balance - maintanceMargin - blockedForOrders) * (1 - account_.warningLevel / 100.0);
    self.usedMargin = blockedForOrders + initMargin + deficiencyMargin;
    self.balancePlusAllRisks = balance + ((grossPL < 0 || account_.marginMode) ? grossPL : 0);
    self.marginAvaiable = balancePlusAllRisks - maintanceMargin - blockedForOrders;
}

+(PFMetaObject*)metaObject
{
    return [ PFMetaObject metaObjectWithFields:
            @[[ PFMetaObjectField fieldWithId: PFFieldBalance name: @"balance" ],
             [ PFMetaObjectField fieldWithId: PFFieldBlockedSum name: @"blockedSum" ],
             [ PFMetaObjectField fieldWithId: PFFieldLockedForOrders name: @"blockedForOrders" ],
             [ PFMetaObjectField fieldWithId: PFFieldLockedForPamm name: @"blockedFunds" ],
             [ PFMetaObjectField fieldWithId: PFFieldAvailableMargin name: @"availableMargin" ],
             [ PFMetaObjectField fieldWithId: PFFieldMaintanceMargin name: @"maintanceMargin" ],
             [ PFMetaObjectField fieldWithId: PFFieldDeficiencyMargin name: @"deficiencyMargin" ],
             [ PFMetaObjectField fieldWithId: PFFieldSurplusMargin name: @"surplusMargin" ],
             [ PFMetaObjectField fieldWithId: PFFieldBeginBalance name: @"beginBalance" ],
             [ PFMetaObjectField fieldWithId: PFFieldPnl name: @"dailyPnL" ],
             [ PFMetaObjectField fieldWithId: PFFieldTodayFees name: @"todayFee" ],
             [ PFMetaObjectField fieldWithId: PFFieldCreditValue name: @"creditBalance" ],
             [ PFMetaObjectField fieldWithId: PFFieldCashBalance name: @"casheBalance" ],
             [ PFMetaObjectField fieldWithId: PFFieldReservedBalance name: @"reservedBalance" ],
             [ PFMetaObjectField fieldWithId: PFFieldUsedMargin name: @"initMargin" ],
             [ PFMetaObjectField fieldWithId: PFFieldTradeCount name: @"tradesCount" ],
             [ PFMetaObjectField fieldWithId: PFFieldAmount name: @"tradeAmount" ]] ];
}

-(NSString*)currency
{
    return self.assetType.name;
}

-(void)setAssetType:(PFAssetType *)assetType
{
    self.precision = 2;

    if (assetType)
    {
        _assetType = assetType;

        if (assetType.minChange != 0.0)
        {
            int symbol_precision_ = -log10( assetType.minChange );

            if (symbol_precision_ > 1)
                self.precision = symbol_precision_;
        }
    }
}

@end
