//
//  PFAssetAccount.h
//  ProFinanceApi
//
//  Created by VitaliyK on 11.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "../PFTypes.h"
#import "Detail/PFObject.h"

@class PFAssetType;
@class PFAccount;

@protocol PFAssetAccount < NSObject >

-(PFInteger) assetId;
-(PFDouble) balance;
-(PFDouble) blockedSum;
-(PFDouble) blockedForOrders;
-(PFDouble) blockedFunds;
-(PFDouble) initMargin;
-(PFDouble) availableMargin;
-(PFDouble) maintanceMargin;
-(PFDouble) deficiencyMargin;
-(PFDouble) surplusMargin;
-(PFDouble) beginBalance;
-(PFDouble) dailyPnL;
-(PFDouble) todayFee;
-(PFDouble) creditBalance;
-(PFDouble) casheBalance;
-(PFDouble) reservedBalance;
-(PFInteger) tradesCount;
-(PFDouble) tradeAmount;

// calculable variables
-(NSString*) currency;
-(PFInteger) orderSum;
-(PFInteger) positionSum;
-(PFDouble) positionValue;
-(PFDouble) grossPL;
-(PFDouble) netPL;
-(PFDouble) balancePlusAllRisks;
-(PFDouble) marginAvaiable;
-(PFDouble) stopTrading;
-(PFDouble) stopOut;
-(PFDouble) withDrawalAvaiable;
-(PFDouble) stocksValue;

-(PFDouble) accountEquity;
-(PFDouble) accountValue;
-(PFDouble) fundCapitalGain;
-(PFDouble) currentFundCapital;
-(PFDouble) startFundCapital;
-(PFDouble) investedFundCapital;
-(PFDouble) dailyGrossPL;
-(PFDouble) marginWarning;
-(PFAssetType*) assetType;
-(NSUInteger) precision;
-(PFDouble) usedMargin;

@end

@interface PFAssetAccount : PFObject < PFAssetAccount >

@property (nonatomic, assign) PFInteger assetId;
@property (nonatomic, assign) PFDouble balance;
@property (nonatomic, assign) PFDouble blockedSum;
@property (nonatomic, assign) PFDouble blockedForOrders;
@property (nonatomic, assign) PFDouble blockedFunds;
@property (nonatomic, assign) PFDouble initMargin;
@property (nonatomic, assign) PFDouble availableMargin;
@property (nonatomic, assign) PFDouble maintanceMargin;
@property (nonatomic, assign) PFDouble deficiencyMargin;
@property (nonatomic, assign) PFDouble surplusMargin;
@property (nonatomic, assign) PFDouble beginBalance;
@property (nonatomic, assign) PFDouble dailyPnL;
@property (nonatomic, assign) PFDouble todayFee;
@property (nonatomic, assign) PFDouble creditBalance;
@property (nonatomic, assign) PFDouble casheBalance;
@property (nonatomic, assign) PFDouble reservedBalance;
@property (nonatomic, assign) PFInteger tradesCount;
@property (nonatomic, assign) PFDouble tradeAmount;

// calculable variables
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, assign) PFInteger orderSum;
@property (nonatomic, assign) PFInteger positionSum;
@property (nonatomic, assign) PFDouble positionValue;
@property (nonatomic, assign) PFDouble grossPL;
@property (nonatomic, assign) PFDouble netPL;
@property (nonatomic, assign) PFDouble balancePlusAllRisks;
@property (nonatomic, assign) PFDouble marginAvaiable;
@property (nonatomic, assign) PFDouble stopTrading;
@property (nonatomic, assign) PFDouble stopOut;
@property (nonatomic, assign) PFDouble withDrawalAvaiable;
@property (nonatomic, assign) PFDouble stocksValue;

@property (nonatomic, assign) PFDouble accountEquity;
@property (nonatomic, assign) PFDouble accountValue;
@property (nonatomic, assign) PFDouble fundCapitalGain;
@property (nonatomic, assign) PFDouble currentFundCapital;
@property (nonatomic, assign) PFDouble startFundCapital;
@property (nonatomic, assign) PFDouble investedFundCapital;
@property (nonatomic, assign) PFDouble dailyGrossPL;
@property (nonatomic, assign) PFDouble marginWarning;
@property (nonatomic, strong) PFAssetType* assetType;
@property (nonatomic, assign) NSUInteger precision;
@property (nonatomic, assign) PFDouble usedMargin;

-(void)recalculateValues: (PFAccount*) account_;

@end
