#import "PFTableViewPositionItemCell.h"
#import "PFTableViewPositionItem.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"
#import "PFSettings.h"

@implementation PFTableViewPositionItemCell

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

   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageLight ] ];

   self.symbolLabel.textColor = [UIColor mainTextColor];
   self.quantityOpenPriceLabel.textColor = [UIColor mainTextColor];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewPositionItem* position_item_ = ( PFTableViewPositionItem* )item_;
   PFPosition* position_ = (PFPosition*)position_item_.position;

   [ (UIImageView*)self.backgroundView setImage: position_item_.isSelected ? [ UIImage singleGroupedCellBackgroundImageSuperLight ] : [ UIImage singleGroupedCellBackgroundImageLight ] ];
   
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
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

@end
