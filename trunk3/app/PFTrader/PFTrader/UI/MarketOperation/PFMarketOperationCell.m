#import "PFMarketOperationCell.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderValidityTypeConversion.h"
#import "PFOrderStatusConversion.h"
#import "PFSettings.h"

#import "NSDate+Timestamp.h"
#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"

#import "PFInstrumentTypeConversion.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFOperationQuantityCell

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? operation_.amount : operation_.amount * operation_.symbol.instrument.lotSize;
   
   [ self.topLabel showColouredValue: operation_.operationType == PFMarketOperationBuy ? displayed_amount_ : ( -1 * displayed_amount_ ) precision: 0 ];

   NSString* operation_type_text_;
   if ( [ operation_ conformsToProtocol: @protocol(PFPosition) ] )
   {
      operation_type_text_ = operation_.operationType == PFMarketOperationBuy ? NSLocalizedString( @"LONG", nil ) : NSLocalizedString( @"SHORT", nil );
   }
   else
   {
      operation_type_text_ = operation_.operationType == PFMarketOperationBuy ? NSLocalizedString( @"BUY", nil ) : NSLocalizedString( @"SELL", nil );
   }
   
   if ( operation_.strikePrice > 0 )
   {
      self.bottomLabel.text = [ operation_type_text_ stringByAppendingFormat: @" %@", operation_.optionType == PFSymbolOptionTypeCallVanilla
                               ? NSLocalizedString( @"CALL", nil ) : NSLocalizedString( @"PUT", nil ) ];
   }
   else
   {
      self.bottomLabel.text = operation_type_text_;
   }
}

@end

@implementation PFOperationSLCell

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   NSString* price_string_ = [ NSString stringWithPrice: operation_.stopLossPrice symbol: operation_.symbol ];
   self.valueLabel.text = operation_.stopLossOrder.orderType == PFOrderTrailingStop ? [ @"Tr. " stringByAppendingString: price_string_ ] : price_string_;
}

@end

@implementation PFOperationTPCell

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = [ NSString stringWithPrice: operation_.takeProfitPrice symbol: operation_.symbol ];
}

@end

@implementation PFOperationTypeCell

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.topLabel.text = NSStringOrderTypeFromOperation( operation_ );
   self.bottomLabel.text = [ NSString stringWithPrice: operation_.price symbol: operation_.symbol ];
}

@end

@implementation PFOperationAccountCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = order_.account.name;
   self.bottomLabel.text = [ NSString stringWithPrice: order_.stopPrice symbol: order_.symbol ];
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = trade_.account.name;
   self.bottomLabel.text = @"-";
}

@end

@implementation PFOperationTifCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = order_.validity == PFOrderValidityGtd ? [ order_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( order_.validity );
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", order_.orderId ];
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = @"-";
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", trade_.orderId ];
}

@end

@implementation PFOperationInstrumentTypeCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = NSStringForAssetClass( order_.symbol.instrument.type );
   self.bottomLabel.text = NSStringFromPFOrderStatusType(order_.status);
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = NSStringForAssetClass( trade_.symbol.instrument.type );
   self.bottomLabel.text = NSLocalizedString( @"ORDER_STAUS_FILLED", nil );
}

@end

@implementation PFOperationBoughtSoldCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   if ( order_.isFilled )
   {
      double first_value_ =  order_.symbol.instrument.lotSize * order_.amount;
      double second_value_ = order_.price * first_value_;
      
      NSString* bought_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp1 : order_.symbol.instrument.exp2 );
      
      NSString* sold_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp2 : order_.symbol.instrument.exp1 );
      
      self.topLabel.text = [ NSString stringWithFormat: @"%@ %@"
                            , [ NSString stringWithAmount:  order_.operationType == PFMarketOperationBuy ? first_value_ : second_value_ ], bought_currency_ ];
      self.bottomLabel.text = [ NSString stringWithFormat: @"%@ %@"
                               , [ NSString stringWithAmount: order_.operationType == PFMarketOperationBuy ? second_value_ : first_value_ ], sold_currency_ ];
   }
   else
   {
      self.topLabel.text = @"";
      self.bottomLabel.text = @"";
   }
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   double first_value_ =  trade_.symbol.instrument.lotSize * trade_.amount;
   double second_value_ = trade_.price * first_value_;
   
   NSString* bought_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp1 : trade_.symbol.instrument.exp2 );
   NSString* sold_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp2 : trade_.symbol.instrument.exp1 );
   
   self.topLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount:  trade_.isBuy ? first_value_ : second_value_ ], bought_currency_ ];
   self.bottomLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: trade_.isBuy ? second_value_ : first_value_ ], sold_currency_ ];
}

@end

@implementation PFOperationOrderIdCell

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.topLabel.text = NSStringFromPFOrderStatusType(order_.status);
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", order_.orderId ];
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.topLabel.text = NSLocalizedString( @"ORDER_STAUS_FILLED", nil );
   self.bottomLabel.text = [ NSString stringWithFormat: @"%d", trade_.orderId ];
}

@end
