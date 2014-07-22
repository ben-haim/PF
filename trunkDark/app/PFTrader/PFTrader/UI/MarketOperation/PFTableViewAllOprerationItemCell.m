#import "PFTableViewAllOprerationItemCell.h"
#import "PFTableViewAllOperationsItem.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "PFSettings.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderStatusConversion.h"

@implementation PFTableViewAllOprerationItemCell

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize statusLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewAllOperationsItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewAllOperationsItem* oparations_item_ = ( PFTableViewAllOperationsItem* )item_;
   PFOrder* oparations_ = (PFOrder*)oparations_item_.operation;

   [ (UIImageView*)self.backgroundView setImage: oparations_item_.isSelected ? [ UIImage singleGroupedCellBackgroundImageSuperLight ] : [ UIImage singleGroupedCellBackgroundImageLight ] ];
   
   UIColor* textColor = (oparations_.operationType == PFMarketOperationBuy) ? [UIColor blueTextColor] : [UIColor redTextColor];

   self.symbolLabel.textColor = textColor;
   self.quantityOpenPriceLabel.textColor = textColor;
   self.typeLabel.textColor = textColor;
   self.statusLabel.textColor = textColor;

   self.symbolLabel.text = oparations_.symbol.name;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
      oparations_.amount :
      oparations_.amount * oparations_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: oparations_.price symbol: oparations_.symbol ] ];

   self.typeLabel.text = NSStringOrderTypeFromOperation( oparations_ );
   self.statusLabel.text = NSStringFromPFOrderStatusType( oparations_.status );
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [self reloadDataWithItem: item_];
}

@end
