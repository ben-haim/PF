//
//  PFOrdersInfo.m
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFFilledOrdersInfoView.h"
#import "UIView+LoadFromNib.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"
#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "PFSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import "PFOrderTypeConversion.h"
#import "PFOrderStatusConversion.h"
#import "PFOrderValidityTypeConversion.h"
#import "PFInstrumentTypeConversion.h"

#import <JFFMessageBox/JFFMessageBox.h>
#import "PFModifyOrderViewController.h"

#import "PFMarketCalculations.h"

@interface PFFilledOrdersInfoView ()

@property ( nonatomic, strong ) id< PFTrade > currentTrade;

@end

@implementation PFFilledOrdersInfoView

@synthesize currentTrade;

@synthesize sideLabel;
@synthesize dateTimeLabel;
@synthesize orderTypeLabel;
@synthesize orderIdLabel;
@synthesize tradeIdLabel;
@synthesize exposureLabel;
@synthesize boughtLabel;
@synthesize soldLabel;
@synthesize accountLabel;
@synthesize symbolTypeLabel;

@synthesize sideValueLabel;
@synthesize dateTimeValueLabel;
@synthesize orderTypeValueLabel;
@synthesize orderIdValueLabel;
@synthesize tradeIdValueLabel;
@synthesize exposureValueLabel;
@synthesize boughtValueLabel;
@synthesize soldValueLabel;
@synthesize accountValueLabel;
@synthesize symbolTypeValueLabel;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.sideLabel.textColor = [UIColor mainTextColor];
   self.dateTimeLabel.textColor = [UIColor mainTextColor];
   self.orderTypeLabel.textColor = [UIColor mainTextColor];
   self.orderIdLabel.textColor = [UIColor mainTextColor];
   self.tradeIdLabel.textColor = [UIColor mainTextColor];
   self.exposureLabel.textColor = [UIColor mainTextColor];
   self.boughtLabel.textColor = [UIColor mainTextColor];
   self.soldLabel.textColor = [UIColor mainTextColor];
   self.accountLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeLabel.textColor = [UIColor mainTextColor];

   self.sideValueLabel.textColor = [UIColor grayTextColor];
   self.dateTimeValueLabel.textColor = [UIColor grayTextColor];
   self.orderTypeValueLabel.textColor = [UIColor grayTextColor];
   self.orderIdValueLabel.textColor = [UIColor grayTextColor];
   self.tradeIdValueLabel.textColor = [UIColor grayTextColor];
   self.exposureValueLabel.textColor = [UIColor grayTextColor];
   self.boughtValueLabel.textColor = [UIColor grayTextColor];
   self.soldValueLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.symbolTypeValueLabel.textColor = [UIColor grayTextColor];

   self.sideLabel.text = NSLocalizedString( @"SIDE", nil );
   self.dateTimeLabel.text = NSLocalizedString( @"OPEN_TIME", nil );
   self.orderTypeLabel.text = NSLocalizedString( @"ORDER_TYPE", nil );
   self.orderIdLabel.text = NSLocalizedString( @"ORDER_ID", nil );
   self.exposureLabel.text = NSLocalizedString( @"ORDER_EXPOSURE", nil );
   self.tradeIdLabel.text = NSLocalizedString( @"TRADE_ID", nil );
   self.boughtLabel.text = NSLocalizedString( @"BOUGHT", nil );
   self.soldLabel.text = NSLocalizedString( @"SOLD", nil );
   self.accountLabel.text = NSLocalizedString( @"ACCOUNT", nil );
   self.symbolTypeLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );

   self.sideValueLabel.text = @"-";
   self.dateTimeValueLabel.text = @"-";
   self.orderTypeValueLabel.text = @"-";
   self.orderIdValueLabel.text = @"-";
   self.tradeIdValueLabel.text = @"-";
   self.exposureValueLabel.text = @"-";
   self.boughtValueLabel.text = @"-";
   self.soldValueLabel.text = @"-";
   self.accountValueLabel.text = @"-";
   self.symbolTypeValueLabel.text = @"-";
}

+(id)filledOrdersInfoViewWithTrade:( id< PFTrade > )trade_
{
   PFFilledOrdersInfoView* trade_info_view_ = [ UIView viewAsFirstObjectFromNibNamed: @"PFFilledOrdersInfoView" ];
   trade_info_view_.currentTrade = trade_;

   return trade_info_view_;
}

#pragma mark - PFChartInfoView Protocol

-(void)updateDataByTimer
{
   self.sideValueLabel.text = [ PFMarketCalculations getSideWithMarketOperation: self.currentTrade ];
   self.dateTimeValueLabel.text = [ self.currentTrade.createdAt shortTimestampString ];
   self.orderTypeValueLabel.text = NSStringOrderTypeFromOperation(self.currentTrade);
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", self.currentTrade.orderId ];
   self.tradeIdValueLabel.text = [ NSString stringWithFormat: @"%d", self.currentTrade.tradeId ];
   self.accountValueLabel.text = self.currentTrade.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( self.currentTrade.symbol.instrument.type );
   self.exposureValueLabel.text = [ NSString stringWithMoney: self.currentTrade.exposure ];
   self.boughtValueLabel.text = [ PFMarketCalculations getBoughtWithTrade: self.currentTrade ];
   self.soldValueLabel.text = [ PFMarketCalculations getSoldWithTrade: self.currentTrade ];

   self.accountValueLabel.text = self.currentTrade.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( self.currentTrade.symbol.instrument.type );
}

@end
