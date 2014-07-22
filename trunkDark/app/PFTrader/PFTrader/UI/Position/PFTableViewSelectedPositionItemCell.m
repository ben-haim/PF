#import "PFTableViewSelectedPositionItemCell.h"
#import "PFTableViewPositionItem.h"
#import "UIImage+PFTableView.h"
#import "UILabel+Price.h"
#import "NSDate+Timestamp.h"
#import "PFInstrumentTypeConversion.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "NSString+DoubleFormatter.h"
#import "PFSettings.h"

#import "PFChartViewController.h"
#import "PFNavigationController.h"
#import <JFFMessageBox/JFFMessageBox.h>
#import "PFModifyPositionViewController.h"


@implementation PFTableViewSelectedPositionItemCell

@synthesize headerView;

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

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize netPLLabel;
@synthesize arrowImage;
@synthesize thinArrowImage;

-(Class)expectedItemClass
{
   return [ PFTableViewPositionItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImage ] ];
   self.headerView.image = [ UIImage topGroupedCellBackgroundImageLight ];

   self.symbolLabel.textColor = [UIColor mainTextColor];
   self.quantityOpenPriceLabel.textColor = [UIColor mainTextColor];

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
   
   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( headerTapAction ) ] ];
}

-(void)headerTapAction
{
   [ (PFTableViewPositionItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewPositionItem* position_item_ = ( PFTableViewPositionItem* )item_;
   id< PFPosition > position_ = position_item_.position;


   // Header
   self.symbolLabel.text = position_.symbol.name;

   [ self.netPLLabel showPositiveNegativeColouredValue: position_.netPl
                                             precision: position_.symbol.instrument.precisionExp1
                                              currency: @""
                                     negativeTextColor: [UIColor redTextColor]
                                     positiveTextColor: [UIColor blueTextColor]
                                         zeroTextColor: [UIColor mainTextColor]
                                       dashIfValueZero: YES isPositiveSign:NO ];

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
      position_.amount :
      position_.amount * position_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: position_.openPrice symbol: position_.symbol ] ];

   [ self.arrowImage setImage: nil ];

   if (position_.operationType == PFMarketOperationBuy)
      [ self.arrowImage setImage: [UIImage positionUpArrowImage] ];

   if (position_.operationType == PFMarketOperationSell)
      [ self.arrowImage setImage: [UIImage positionDownArrowImage] ];


   // Content
   [ self.grossPLValueLabel showPositiveNegativeColouredValue: position_.grossPl
                                                    precision: position_.symbol.instrument.precisionExp1
                                                     currency: @""
                                            negativeTextColor: [UIColor redTextColor]
                                            positiveTextColor: [UIColor greenTextColor]
                                                zeroTextColor: [UIColor mainTextColor]
                                              dashIfValueZero: YES isPositiveSign:NO ];
    
   self.timeValueLabel.text = [ position_.createdAt shortTimestampString ];
   
   self.expireDateValueLabel.text = (position_.symbol.instrument.isFutures || position_.symbol.instrument.isOption) ?
      [ position_.expirationDate shortDateString ] : @"-";

   self.swapsValueLabel.text = [ NSString stringWithMoney: position_.swap
                                             andPrecision: position_.symbol.instrument.precisionExp1 ];
   
   NSString* price_string_ = [ NSString stringWithPrice: position_.stopLossPrice
                                                 symbol: position_.symbol ];

   self.stopLossValueLabel.text = (position_.trailingOffset > 0) ?
      [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;
   
   self.positionIDValueLabel.text = [ NSString stringWithFormat: @"%d", position_.positionId ];
   
   self.feeValueLabel.text = [ NSString stringWithAmount: (position_.commission == 0.0) ? (0.0) : (-1 * position_.commission)
                                                 lotStep: position_.symbol.instrument.lotStepExp1 ];
   
   self.currentPriceValueLabel.text = [ NSString stringWithPrice: (position_.operationType == PFMarketOperationBuy) ?
                                                                   position_.symbol.quote.bid : position_.symbol.quote.ask
                                                          symbol: position_.symbol ];
   
   self.posExposValueLabel.text = [NSString stringWithAmount: position_.exposure
                                                   minChange: position_.symbol.instrument.lotStepExp1 ];

   self.accountValueLabel.text = position_.account.name;

   self.takeProfitValueLabel.text = [ NSString stringWithPrice: position_.takeProfitPrice
                                                        symbol: position_.symbol ];

   self.symbolTypeValueLabel.text = NSStringForAssetClass( position_.symbol.instrument.type );

   // Buttons
   self.modifyButton.hidden = ![ [ PFSession sharedSession ] allowsModifyOperationsForSymbol: position_.symbol ] || ![ position_.account allowsSLTP ];
   self.closeButton.hidden = ![ [ PFSession sharedSession ] allowsPlaceOperationsForSymbol: position_.symbol ];

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

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

-(void)closePosition
{
   PFTableViewPositionItem* position_item_ = (PFTableViewPositionItem*)self.item;
   [ [ PFSession sharedSession ] closePosition: position_item_.position ];
}

- (IBAction)closePositionAction:( id )sender
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

-(IBAction)modifyPositionAction:( id )sender_
{
   PFTableViewPositionItem* position_item_ = (PFTableViewPositionItem*)self.item;

   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: position_item_.position.symbol ] )
   {
      [ PFModifyPositionViewController showWithPosition: position_item_.position ];
   }
}

-(IBAction)chartAction:( id )sender_
{
   PFTableViewPositionItem* position_item_ = (PFTableViewPositionItem*)self.item;
   PFChartViewController* chart_view_controller_ = [ [ PFChartViewController alloc ] initWithSymbol: position_item_.position.symbol ];

   [ position_item_.currentController.pfNavigationController pushViewController: chart_view_controller_
                                                                 previousTitle: position_item_.position.symbol.name
                                                                      animated: YES ];
}

@end
