#import "PFTableViewSelectedFilledOprerationItemCell.h"
#import "PFTableViewFilledOperationsItem.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"
#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "PFSettings.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderStatusConversion.h"
#import "PFOrderValidityTypeConversion.h"
#import "PFInstrumentTypeConversion.h"

#import "PFMarketCalculations.h"

@implementation PFTableViewSelectedFilledOprerationItemCell

@synthesize headerView;

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize netPlLabel;

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

-(Class)expectedItemClass
{
   return [ PFTableViewFilledOperationsItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImage ] ];
   self.headerView.image = [ UIImage topGroupedCellBackgroundImageLight ];

   self.symbolLabel.textColor = [UIColor mainTextColor];
   self.quantityOpenPriceLabel.textColor = [UIColor mainTextColor];
   self.typeLabel.textColor = [UIColor mainTextColor];
   self.netPlLabel.textColor = [UIColor mainTextColor];

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
   
   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( headerTapAction ) ] ];
}

-(void)headerTapAction
{
   [ (PFTableViewFilledOperationsItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewFilledOperationsItem* trade_item_ = ( PFTableViewFilledOperationsItem* )item_;
   PFTrade* trade_ = (PFTrade*)trade_item_.trade;

   // Header
   self.symbolLabel.text = trade_.symbol.name;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
      trade_.amount :
      trade_.amount * trade_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: trade_.price symbol: trade_.symbol ] ];

   self.typeLabel.text = NSStringOrderTypeFromOperation( trade_ );
   self.netPlLabel.text = [ NSString stringWithAmount: trade_.netPl lotStep: trade_.symbol.instrument.lotStepExp1 ];

   // Content
   self.sideValueLabel.text = [ PFMarketCalculations getSideWithMarketOperation: trade_ ];
   self.dateTimeValueLabel.text = [ trade_.createdAt shortTimestampString ];
   self.orderTypeValueLabel.text = NSStringOrderTypeFromOperation(trade_);
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", trade_.orderId ];
   self.tradeIdValueLabel.text = [ NSString stringWithFormat: @"%d", trade_.tradeId ];
   self.accountValueLabel.text = trade_.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( trade_.symbol.instrument.type );
   self.exposureValueLabel.text = [ NSString stringWithMoney: trade_.exposure ];
   self.boughtValueLabel.text = [ PFMarketCalculations getBoughtWithTrade: trade_ ];
   self.soldValueLabel.text = [ PFMarketCalculations getSoldWithTrade: trade_ ];

   self.accountValueLabel.text = trade_.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( trade_.symbol.instrument.type );
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [self reloadDataWithItem: item_];
}

@end
