#import "PFOrderTypeConversion.h"

NSString* NSStringFromPFOrderType( PFOrderType order_type_ )
{
   switch ( order_type_ )
   {
      case PFOrderManual:
         return NSLocalizedString( @"ORDER_MANUAL", nil );
      case PFOrderMarket:
         return NSLocalizedString( @"ORDER_MARKET", nil );
      case PFOrderStop:
         return NSLocalizedString( @"ORDER_STOP", nil );
      case PFOrderLimit:
         return NSLocalizedString( @"ORDER_LIMIT", nil );
      case PFOrderStopLimit:
         return NSLocalizedString( @"ORDER_STOP_LIMIT", nil );
      case PFOrderTrailingStop:
         return NSLocalizedString( @"ORDER_TRAILING_STOP", nil );
      case PFOrderOCO:
         return NSLocalizedString( @"ORDER_OCO", nil );
   }

   return nil;
}

NSString* NSStringOrderTypeFromOperation( id< PFMarketOperation > operation_ )
{
   id< PFOrder > order_ = PFMarketOperationAsOrder( operation_ );
   if ( order_ && ![ order_ isBase ] )
   {
      return operation_.orderType == PFOrderStop
         ? NSLocalizedString( @"STOP_LOSS", nil )
      : ( operation_.orderType == PFOrderTrailingStop ? NSLocalizedString( @"TRAILING_STOP_LOSS", nil ) : NSLocalizedString( @"TAKE_PROFIT", nil ));
   }

   return NSStringFromPFOrderType( operation_.orderType );
}

PFOrderType PFOrderTypeFromNSString( NSString* order_type_ )
{
   if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_MANUAL", nil ) ] )
   {
      return PFOrderManual;
   }
   else if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_MARKET", nil ) ] )
   {
      return PFOrderMarket;
   }
   else if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_STOP", nil ) ] )
   {
      return PFOrderStop;
   }
   else if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_LIMIT", nil ) ] )
   {
      return PFOrderLimit;
   }
   else if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_STOP_LIMIT", nil ) ] )
   {
      return PFOrderStopLimit;
   }
   else if ( [ order_type_ isEqualToString: NSLocalizedString( @"ORDER_TRAILING_STOP", nil ) ] )
   {
      return PFOrderTrailingStop;
   }

   assert( 0 && "undefined order type" );
   return -1;
}
