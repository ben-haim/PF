#import "UIImage+PFGridView.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFGridView)

+(UIImage*)columnsShadowImage
{
   return [ [ UIImage imageNamed: @"PFGridViewShadow" ] symmetricStretchableImage ];
}

+(UIImage*)cellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)fixedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFFixedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)selectedCellFixedBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFSelectedCellFixedBackground" ] symmetricStretchableImage ];
}

+(UIImage*)selectedCellOverlayImage
{
   return [ [ UIImage imageNamed: @"PFSelectedCellOverlay" ] symmetricStretchableImage ];
}

+(UIImage*)selectedCellShadowImage
{
   return [ [ UIImage imageNamed: @"PFSelectedCellShadow" ] symmetricStretchableImage ];
}

+(UIImage*)summaryButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSummaryButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedSummaryButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSummaryButtonPressed" ] symmetricStretchableImage ];
}

@end
