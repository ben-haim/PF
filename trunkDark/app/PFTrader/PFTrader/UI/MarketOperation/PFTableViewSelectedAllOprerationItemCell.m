#import "PFTableViewSelectedAllOprerationItemCell.h"
#import "PFTableViewAllOperationsItem.h"

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

@implementation PFTableViewSelectedAllOprerationItemCell

@synthesize headerView;

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize statusLabel;

@synthesize sideLabel;
@synthesize dateTimeLabel;
@synthesize tifLabel;
@synthesize orderIdLabel;
@synthesize boughtLabel;
@synthesize soldLabel;
@synthesize accountLabel;
@synthesize symbolTypeLabel;

@synthesize sideValueLabel;
@synthesize dateTimeValueLabel;
@synthesize tifValueLabel;
@synthesize orderIdValueLabel;
@synthesize boughtValueLabel;
@synthesize soldValueLabel;
@synthesize accountValueLabel;
@synthesize symbolTypeValueLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewAllOperationsItem class ];
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
   self.dateTimeLabel.textColor = [UIColor mainTextColor];
   self.tifLabel.textColor = [UIColor mainTextColor];
   self.orderIdLabel.textColor = [UIColor mainTextColor];
   self.boughtLabel.textColor = [UIColor mainTextColor];
   self.soldLabel.textColor = [UIColor mainTextColor];
   self.accountLabel.textColor = [UIColor mainTextColor];
   self.symbolTypeLabel.textColor = [UIColor mainTextColor];

   self.sideValueLabel.textColor = [UIColor grayTextColor];
   self.dateTimeValueLabel.textColor = [UIColor grayTextColor];
   self.tifValueLabel.textColor = [UIColor grayTextColor];
   self.orderIdValueLabel.textColor = [UIColor grayTextColor];
   self.boughtValueLabel.textColor = [UIColor grayTextColor];
   self.soldValueLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.symbolTypeValueLabel.textColor = [UIColor grayTextColor];

   self.sideLabel.text = NSLocalizedString( @"SIDE", nil );
   self.dateTimeLabel.text = NSLocalizedString( @"OPEN_TIME", nil );
   self.tifLabel.text = NSLocalizedString( @"TIF", nil );
   self.orderIdLabel.text = NSLocalizedString( @"ORDER_ID", nil );
   self.boughtLabel.text = NSLocalizedString( @"BOUGHT", nil );
   self.soldLabel.text = NSLocalizedString( @"SOLD", nil );
   self.accountLabel.text = NSLocalizedString( @"ACCOUNT", nil );
   self.symbolTypeLabel.text = NSLocalizedString( @"INSTRUMENT_TYPE", nil );
   
   [ self.headerView addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( headerTapAction ) ] ];
}

-(void)headerTapAction
{
   [ (PFTableViewAllOperationsItem*)self.item deselectCurrentItem ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewAllOperationsItem* oparations_item_ = ( PFTableViewAllOperationsItem* )item_;
   PFOrder* oparations_ = (PFOrder*)oparations_item_.operation;

   // Header
   self.symbolLabel.text = oparations_.symbol.name;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
   oparations_.amount :
   oparations_.amount * oparations_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: oparations_.price symbol: oparations_.symbol ] ];

   self.typeLabel.text = NSStringOrderTypeFromOperation( oparations_ );
   self.statusLabel.text = NSStringFromPFOrderStatusType( oparations_.status );

   // Content
   self.sideValueLabel.text = [ PFMarketCalculations getSideWithMarketOperation: oparations_ ];
   self.dateTimeValueLabel.text = [ oparations_.createdAt shortTimestampString ];
   self.tifValueLabel.text = (oparations_.validity == PFOrderValidityGtd) ? [ oparations_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( oparations_.validity );
   self.orderIdValueLabel.text = [ NSString stringWithFormat: @"%d", oparations_.orderId ];
   self.boughtValueLabel.text = [ PFMarketCalculations getBoughtWithOrder: oparations_ ];
   self.soldValueLabel.text = [ PFMarketCalculations getSoldWithOrder: oparations_ ];
   self.accountValueLabel.text = oparations_.account.name;
   self.symbolTypeValueLabel.text = NSStringForAssetClass( oparations_.symbol.instrument.type );
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [self reloadDataWithItem: item_];
}

@end
