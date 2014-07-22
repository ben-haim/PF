//
//  PFPositionsInfoView.m
//  PFTrader
//
//  Created by Denis on 17.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFPositionsInfoView.h"
#import "UIView+LoadFromNib.h"

#import "UILabel+Price.h"
#import "NSDate+Timestamp.h"
#import "PFInstrumentTypeConversion.h"
#import "UIColor+Skin.h"
#import "NSString+DoubleFormatter.h"
#import "PFSettings.h"

#import <JFFMessageBox/JFFMessageBox.h>
#import "PFNavigationController.h"
#import "PFModifyPositionViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFPositionsInfoView ()

@property ( nonatomic, strong ) id< PFPosition > currentPosition;

@end

@implementation PFPositionsInfoView

@synthesize currentPosition;

@synthesize grossPLLabel;
@synthesize timeLabel;
@synthesize expireDateLabel;
@synthesize swapsLabel;
@synthesize stopLossLabel;
@synthesize positionIDLabel;
@synthesize feeLabel;
@synthesize currentPriceLabel;
@synthesize posExposLabel;
@synthesize accountLabel;
@synthesize takeProfitLabel;
@synthesize symbolTypeLabel;

@synthesize grossPLValueLabel;
@synthesize timeValueLabel;
@synthesize expireDateValueLabel;
@synthesize swapsValueLabel;
@synthesize stopLossValueLabel;
@synthesize positionIDValueLabel;
@synthesize feeValueLabel;
@synthesize currentPriceValueLabel;
@synthesize posExposValueLabel;
@synthesize accountValueLabel;
@synthesize takeProfitValueLabel;
@synthesize symbolTypeValueLabel;

@synthesize closeButton;
@synthesize modifyButton;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.grossPLLabel.textColor = [UIColor mainTextColor];
   self.timeLabel.textColor = [UIColor mainTextColor];
   self.expireDateLabel.textColor = [UIColor mainTextColor];
   self.swapsLabel.textColor = [UIColor mainTextColor];
   self.stopLossLabel.textColor = [UIColor mainTextColor];
   self.positionIDLabel.textColor = [UIColor mainTextColor];
   self.feeLabel.textColor = [UIColor mainTextColor];
   self.currentPriceLabel.textColor = [UIColor mainTextColor];
   self.posExposLabel.textColor = [UIColor mainTextColor];
   self.accountLabel.textColor = [UIColor mainTextColor];
   self.takeProfitLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeLabel.textColor = [UIColor mainTextColor];

   self.grossPLValueLabel.textColor = [UIColor grayTextColor];
   self.timeValueLabel.textColor = [UIColor grayTextColor];
   self.expireDateValueLabel.textColor = [UIColor grayTextColor];
   self.swapsValueLabel.textColor = [UIColor grayTextColor];
   self.stopLossValueLabel.textColor = [UIColor grayTextColor];
   self.positionIDValueLabel.textColor = [UIColor grayTextColor];
   self.feeValueLabel.textColor = [UIColor grayTextColor];
   self.currentPriceValueLabel.textColor = [UIColor grayTextColor];
   self.posExposValueLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.takeProfitValueLabel.textColor = [UIColor grayTextColor];
   self.symbolTypeValueLabel.textColor = [UIColor grayTextColor];

   [ self.modifyButton setTitle: NSLocalizedString( @"MODIFY_BUTTON", nil ) forState: UIControlStateNormal ];
   [ self.closeButton setTitle: NSLocalizedString( @"CLOSE_BUTTON", nil ) forState: UIControlStateNormal ];

   self.grossPLLabel.text = NSLocalizedString( @"GROSS_PL", nil );
   self.timeLabel.text = NSLocalizedString( @"OPEN_TIME", nil );
   self.expireDateLabel.text = NSLocalizedString( @"EXPIRATION_DATE", nil );
   self.swapsLabel.text = NSLocalizedString( @"SWAPS", nil );
   self.stopLossLabel.text = NSLocalizedString( @"SL", nil );
   self.positionIDLabel.text = NSLocalizedString( @"POSITION_ID", nil );
   self.feeLabel.text = NSLocalizedString( @"COMMISSION", nil );
   self.currentPriceLabel.text = NSLocalizedString( @"CURRENT_PRICE", nil );
   self.posExposLabel.text = NSLocalizedString( @"POSITION_EXPOSURE", nil);
   self.accountLabel.text = NSLocalizedString( @"ACCOUNT", nil );
   self.takeProfitLabel.text = NSLocalizedString( @"TP", nil );
   self.symbolTypeLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );

   self.grossPLValueLabel.text = @"-";
   self.timeValueLabel.text = @"-";
   self.expireDateValueLabel.text = @"-";
   self.swapsValueLabel.text = @"-";
   self.stopLossValueLabel.text = @"-";
   self.positionIDValueLabel.text = @"-";
   self.feeValueLabel.text = @"-";
   self.currentPriceValueLabel.text = @"-";
   self.posExposValueLabel.text = @"-";
   self.accountValueLabel.text = @"-";
   self.takeProfitValueLabel.text = @"-";
   self.symbolTypeValueLabel.text = @"-";

   self.modifyButton.hidden = self.closeButton.hidden = YES;
}

+(id)positionsInfoViewWithPosition:( id< PFPosition > )position_
{
   PFPositionsInfoView* positions_info_view_ = [ UIView viewAsFirstObjectFromNibNamed: @"PFPositionsInfoView" ];
   positions_info_view_.currentPosition = position_;

   return positions_info_view_;
}

#pragma mark - PFChartInfoView Protocol

-(void)updateDataByTimer
{
   // Content
   [ self.grossPLValueLabel showPositiveNegativeColouredValue: self.currentPosition.grossPl
                                                    precision: self.currentPosition.symbol.instrument.precisionExp1
                                                     currency: @""
                                            negativeTextColor: [UIColor redTextColor]
                                            positiveTextColor: [UIColor greenTextColor]
                                                zeroTextColor: [UIColor mainTextColor]
                                              dashIfValueZero: YES isPositiveSign:NO ];

   self.timeValueLabel.text = [ self.currentPosition.createdAt shortTimestampString ];

   self.expireDateValueLabel.text = (self.currentPosition.symbol.instrument.isFutures || self.currentPosition.symbol.instrument.isOption) ?
   [ self.currentPosition.expirationDate shortDateString ] : @"-";

   self.swapsValueLabel.text = [ NSString stringWithMoney: self.currentPosition.swap
                                             andPrecision: self.currentPosition.symbol.instrument.precisionExp1 ];

   NSString* price_string_ = [ NSString stringWithPrice: self.currentPosition.stopLossPrice
                                                 symbol: self.currentPosition.symbol ];

   self.stopLossValueLabel.text = (self.currentPosition.trailingOffset > 0) ?
   [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;

   self.positionIDValueLabel.text = [ NSString stringWithFormat: @"%d", self.currentPosition.positionId ];

   self.feeValueLabel.text = [ NSString stringWithAmount: (self.currentPosition.commission == 0.0) ? (0.0) : (-1 * self.currentPosition.commission)
                                                 lotStep: self.currentPosition.symbol.instrument.lotStepExp1 ];

   self.currentPriceValueLabel.text = [ NSString stringWithPrice: (self.currentPosition.operationType == PFMarketOperationBuy) ?
                                       self.currentPosition.symbol.quote.bid : self.currentPosition.symbol.quote.ask
                                                          symbol: self.currentPosition.symbol ];

   self.posExposValueLabel.text = [NSString stringWithAmount: self.currentPosition.exposure
                                                   minChange: self.currentPosition.symbol.instrument.lotStepExp1 ];

   self.accountValueLabel.text = self.currentPosition.account.name;

   self.takeProfitValueLabel.text = [ NSString stringWithPrice: self.currentPosition.takeProfitPrice
                                                        symbol: self.currentPosition.symbol ];

   self.symbolTypeValueLabel.text = NSStringForAssetClass( self.currentPosition.symbol.instrument.type );

   // Buttons
   self.modifyButton.hidden = ![ [ PFSession sharedSession ] allowsModifyOperationsForSymbol: self.currentPosition.symbol ] || ![ self.currentPosition.account allowsSLTP ];
   self.closeButton.hidden = ![ [ PFSession sharedSession ] allowsPlaceOperationsForSymbol: self.currentPosition.symbol ];

   CGRect r_close_b_ = self.closeButton.frame;
   CGRect r_mod_b_ = self.modifyButton.frame;

   if (self.closeButton.isHidden && !self.modifyButton.isHidden)
   {
      r_mod_b_.size.width = r_close_b_.size.width + r_close_b_.origin.x - r_mod_b_.origin.x;
      self.modifyButton.frame = r_mod_b_;
   }

   if (self.modifyButton.isHidden && !self.closeButton.isHidden)
   {
      r_close_b_.size.width = r_close_b_.size.width + r_close_b_.origin.x - r_mod_b_.origin.x;
      r_close_b_.origin.x = r_mod_b_.origin.x;
      self.closeButton.frame = r_close_b_;
   }
}

- (IBAction)modifyPositionAction:(id)sender
{
   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: self.currentPosition.symbol ] )
   {
      [ PFModifyPositionViewController showWithPosition: self.currentPosition ];
   }
}

-(void)closePosition
{
   [ [ PFSession sharedSession ] closePosition: self.currentPosition ];
}

- (IBAction)closePositionAction:(id)sender
{
   if ( [ PFSettings sharedSettings ].shouldConfirmClosePosition )
   {
      JFFAlertButton* modify_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"CLOSE_POSITION", nil )
                                                             action: ^( JFFAlertView* sender_ )
                                        {
                                           [ self closePosition ];
                                        } ];

      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"CLOSE_CONFIRMATION", nil )
                                              cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                              otherButtonTitles: modify_button_, nil ];

      [ alert_view_ show ];
   }
   else
   {
      [ self closePosition ];
   }
}

@end
