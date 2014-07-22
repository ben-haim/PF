#import "UIImage+PFBadgeView.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFBadgeView)

+(UIImage*)badgeBackground
{
   return [ [ UIImage imageNamed: @"PFBadgeBackground" ] symmetricStretchableImage ];
}

@end
