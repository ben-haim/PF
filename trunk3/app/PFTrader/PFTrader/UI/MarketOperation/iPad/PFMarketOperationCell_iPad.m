#import "PFMarketOperationCell_iPad.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderValidityTypeConversion.h"
#import "PFInstrumentTypeConversion.h"
#import "PFOrderStatusConversion.h"
#import "PFSettings.h"
#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFOperationQuantityCell_iPad

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   double displayed_amount_ = [ PFSettings sharedSettings ].showQuantityInLots ? operation_.amount : operation_.amount * operation_.symbol.instrument.lotSize;
   [ self.valueLabel showColouredValue: operation_.operationType == PFMarketOperationBuy ? displayed_amount_ : ( -1 * displayed_amount_ ) precision: 0 ];
}

@end

@implementation PFOperationSideCell_iPad

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
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
      self.valueLabel.text = [ operation_type_text_ stringByAppendingFormat: @" %@", operation_.optionType == PFSymbolOptionTypeCallVanilla
                              ? NSLocalizedString( @"CALL", nil ) : NSLocalizedString( @"PUT", nil ) ];
   }
   else
   {
      self.valueLabel.text = operation_type_text_;
   }
}

@end

@implementation PFOperationTypeCell_iPad

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = NSStringOrderTypeFromOperation( operation_ );
}

@end

@implementation PFOperationPriceCell_iPad

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = [ NSString stringWithPrice: operation_.price symbol: operation_.symbol ];
}

@end

@implementation PFOperationDateTimeCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = [ operation_.createdAt shortTimestampString ];
}

@end

@implementation PFOperationStopPriceCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.valueLabel.text = [ NSString stringWithPrice: order_.stopPrice symbol: order_.symbol ];
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = @"-";
}

@end

@implementation PFOperationNameCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = operation_.symbol.name;
}

@end

@implementation PFOperationTifCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.valueLabel.text = order_.validity == PFOrderValidityGtd ? [ order_.expireAtDate shortDateString ] : NSStringFromPFOrderValidityType( order_.validity );
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = @"-";
}

@end

@implementation PFOperationAccountCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = operation_.account.name;
}

@end

@implementation PFOperationOrderIdCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = [ NSString stringWithFormat: @"%d", operation_.orderId ];
}

@end

@implementation PFOperationStatusCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   self.valueLabel.text = NSStringFromPFOrderStatusType(order_.status);
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   self.valueLabel.text = NSLocalizedString( @"ORDER_STAUS_FILLED", nil );
}

@end

@implementation PFOperationInstrumentTypeCell_iPad

-(BOOL)isDynamic
{
   return NO;
}

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   self.valueLabel.text = NSStringForAssetClass( operation_.symbol.instrument.type );
}

@end

@implementation PFOperationBoughtCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   if ( order_.isFilled )
   {
      double first_value_ =  order_.symbol.instrument.lotSize * order_.amount;
      double second_value_ = order_.price * first_value_;
      
      NSString* bought_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp1 : order_.symbol.instrument.exp2 );
      
      self.valueLabel.text = [ NSString stringWithFormat: @"%@ %@"
                            , [ NSString stringWithAmount:  order_.operationType == PFMarketOperationBuy ? first_value_ : second_value_ ], bought_currency_ ];

   }
   else
   {
      self.valueLabel.text = @"";
   }
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   double first_value_ =  trade_.symbol.instrument.lotSize * trade_.amount;
   double second_value_ = trade_.price * first_value_;
   NSString* bought_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp1 : trade_.symbol.instrument.exp2 );
   
   self.valueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount:  trade_.isBuy ? first_value_ : second_value_ ], bought_currency_ ];
}

@end

@implementation PFOperationSoldCell_iPad

-(void)reloadDataWithOrder:( id< PFOrder > )order_
{
   if ( order_.isFilled )
   {
      double first_value_ =  order_.symbol.instrument.lotSize * order_.amount;
      double second_value_ = order_.price * first_value_;
      
      NSString* sold_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp2 : order_.symbol.instrument.exp1 );
      
      self.valueLabel.text = [ NSString stringWithFormat: @"%@ %@"
                              , [ NSString stringWithAmount: order_.operationType == PFMarketOperationBuy ? second_value_ : first_value_ ], sold_currency_ ];
   }
   else
   {
      self.valueLabel.text = @"";
   }
}

-(void)reloadDataWithTrade:( id< PFTrade > )trade_
{
   double first_value_ =  trade_.symbol.instrument.lotSize * trade_.amount;
   double second_value_ = trade_.price * first_value_;
   NSString* sold_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp2 : trade_.symbol.instrument.exp1 );
   
   self.valueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithAmount: trade_.isBuy ? second_value_ : first_value_ ], sold_currency_ ];
}

@end