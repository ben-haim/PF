#import "PFTableViewActiveOprerationItemCell.h"
#import "PFTableViewActiveOperationsItem.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "PFSettings.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderStatusConversion.h"

@implementation PFTableViewActiveOprerationItemCell

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize statusLabel;

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
}

-(Class)expectedItemClass
{
   return [ PFTableViewActiveOperationsItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewActiveOperationsItem* order_item_ = ( PFTableViewActiveOperationsItem* )item_;
   PFOrder* order_ = (PFOrder*)order_item_.order;

   [ (UIImageView*)self.backgroundView setImage: order_item_.isSelected ? [ UIImage singleGroupedCellBackgroundImageSuperLight ] : [ UIImage singleGroupedCellBackgroundImageLight ] ];
   
   UIColor* textColor = (order_.operationType == PFMarketOperationBuy) ? [UIColor blueTextColor] : [UIColor redTextColor];

   self.symbolLabel.textColor = textColor;
   self.quantityOpenPriceLabel.textColor = textColor;
   self.typeLabel.textColor = textColor;
   self.statusLabel.textColor = textColor;

   self.symbolLabel.text = order_.symbol.name;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
      order_.amount :
      order_.amount * order_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: order_.price symbol: order_.symbol ] ];

   self.typeLabel.text = NSStringOrderTypeFromOperation( order_ );
   self.statusLabel.text = NSStringFromPFOrderStatusType( order_.status );
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

@end
