#import "PFTableViewFilledOprerationItemCell.h"
#import "PFTableViewFilledOperationsItem.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "PFSettings.h"

#import "PFOrderTypeConversion.h"

@implementation PFTableViewFilledOprerationItemCell

@synthesize symbolLabel;
@synthesize quantityOpenPriceLabel;
@synthesize typeLabel;
@synthesize netPlLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewFilledOperationsItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewFilledOperationsItem* trade_item_ = ( PFTableViewFilledOperationsItem* )item_;
   PFTrade* trade_ = (PFTrade*)trade_item_.trade;

   [ (UIImageView*)self.backgroundView setImage: trade_item_.isSelected ? [ UIImage singleGroupedCellBackgroundImageSuperLight ] : [ UIImage singleGroupedCellBackgroundImageLight ] ];
   
   UIColor* textColor = (trade_.operationType == PFMarketOperationBuy) ? [UIColor blueTextColor] : [UIColor redTextColor];

   self.symbolLabel.textColor = textColor;
   self.quantityOpenPriceLabel.textColor = textColor;
   self.typeLabel.textColor = textColor;
   self.netPlLabel.textColor = textColor;

   self.symbolLabel.text = trade_.symbol.name;

   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ?
      trade_.amount :
      trade_.amount * trade_.symbol.instrument.lotSize;

   self.quantityOpenPriceLabel.text = [ NSString stringWithFormat: @"%@@%@",
                                       [ NSString stringWithAmount: displayed_amount_ ],
                                       [ NSString stringWithPrice: trade_.price symbol: trade_.symbol ] ];

   self.typeLabel.text = NSStringOrderTypeFromOperation( trade_ );
   self.netPlLabel.text = [ NSString stringWithAmount: trade_.netPl lotStep: trade_.symbol.instrument.lotStepExp1 ];
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   
}

@end
