//
//  PFOrdersInfo.m
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFAllOrdersInfoView.h"
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

@interface PFAllOrdersInfoView ()

@property ( nonatomic, strong ) id< PFMarketOperation > currentMarketOperation;

@end

@implementation PFAllOrdersInfoView

@synthesize currentMarketOperation;

@synthesize sideLabel;
@synthesize dateTimeLabel;
@synthesize tifLabel;
@synthesize orderIdLabel;
@synthesize boughtLabel;
@synthesize soldLabel;
@synthesize accountLabel;
@synthesize symbolTypeLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;

@synthesize sideValueLabel;
@synthesize dateTimeValueLabel;
@synthesize tifValueLabel;
@synthesize orderIdValueLabel;
@synthesize boughtValueLabel;
@synthesize soldValueLabel;
@synthesize accountValueLabel;
@synthesize symbolTypeValueLabel;
@synthesize quantityOpenPriceValueLabel;
@synthesize typeValueLabel;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.sideLabel.textColor = [UIColor mainTextColor];
   self.dateTimeLabel.textColor = [UIColor mainTextColor];
   self.tifLabel.textColor = [UIColor mainTextColor];
   self.orderIdLabel.textColor = [UIColor mainTextColor];
   self.boughtLabel.textColor = [UIColor mainTextColor];
   self.soldLabel.textColor = [UIColor mainTextColor];
   self.accountLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeLabel.textColor = [UIColor mainTextColor];
   self.quantityOpenPriceLabel.textColor = [UIColor mainTextColor];
   self.typeLabel.textColor = [UIColor mainTextColor];

   self.sideValueLabel.textColor = [UIColor grayTextColor];
   self.dateTimeValueLabel.textColor = [UIColor grayTextColor];
   self.tifValueLabel.textColor = [UIColor grayTextColor];
   self.orderIdValueLabel.textColor = [UIColor grayTextColor];
   self.boughtValueLabel.textColor = [UIColor grayTextColor];
   self.soldValueLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.symbolTypeValueLabel.textColor = [UIColor grayTextColor];
   self.quantityOpenPriceValueLabel.textColor = [UIColor grayTextColor];;
   self.typeValueLabel.textColor = [UIColor grayTextColor];;

   self.sideLabel.text = NSLocalizedString( @"SIDE", nil );
   self.dateTimeLabel.text = NSLocalizedString( @"OPEN_TIME", nil );
   self.tifLabel.text = NSLocalizedString( @"TIF", nil );
   self.orderIdLabel.text = NSLocalizedString( @"ORDER_ID", nil );
   self.boughtLabel.text = NSLocalizedString( @"BOUGHT", nil );
   self.soldLabel.text = NSLocalizedString( @"SOLD", nil );
   self.accountLabel.text = NSLocalizedString( @"ACCOUNT", nil );
   self.symbolTypeLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [PFSettings sharedSettings].showQuantityInLots ?
                                       NSLocalizedString( @"LOTS", nil ) : NSLocalizedString( @"QUANTITY", nil ), NSLocalizedString( @"Price", nil ) ] ;

   self.typeLabel.text = NSLocalizedString( @"TYPE", nil );

   self.sideValueLabel.text = @"-";
   self.dateTimeValueLabel.text = @"-";
   self.tifValueLabel.text = @"-";
   self.orderIdValueLabel.text = @"-";
   self.boughtValueLabel.text = @"-";
   self.soldValueLabel.text = @"-";
   self.accountValueLabel.text = @"-";
   self.symbolTypeValueLabel.text = @"-";
   self.quantityOpenPriceValueLabel.text = @"-";
   self.typeValueLabel.text = @"-";
}

+(id)marketOperationsInfoViewWithMarketOperation:( id< PFMarketOperation > )market_operation_
{
   PFAllOrdersInfoView* order_info_view_ = [ UIView viewAsFirstObjectFromNibNamed: @"PFAllOrdersInfoView" ];
   order_info_view_.currentMarketOperation = market_operation_;

   return order_info_view_;
}

#pragma mark - PFChartInfoView Protocol

-(void)updateDataByTimer
{
   PFOrder* operation_ = (PFOrder*)self.currentMarketOperation;

   // Content
   self.sideValueLabel.text = [ PFMarketCalculations getSideWithMarketOperation: operation_ ];
   self.dateTimeValueLabel.text = [ operation_.createdAt shortTimestampString ];
   self.tifValueLabel.text = (operation_.validity == PFOrderValidityGtd) ? [ operation_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( operation_.validity );
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", operation_.orderId ];
   self.boughtValueLabel.text = [ PFMarketCalculations getBoughtWithOrder: operation_ ];
   self.soldValueLabel.text = [ PFMarketCalculations getSoldWithOrder: operation_ ];
   self.accountValueLabel.text = operation_.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( operation_.symbol.instrument.type );

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
   operation_.amount :
   operation_.amount * operation_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [PFSettings sharedSettings].showQuantityInLots ?
                                       NSLocalizedString( @"LOTS", nil ) : NSLocalizedString( @"QUANTITY", nil ), NSLocalizedString( @"Price", nil ) ] ;

   self.quantityOpenPriceValueLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: operation_.price symbol: operation_.symbol ] ];

   self.typeValueLabel.text = NSStringOrderTypeFromOperation( operation_ );
}

@end
