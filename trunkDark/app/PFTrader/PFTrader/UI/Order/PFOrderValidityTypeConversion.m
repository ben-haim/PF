#import "PFOrderValidityTypeConversion.h"

NSString* NSStringFromPFOrderValidityType( PFOrderValidityType validity_ )
{
   switch ( validity_ )
   {
      case PFOrderValidityDay:
         return NSLocalizedString( @"DAY", nil );
      case PFOrderValidityGtc:
         return NSLocalizedString( @"GTC", nil );
      case PFOrderValidityIoc:
         return NSLocalizedString( @"IOC", nil );
      case PFOrderValidityGtd:
         return NSLocalizedString( @"GTD", nil );
      case PFOrderValidityFok:
         return NSLocalizedString( @"FOK", nil );
      case PFOrderValidityMoo:
         return NSLocalizedString( @"MOO", nil );
      case PFOrderValidityMoc:
         return NSLocalizedString( @"MOC", nil );
      default:
         return nil;
   }
   
   return nil;
}