#import "PFInstrumentTypeConversion.h"

NSString* NSStringForAssetClass( Byte asset_class_ )
{
   switch ( asset_class_ )
   {
      case PFInstrumentForex:
         return NSLocalizedString( @"INSTRUMENT_FOREX", nil );
      case PFInstrumentStocks:
         return NSLocalizedString( @"INSTRUMENT_STOCKS", nil );
      case PFInstrumentFutures:
         return NSLocalizedString( @"INSTRUMENT_FUTURES", nil );
      case PFInstrumentOptions:
         return NSLocalizedString( @"INSTRUMENT_OPTIONS", nil );
      case PFInstrumentCFDIndex:
         return NSLocalizedString( @"INSTRUMENT_CFDINDEX", nil );
      case PFInstrumentForward:
         return NSLocalizedString( @"INSTRUMENT_FORWARD", nil );
      case PFInstrumentCFDFutures:
         return NSLocalizedString( @"INSTRUMENT_CFDFUTURES", nil );
      case PFInstrumentIndices:
         return NSLocalizedString( @"INSTRUMENT_INDICES", nil );
         
      default:
         return NSLocalizedString( @"INSTRUMENT_GENERAL", nil );
   }
}
