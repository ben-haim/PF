#import "PFTableViewSelectedActiveOprerationItemCell.h"
#import "PFTableViewActiveOperationsItem.h"

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

#import "PFChartViewController.h"
#import "PFNavigationController.h"
#import <JFFMessageBox/JFFMessageBox.h>
#import "PFModifyOrderViewController.h"

#import "PFMarketCalculations.h"

@implementation PFTableViewSelectedActiveOprerationItemCell

@synthesize headerView;

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize statusLabel;

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

-(Class)expectedItemClass
{
   return [ PFTableViewActiveOperationsItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImage ] ];
   self.headerView.image = [ UIImage topGroupedCellBackgroundImageLight ];

   self.symbolLabel.textColor = [UIColor mainTextColor];
   self.quantityOpenPriceLabel.textColor = [UIColor mainTextColor];
   self.typeLabel.textColor = [UIColor mainTextColor];
   self.statusLabel.textColor = [UIColor mainTextColor];

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
   
   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( headerTapAction ) ] ];
}

-(void)headerTapAction
{
   [ (PFTableViewActiveOperationsItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewActiveOperationsItem* order_item_ = ( PFTableViewActiveOperationsItem* )item_;
   PFOrder* order_ = (PFOrder*)order_item_.order;

   // Header
   self.typeLabel.text = NSStringOrderTypeFromOperation( order_ );
   self.symbolLabel.text = order_.symbol.name;
   self.statusLabel.text = NSStringFromPFOrderStatusType( order_.status );

   double displayed_amount_ = order_.amount * ([PFSettings sharedSettings].showQuantityInLots ? 1 : order_.symbol.instrument.lotSize);
   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: order_.price symbol: order_.symbol ] ];

   // Content
   self.tifValueLabel.text = (order_.validity == PFOrderValidityGtd) ? [ order_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( order_.validity );
   self.sideValueLabel.text = [ PFMarketCalculations getSideWithMarketOperation: order_ ];
   self.accountValueLabel.text = order_.account.name;
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", order_.orderId ];
   self.dateTimeValueLabel.text = [ order_.createdAt shortTimestampString ];
   self.stopPriceValueLabel.text = [ NSString stringWithPrice: order_.stopPrice symbol: order_.symbol ];
   self.takeprofitValueLabel.text = [ NSString stringWithPrice: order_.takeProfitPrice symbol: order_.symbol ];
   self.initialReqValueLabel.text = [ NSString stringWithMoney: order_.initMargin andPrecision: order_.account.precision ];
   self.symbolTypeValueLabel.text = NSStringForAssetClass( order_.symbol.instrument.type );
   self.expirationDateValueLabel.text = order_.expirationDate ? [ order_.expirationDate shortTimestampString ] : @"-";

   self.qtyFilledValueLabel.text = [ NSString stringWithAmount: order_.filledAmount *
                                    ([PFSettings sharedSettings].showQuantityInLots ? 1 : order_.symbol.lotSize) ];

   self.qtyRemainingValueLabel.text = [ NSString stringWithAmount: (order_.amount-order_.filledAmount) *
                                       ([PFSettings sharedSettings].showQuantityInLots ? 1 : order_.symbol.lotSize) ];

   self.currentPriceValueLabel.text = [ NSString stringWithPrice: (order_.operationType == PFMarketOperationBuy) ? order_.symbol.quote.bid : order_.symbol.quote.ask
                                                          symbol: order_.symbol ];

   NSString* price_string_ = [ NSString stringWithPrice: order_.stopLossPrice symbol: order_.symbol ];
   self.stopLossValueLabel.text = (order_.stopLossOrder.orderType == PFOrderTrailingStop) ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;

   // Buttons
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [self reloadDataWithItem: item_];
}

-(IBAction)modyfiButtonAction:( id )sender_
{
   PFTableViewActiveOperationsItem* order_item_ = (PFTableViewActiveOperationsItem*)self.item;

   if ( [ [ PFSession sharedSession ] allowsTradingForSymbol: order_item_.order.symbol ] )
   {
      [ PFModifyOrderViewController showWithOrder: order_item_.order ];
   }
}

-(void)cancelOrder
{
   PFTableViewActiveOperationsItem* order_item_ = (PFTableViewActiveOperationsItem*)self.item;
   [ [ PFSession sharedSession ] cancelOrder: order_item_.order ];
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

- (IBAction)chartButtonAction:(id)sender
{
   PFTableViewActiveOperationsItem* order_item_ = (PFTableViewActiveOperationsItem*)self.item;
   PFChartViewController* chart_view_controller_ = [ [ PFChartViewController alloc ] initWithSymbol: order_item_.order.symbol ];

   [ order_item_.currentController.pfNavigationController pushViewController: chart_view_controller_
                                                                previousTitle: order_item_.order.symbol.name
                                                                     animated: YES ];
}

@end
