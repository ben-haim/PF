#import "UIColor+PFGridView.h"

@implementation UIColor (PFGridView)

+(UIColor*)gridViewOverlayColor
{
   return [ UIColor colorWithWhite: 0.f alpha: 0.7f ];
}

+(UIColor*)gridViewBackgroundColor
{
   return [ UIColor colorWithWhite: 0.27f alpha: 1.f ];
}

+(UIColor*)gridViewColumnsBackgroundColor
{
   return [ UIColor colorWithWhite: 0.2f alpha: 1.f ];
}

@end
