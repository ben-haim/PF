#import "UIColor+Skin.h"

@implementation UIColor (Skin)

+(UIColor*)navigationBarColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFNavigation" ] ];
}

+(UIColor*)backgroundLightColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFNavigation" ] ];
}

+(UIColor*)backgroundDarkColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFBackground" ] ];
}

+(UIColor*)mainTextColor
{
   return [ UIColor whiteColor ];
}

+(UIColor*)blueTextColor
{
   return [ UIColor colorWithRed: 56.f / 255.f green: 184.f / 255.f blue: 1.f alpha: 1.f ];
}

+(UIColor*)redTextColor
{
   return [ UIColor colorWithRed: 250.f / 255 green: 48.f / 255 blue: 31.f / 255 alpha: 1.f ];
}

+(UIColor*)greenTextColor
{
   return [ UIColor colorWithRed: 93.f / 255 green: 207.f / 255.f blue: 49.f / 255 alpha: 1.f ];
}

+(UIColor*)grayTextColor
{
   return [ UIColor colorWithRed: 146.f / 255.f green: 146.f / 255.f blue: 148.f / 255.f alpha: 1.f ];
}

@end

@implementation UIColor (Price)

+(UIColor*)positivePriceColor
{
   return [self blueTextColor];
}

+(UIColor*)negativePriceColor
{
   return [self redTextColor];
}

+(UIColor*)positivePriceDarkColor
{
   return [self blueTextColor];//[ UIColor colorWithRed: 28.f / 255.f green: 68.f / 255.f blue: 135.f / 255 alpha: 1.f ];
}

+(UIColor*)negativePriceDarkColor
{
   return [ UIColor colorWithRed: 211.f / 255 green: 2.f / 255 blue: 25.f / 255 alpha: 1.f ];
}

@end


