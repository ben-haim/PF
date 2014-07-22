#import "UIColor+FromInt.h"

typedef enum
{
   PFColorByteAlpha
   , PFColorByteBlue
   , PFColorByteGreen
   , PFColorByteRed
} PFColorByteIndex;

static unsigned char PFGetByte( NSUInteger integer_, NSUInteger byte_index_ )
{
   return ( integer_ >> ( byte_index_*8 ) ) & 0xff;
}

@implementation UIColor (FromInt)

+(UIColor*)colorWithInteger:( NSUInteger )integer_
{
   return [ UIColor colorWithRed: PFGetByte( integer_, PFColorByteRed ) / 255.f
                           green: PFGetByte( integer_, PFColorByteGreen ) / 255.f
                            blue: PFGetByte( integer_, PFColorByteBlue ) / 255.f
                           alpha: PFGetByte( integer_, PFColorByteAlpha ) / 255.f ];
}

@end
