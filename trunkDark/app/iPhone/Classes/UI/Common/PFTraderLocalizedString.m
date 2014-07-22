#import "PFTraderLocalizedString.h"

NSString* PFTraderLocalizedString( NSString* key_, NSString* comment_ )
{
   return NSLocalizedStringFromTable( key_, @"PFTrader", comment_ );
}
