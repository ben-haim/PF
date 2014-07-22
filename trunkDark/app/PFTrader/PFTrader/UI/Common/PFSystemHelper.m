#import "PFSystemHelper.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ( [ [ [ UIDevice currentDevice ] systemVersion ] compare: v options: NSNumericSearch ] != NSOrderedAscending )

static NSString* flat_style_version_ = @"7.0";

BOOL useFlatUI()
{
   return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( flat_style_version_ );
}

BOOL systemGreaterOrEqual( NSString* system_version_ )
{
   return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( system_version_ );
}
