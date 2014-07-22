#import "UIColor+Skin.h"

@implementation UIColor (Skin)

+(UIColor*)navigationBarColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFNavigation" ] ];
}

+(UIColor*)mainTextColor
{
   return [ UIColor colorWithRed: 34.f / 255 green: 34.f / 255 blue: 34.f / 255 alpha: 1.f ];
}

@end

@implementation UIColor (Price)

+(UIColor*)positivePriceColor
{
   return [ UIColor colorWithRed: 55.f / 255 green: 117.f / 255 blue: 14.f / 255 alpha: 1.f ];
}

+(UIColor*)negativePriceColor
{
   return [ UIColor colorWithRed: 153.f / 255 green: 0.f blue: 0.f alpha: 1.f ];
}

@end


