#import "UIImage+PFSplittedView.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFSplittedView)

+(UIImage*)splitterBackground
{
   return [ [ UIImage imageNamed: @"PFSplitterBackground" ] symmetricStretchableImage ];
}

+(UIImage*)splitterImage
{
   return [ UIImage imageNamed: @"PFSplitter" ];
}

@end
