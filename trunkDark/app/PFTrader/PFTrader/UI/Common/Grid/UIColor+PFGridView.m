#import "UIColor+PFGridView.h"

@implementation UIColor (PFGridView)

+(UIColor*)gridViewOverlayColor
{
   return [ UIColor clearColor ];
}

+(UIColor*)actionViewBackgroundColor
{
   return [ UIColor colorWithRed: 240.f / 255 green: 241.f / 255 blue: 244.f / 255 alpha: 1.f ];
}

+(UIColor*)gridViewFooterBackgroundColor
{
   return [ UIColor colorWithPatternImage: [ UIImage imageNamed: @"PFSummaryBackground" ] ];
}


@end
