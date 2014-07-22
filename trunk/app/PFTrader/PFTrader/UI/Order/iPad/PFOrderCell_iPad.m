#import "PFOrderCell_iPad.h"

#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFOrderLastCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.valueLabel.text = [ NSString stringWithPrice: order_.operationType == PFMarketOperationBuy ? order_.symbol.quote.ask : order_.symbol.quote.bid
                                              symbol: order_.symbol ];
}

@end

@implementation PFOrderAccount_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.valueLabel.text = order_.account.name;
}

@end

