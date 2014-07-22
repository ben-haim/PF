//
//  PFOrdersInfo.m
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFActiveOrdersInfoView.h"
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

@interface PFActiveOrdersInfoView ()

@property ( nonatomic, strong ) id< PFOrder > currentOrder;

@end

@implementation PFActiveOrdersInfoView

@synthesize currentOrder;

@synthesize sideLabel;
@synthesize currentPriceLabel;
@synthesize dateTimeLabel;
@synthesize stopPriceLabel;
@synthesize tifLabel;
@synthesize orderIdLabel;
@synthesize stopLossLabel;
@synthesize takeprofitLabel;
@synthesize qtyFilledLabel;
@synthesize qtyRemainingLabel;
@synthesize expirationDateLabel;
@synthesize initialReqLabel;
@synthesize accountLabel;
@synthesize symbolTypeLabel;

@synthesize sideValueLabel;
@synthesize currentPriceValueLabel;
@synthesize dateTimeValueLabel;
@synthesize stopPriceValueLabel;
@synthesize tifValueLabel;
@synthesize orderIdValueLabel;
@synthesize stopLossValueLabel;
@synthesize takeprofitValueLabel;
@synthesize qtyFilledValueLabel;
@synthesize qtyRemainingValueLabel;
@synthesize expirationDateValueLabel;
@synthesize initialReqValueLabel;
@synthesize accountValueLabel;
@synthesize symbolTypeValueLabel;

@synthesize cancelButton;
@synthesize modifyButton;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.sideLabel.textColor = [UIColor mainTextColor];
   self.currentPriceLabel.textColor = [UIColor mainTextColor];
   self.dateTimeLabel.textColor = [UIColor mainTextColor];
   self.stopPriceLabel.textColor = [UIColor mainTextColor];
   self.tifLabel.textColor = [UIColor mainTextColor];
   self.orderIdLabel.textColor = [UIColor mainTextColor];
   self.stopLossLabel.textColor = [UIColor mainTextColor];
   self.takeprofitLabel.textColor = [UIColor mainTextColor];
   self.qtyFilledLabel.textColor = [UIColor mainTextColor];
   self.qtyRemainingLabel.textColor = [UIColor mainTextColor];
   self.expirationDateLabel.textColor = [UIColor mainTextColor];
   self.initialReqLabel.textColor = [UIColor mainTextColor];
   self.accountLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeLabel.textColor = [UIColor mainTextColor];

   self.sideValueLabel.textColor = [UIColor grayTextColor];
   self.currentPriceValueLabel.textColor = [UIColor grayTextColor];
   self.dateTimeValueLabel.textColor = [UIColor grayTextColor];
   self.stopPriceValueLabel.textColor = [UIColor grayTextColor];
   self.tifValueLabel.textColor = [UIColor grayTextColor];
   self.orderIdValueLabel.textColor = [UIColor grayTextColor];
   self.stopLossValueLabel.textColor = [UIColor grayTextColor];
   self.takeprofitValueLabel.textColor = [UIColor grayTextColor];
   self.qtyFilledValueLabel.textColor = [UIColor grayTextColor];
   self.qtyRemainingValueLabel.textColor = [UIColor grayTextColor];
   self.expirationDateValueLabel.textColor = [UIColor grayTextColor];
   self.initialReqValueLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.symbolTypeValueLabel.textColor = [UIColor grayTextColor];

   [ self.modifyButton setTitle: NSLocalizedString( @"MODIFY_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.cancelButton setTitle: NSLocalizedString( @"CANCEL_BUTTON", nil ) forState: UIControlStateNormal ];

   self.sideLabel.text = NSLocalizedString( @"SIDE", nil );
   self.currentPriceLabel.text = NSLocalizedString( @"CURRENT_PRICE", nil );
   self.dateTimeLabel.text = NSLocalizedString( @"OPEN_TIME", nil );
   self.stopPriceLabel.text = NSLocalizedString( @"STOP_PRICE", nil );
   self.tifLabel.text = NSLocalizedString( @"TIF", nil );
   self.orderIdLabel.text = NSLocalizedString( @"ORDER_ID", nil );
   self.stopLossLabel.text = NSLocalizedString( @"SL", nil );
   self.takeprofitLabel.text = NSLocalizedString( @"TP", nil );
   self.qtyFilledLabel.text = NSLocalizedString( @"ORDER_FILLED_QTY", nil );
   self.qtyRemainingLabel.text = NSLocalizedString( @"ORDER_REMAINING_QTY", nil );
   self.expirationDateLabel.text = NSLocalizedString( @"EXPIRATION_DATE", nil );
   self.initialReqLabel.text = NSLocalizedString( @"ORDER_INITIAL_REQ", nil );
   self.accountLabel.text = NSLocalizedString( @"ACCOUNT", nil );
   self.symbolTypeLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );

   self.sideValueLabel.text = @"-";
   self.currentPriceValueLabel.text = @"-";
   self.dateTimeValueLabel.text = @"-";
   self.stopPriceValueLabel.text = @"-";
   self.tifValueLabel.text = @"-";
   self.orderIdValueLabel.text = @"-";
   self.stopLossValueLabel.text = @"-";
   self.takeprofitValueLabel.text = @"-";
   self.qtyFilledValueLabel.text = @"-";
   self.qtyRemainingValueLabel.text = @"-";
   self.expirationDateValueLabel.text = @"-";
   self.initialReqValueLabel.text = @"-";
   self.accountValueLabel.text = @"-";
   self.symbolTypeValueLabel.text = @"-";
}

+(id)activeOrdersInfoViewWithOrder:(id<PFOrder>)order_
{
   PFActiveOrdersInfoView* order_info_view_ = [ UIView viewAsFirstObjectFromNibNamed: @"PFActiveOrdersInfoView" ];
   order_info_view_.currentOrder = order_;

   return order_info_view_;
}

#pragma mark - PFChartInfoView Protocol

-(void)updateDataByTimer
{
   // Content
   self.tifValueLabel.text = (self.currentOrder.validity == PFOrderValidityGtd) ? [ self.currentOrder.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( self.currentOrder.validity );
   self.sideValueLabel.text = [PFMarketCalculations getSideWithMarketOperation: self.currentOrder];
   self.accountValueLabel.text = self.currentOrder.account.name;
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", self.currentOrder.orderId ];
   self.dateTimeValueLabel.text = [ self.currentOrder.createdAt shortTimestampString ];
   self.stopPriceValueLabel.text = [ NSString stringWithPrice: self.currentOrder.stopPrice symbol: self.currentOrder.symbol ];
   self.takeprofitValueLabel.text = [ NSString stringWithPrice: self.currentOrder.takeProfitPrice symbol: self.currentOrder.symbol ];
   self.initialReqValueLabel.text = [ NSString stringWithMoney: self.currentOrder.initMargin andPrecision: self.currentOrder.account.precision ];
   self.symbolTypeValueLabel.text = NSStringForAssetClass( self.currentOrder.symbol.instrument.type );
   self.expirationDateValueLabel.text = self.currentOrder.expirationDate ? [ self.currentOrder.expirationDate shortTimestampString ] : @"-";

   self.qtyFilledValueLabel.text = [ NSString stringWithAmount: self.currentOrder.filledAmount *
                                    ([PFSettings sharedSettings].showQuantityInLots ? 1 : self.currentOrder.symbol.lotSize) ];

   self.qtyRemainingValueLabel.text = [ NSString stringWithAmount: (self.currentOrder.amount-self.currentOrder.filledAmount) *
                                       ([PFSettings sharedSettings].showQuantityInLots ? 1 : self.currentOrder.symbol.lotSize) ];

   self.currentPriceValueLabel.text = [ NSString stringWithPrice: (self.currentOrder.operationType == PFMarketOperationBuy) ? self.currentOrder.symbol.quote.bid : self.currentOrder.symbol.quote.ask
                                                          symbol: self.currentOrder.symbol ];

   NSString* price_string_ = [ NSString stringWithPrice: self.currentOrder.stopLossPrice symbol: self.currentOrder.symbol ];
   self.stopLossValueLabel.text = (self.currentOrder.stopLossOrder.orderType == PFOrderTrailingStop) ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;

   // Buttons
}

-(IBAction)modyfiButtonAction:( id )sender_
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: self.currentOrder.symbol ] )
   {
      [ PFModifyOrderViewController showWithOrder: self.currentOrder ];
   }
}

-(void)cancelOrder
{
   [ [ PFSession sharedSession ] cancelOrder: self.currentOrder ];
}

- (IBAction)cancelButtonAction:(id)sender
{
   if ( [ PFSettings sharedSettings ].shouldConfirmCancelOrder )
   {
      [ PFMarketOperationViewController showConfirmWithText: NSLocalizedString( @"CANCEL_CONFIRMATION", nil )
                                                 actionText: NSLocalizedString( @"CANCEL_ORDER_BUTTON", nil )
                                         confirmActionBlock: ^{ [ self cancelOrder ]; } ];
   }
   else
   {
      [ self cancelOrder ];
   }
}

@end
