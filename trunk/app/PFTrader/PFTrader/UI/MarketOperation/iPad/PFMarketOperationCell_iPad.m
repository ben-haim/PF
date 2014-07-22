#import "PFMarketOperationCell_iPad.h"

#import "PFOrderTypeConversion.h"
#import "PFOrderValidityTypeConversion.h"
#import "PFOrderStatusConversion.h"

#import "NSString+DoubleFormatter.h"
#import "NSDate+Timestamp.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFOperationQuantityCell_iPad

-(void)reloadDataWithMarketOperation:( id< PFMarketOperation > )operation_
{
   [ self.valueLabel showColouredValue: operation_.operationType == PFMarketOperationBuy ? operation_.amount : ( -1 * operation_.amount ) precision: 0 ];
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