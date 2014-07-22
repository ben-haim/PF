//
//  PFTableViewMarketOperationsItemCell.m
//  PFTrader
//
//  Created by Vit on 30.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFMarketCalculations.h"
#import <ProFinanceApi/ProFinanceApi.h>

#import "NSString+DoubleFormatter.h"

@implementation PFMarketCalculations

+(NSString*)getSideWithMarketOperation:( id< PFMarketOperation > )operation_
{
   NSString* operation_type_text_;
   NSString* side_value_;

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
      side_value_ = [ operation_type_text_ stringByAppendingFormat: @" %@", operation_.optionType == PFSymbolOptionTypeCallVanilla
                     ? NSLocalizedString( @"CALL", nil ) : NSLocalizedString( @"PUT", nil ) ];
   }
   else
   {
      side_value_ = operation_type_text_;
   }

   return side_value_;
}

+(NSString*)getBoughtWithOrder:( id< PFOrder > )order_
{
   if ( order_.isFilled )
   {
      double first_value_ =  order_.symbol.instrument.lotSize * order_.amount;
      double second_value_ = order_.price * first_value_;

      NSString* bought_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp1 : order_.symbol.instrument.exp2 );

      return [ NSString stringWithFormat: @"%@ %@",
              [ NSString stringWithAmount:  order_.operationType == PFMarketOperationBuy ? first_value_ : second_value_ ], bought_currency_ ];
   }
   return @"-";
}

+(NSString*)getSoldWithOrder:( id< PFOrder > )order_
{
   if ( order_.isFilled )
   {
      double first_value_ =  order_.symbol.instrument.lotSize * order_.amount;
      double second_value_ = order_.price * first_value_;

      NSString* sold_currency_ = order_.symbol.instrument.isFutures ?
      NSLocalizedString( @"CONTRACT", nil ) :
      ( order_.operationType == PFMarketOperationBuy ? order_.symbol.instrument.exp2 : order_.symbol.instrument.exp1 );

      return [ NSString stringWithFormat: @"%@ %@"
                              , [ NSString stringWithAmount: order_.operationType == PFMarketOperationBuy ? second_value_ : first_value_ ], sold_currency_ ];
   }
   return @"-";
}

+(NSString*)getBoughtWithTrade:( id< PFTrade > )trade_
{
   double first_value_ =  trade_.symbol.instrument.lotSize * trade_.amount;
   double second_value_ = trade_.price * first_value_;
   NSString* bought_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp1 : trade_.symbol.instrument.exp2 );

   return [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: trade_.isBuy ? first_value_ : second_value_ ], bought_currency_ ];
}

+(NSString*)getSoldWithTrade:( id< PFTrade > )trade_
{
   double first_value_ =  trade_.symbol.instrument.lotSize * trade_.amount;
   double second_value_ = trade_.price * first_value_;
   NSString* sold_currency_ = trade_.symbol.instrument.isFutures ? NSLocalizedString( @"CONTRACT", nil ) : ( trade_.isBuy ? trade_.symbol.instrument.exp2 : trade_.symbol.instrument.exp1 );

   return [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: trade_.isBuy ? second_value_ : first_value_ ], sold_currency_ ];
}

@end
