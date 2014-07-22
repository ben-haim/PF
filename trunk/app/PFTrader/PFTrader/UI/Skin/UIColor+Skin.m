#import "UIColor+Skin.h"

@implementation UIColor (Skin)

+(UIColor*)navigationBarColor
{
   return [ UIColor colorWithWhite: 0.25f alpha: 1.f ];
}

+(UIColor*)mainBackgroundColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFBackground" ] ];
}

+(UIColor*)mainHighlightedBackgroundColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFHighlightedBackground" ] ];
}

+(UIColor*)tableBackgroundColor
{
   return [ UIColor colorWithWhite: 0.15f alpha: 1.f ];
}

@end

@implementation UIColor (Price)

+(UIColor*)positivePriceColor
{
   return [ UIColor colorWithRed: 0.68f green: 0.8f blue: 0.33f alpha: 1.f ];
}

+(UIColor*)negativePriceColor
{
   return [ UIColor colorWithRed: 0.79f green: 0.32f blue: 0.32f alpha: 1.f ];
}

@end


