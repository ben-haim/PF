#import "PFOrderCell.h"

#import "PFOrderValidityTypeConversion.h"
#import "PFInstrumentTypeConversion.h"

#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFOrderLastCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = [ NSString stringWithPrice: order_.operationType == PFMarketOperationBuy ? order_.symbol.quote.ask : order_.symbol.quote.bid
                                            symbol: order_.symbol ];
   
   NSString* price_string_ = [ NSString stringWithPrice: order_.stopLossPrice symbol: order_.symbol ];
   self.bottomLabel.text = order_.stopLossOrder.orderType == PFOrderTrailingStop ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;
}

@end

@implementation PFOrderTifCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = order_.validity == PFOrderValidityGtd ? [ order_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( order_.validity );
   self.bottomLabel.text = [ NSString stringWithPrice: order_.takeProfitPrice symbol: order_.symbol ];
}

@end

@implementation PFOrderInstrumentCell

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = NSStringForAssetClass( order_.symbol.instrument.type );
   self.bottomLabel.text = order_.account.name;
}

@end

