#import "UIImage+PFSwitch.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFSwitch)

+(UIImage*)switchThumbImage
{
   return [ [ UIImage imageNamed: @"PFSwitchThumb" ] symmetricStretchableImage ];
}

+(UIImage*)switchOnBackground
{
   return [ [ UIImage imageNamed: @"PFSwitchOnBackground" ] symmetricStretchableImage ];
}

+(UIImage*)switchOffBackground
{
   return [ [ UIImage imageNamed: @"PFSwitchOffBackground" ] symmetricStretchableImage ];
}

@end
