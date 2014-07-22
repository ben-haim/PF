#import "PFTableViewMoneyItemCell.h"

#import "PFTableViewMoneyItem.h"

#import "NSString+DoubleFormatter.h"
#import "UIColor+Skin.h"

@implementation PFTableViewMoneyItemCell

-(Class)expectedItemClass
{
   return [ PFTableViewMoneyItem class ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewMoneyItem* money_item_ = ( PFTableViewMoneyItem* )item_;

   NSString* money_value_ = [ NSString stringWithMoney: money_item_.amount andPrecision: money_item_.precision ];

   self.valueLabel.text = [ money_value_ stringByAppendingFormat: @" %@", money_item_.currency ];

   if ( money_item_.colorSign )
   {
      self.valueLabel.textColor = money_item_.amount >= 0.0 ? [ UIColor positivePriceColor ] : [ UIColor negativePriceColor ];
   }
   else
   {
      self.valueLabel.textColor = [ UIColor mainTextColor ];
   }
}

@end
