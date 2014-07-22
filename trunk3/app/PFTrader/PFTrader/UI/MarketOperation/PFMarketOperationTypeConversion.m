#import "PFMarketOperationTypeConversion.h"

NSString* NSStringFromPFMarketOperationType( PFMarketOperationType operation_type_ )
{
   if ( operation_type_ == PFMarketOperationBuy )
   {
      return NSLocalizedString( @"BUY", nil );
   }
   else if ( operation_type_ == PFMarketOperationSell )
   {
      return NSLocalizedString( @"SELL", nil );
   }

   assert( 0 && "undefined operation type" );
   return nil;
}
