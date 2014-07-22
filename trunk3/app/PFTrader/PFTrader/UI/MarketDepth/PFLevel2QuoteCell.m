#import "PFLevel2QuoteCell.h"
#import "PFSettings.h"
#import "UILabel+Price.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFLevel2QuotePriceCell

-(void)reloadDataWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
{
   self.valueLabel.userInteractionEnabled = NO;

   [ self.valueLabel showPrice: level2_quote_.price
                     forSymbol: level2_quote_.symbol ];
}

-(IBAction)marketAction:( id )sender_
{
   [ self.delegate symbolPriceCell: self
               didSelectLeve2Quote: self.level2Quote ];
}

@end

@implementation PFLevel2QuoteSizeCell

-(void)reloadDataWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
{
   if ( [ PFSettings sharedSettings ].showQuantityInLots )
   {
      self.valueLabel.text = [ NSString stringWithAmount: level2_quote_.size / level2_quote_.symbol.lotSize
                                                  symbol: level2_quote_.symbol ];
   }
   else
   {
      self.valueLabel.text = [ NSString stringWithAmount: level2_quote_.size ];
   }
}

@end

@implementation PFLevel2QuoteCCYSizeCell

-(void)reloadDataWithLevel2Quote:( id< PFLevel2Quote > )level2_quote_
{
   self.valueLabel.text = [ NSString stringWithAmount: level2_quote_.size * level2_quote_.price ];
}

@end
