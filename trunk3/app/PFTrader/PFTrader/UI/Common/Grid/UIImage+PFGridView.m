#import "UIImage+PFGridView.h"

#import "UIImage+Stretch.h"

@implementation UIImage (PFGridView)

+(UIImage*)cellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)fixedCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFFixedCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)transparentCellBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFTransparentCellBackground" ] symmetricStretchableImage ];
}

+(UIImage*)summaryButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSummaryButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedSummaryButtonBackground
{
   return [ [ UIImage imageNamed: @"PFSummaryButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)headerBackgroundImage
{
   return [ [ UIImage imageNamed: @"PFGridHeader" ] symmetricStretchableImage ];
}

@end
