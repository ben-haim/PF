#import "UIImage+Skin.h"
#import "UIImage+Stretch.h"

@implementation UIImage (NavigationBar)

+(UIImage*)secondBarBackground
{
   return [ [ UIImage imageNamed: @"PFSecondNavigationHead" ] symmetricStretchableImage ];
}

+(UIImage*)headerShadowImage
{
   return [ [ UIImage imageNamed: @"PFHeaderShadow" ] symmetricStretchableImage ];
}

+(UIImage*)headerDarkShadowImage
{
   return [ [ UIImage imageNamed: @"PFHeaderDarkShadow" ] symmetricStretchableImage ];
}

+(UIImage*)thinShadowImage
{
   return [ [ UIImage imageNamed: @"PFThinShadow" ] symmetricStretchableImage ];
}

+(UIImage*)largeShadowImage
{
   return [ [ UIImage imageNamed: @"PFLargeShadow" ] symmetricStretchableImage ];
}

@end


@implementation UIImage (TextField)

+(UIImage*)textFieldBackground
{
   return [ [ UIImage imageNamed: @"PFTextField" ] symmetricStretchableImage ];
}

+(UIImage*)textFieldTopBackground
{
   return [ [ UIImage imageNamed: @"PFTextFieldTop" ] symmetricStretchableImage ];
}

+(UIImage*)textFieldBottomBackground
{
   return [ [ UIImage imageNamed: @"PFTextFieldBottom" ] symmetricStretchableImage ];
}

@end

@implementation UIImage (SearchField)

+(UIImage*)searchFieldIcon
{
   return [ UIImage imageNamed: @"PFSearchFieldIcon" ];
}

@end


@implementation UIImage (Section)

+(UIImage*)sectionBackground
{
   return [ [ UIImage imageNamed: @"PFSectionBackground" ] symmetricStretchableImage ];
}

@end

@implementation UIImage (TreeView)

+(UIImage*)expandedIndicatorImage
{
   return [ UIImage imageNamed: @"PFExpandedIndicator" ];
}

+(UIImage*)collapsedIndicatorImage
{
   return [ UIImage imageNamed: @"PFCollapsedIndicator" ];
}

@end

@implementation UIImage (SegmentedControl)

+(UIImage*)leftSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedLeft" ] symmetricStretchableImage ];
}

+(UIImage*)selectedLeftSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedLeftActive" ] symmetricStretchableImage ];
}

+(UIImage*)centerSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedCenter" ] symmetricStretchableImage ];
}

+(UIImage*)selectedCenterSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedCenterActive" ] symmetricStretchableImage ];
}

+(UIImage*)rightSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedRight" ] symmetricStretchableImage ];
}

+(UIImage*)selectedRightSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSegmentedRightActive" ] symmetricStretchableImage ];
}

+(UIImage*)selectedSegmentBackground
{
   return [ [ UIImage imageNamed: @"PFSwitchBlueDefault" ] symmetricStretchableImage ];
}

+(UIImage*)selectedSegmentClickBackground
{
   return [ [ UIImage imageNamed: @"PFSwitchBlueClick" ] symmetricStretchableImage ];
}

+(UIImage*)segmentBackground
{
   return [ [ UIImage imageNamed: @"PFSwitchBackground" ] symmetricStretchableImage ];
}

@end

@implementation UIImage (Separator)

+(UIImage*)separatorShadow
{
   return [ [ UIImage imageNamed: @"PFSeparatorShadow" ] symmetricStretchableImage ];
}

+(UIImage*)separatorBackground
{
   return [ [ UIImage imageNamed: @"PFSeparatorBackground" ] symmetricStretchableImage ];
}

+(UIImage*)OESeparatorBackground
{
   return [ [ UIImage imageNamed: @"PFOESeparatorBackground" ] symmetricStretchableImage ];
}

+(UIImage*)menuSeparatorBackground
{
   return [ [ UIImage imageNamed: @"PFMenuSeparatorBackground" ] symmetricStretchableImage ];
}

+(UIImage*)chartSeparatorBackground
{
   return [ [ UIImage imageNamed: @"PFChartSeparatorBackground" ] symmetricStretchableImage ];
}

@end

@implementation UIImage (Buttons)

+(UIImage*)blueButtonBackground
{
   return [ [ UIImage imageNamed: @"PFBlueButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedBlueButtonBackground
{
   return [ [ UIImage imageNamed: @"PFBlueButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)greenButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGreenButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedGreenButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGreenButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)redButtonBackground
{
   return [ [ UIImage imageNamed: @"PFRedButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedRedButtonBackground
{
   return [ [ UIImage imageNamed: @"PFRedButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)grayButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGrayButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedGrayButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGrayButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)grayRoundButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGrayRoundButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedGrayRoundButtonBackground
{
   return [ [ UIImage imageNamed: @"PFGrayRoundButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)transparentButtonBackground
{
   return [ [ UIImage imageNamed: @"PFTransparentButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedTransparentButtonBackground
{
   return [ [ UIImage imageNamed: @"PFTransparentButtonPressed" ] symmetricStretchableImage ];
}

+(UIImage*)chartPeriodButtonBackground
{
   return [ [ UIImage imageNamed: @"PFChartPeriodButton" ] symmetricStretchableImage ];
}

+(UIImage*)highlightedChartPeriodButtonBackground
{
   return [ [ UIImage imageNamed: @"PFChartPeriodButtonPressed" ] symmetricStretchableImage ];
}

@end
