#import "PFIndicatorLocalizedString.h"

NSString* PFIndicatorLocalizedString( NSString* key_, NSString* comment_ )
{
   return NSLocalizedStringFromTable( key_, @"PFIndicator", comment_ );
}