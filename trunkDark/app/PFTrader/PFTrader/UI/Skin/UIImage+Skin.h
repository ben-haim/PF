#import <UIKit/UIKit.h>

@interface UIImage (NavigationBar)

+(UIImage*)secondBarBackground;
+(UIImage*)headerShadowImage;
+(UIImage*)thinShadowImage;
+(UIImage*)largeShadowImage;
+(UIImage*)headerDarkShadowImage;

@end

@interface UIImage (TextField)

+(UIImage*)textFieldBackground;
+(UIImage*)textFieldTopBackground;
+(UIImage*)textFieldBottomBackground;

@end

@interface UIImage (SearchField)

+(UIImage*)searchFieldIcon;

@end

@interface UIImage (Section)

+(UIImage*)sectionBackground;

@end

@interface UIImage (TreeView)

+(UIImage*)expandedIndicatorImage;
+(UIImage*)collapsedIndicatorImage;

@end

@interface UIImage (SegmentedControl)

+(UIImage*)leftSegmentBackground;
+(UIImage*)selectedLeftSegmentBackground;

+(UIImage*)centerSegmentBackground;
+(UIImage*)selectedCenterSegmentBackground;

+(UIImage*)rightSegmentBackground;
+(UIImage*)selectedRightSegmentBackground;

+(UIImage*)selectedSegmentBackground;
+(UIImage*)selectedSegmentClickBackground;

+(UIImage*)segmentBackground;

@end

@interface UIImage (Separator)

+(UIImage*)separatorShadow;
+(UIImage*)separatorBackground;
+(UIImage*)OESeparatorBackground;
+(UIImage*)menuSeparatorBackground;
+(UIImage*)chartSeparatorBackground;

@end

@interface UIImage (Buttons)

+(UIImage*)blueButtonBackground;
+(UIImage*)highlightedBlueButtonBackground;

+(UIImage*)greenButtonBackground;
+(UIImage*)highlightedGreenButtonBackground;

+(UIImage*)redButtonBackground;
+(UIImage*)highlightedRedButtonBackground;

+(UIImage*)grayButtonBackground;
+(UIImage*)highlightedGrayButtonBackground;

+(UIImage*)grayRoundButtonBackground;
+(UIImage*)highlightedGrayRoundButtonBackground;

+(UIImage*)transparentButtonBackground;
+(UIImage*)highlightedTransparentButtonBackground;

+(UIImage*)chartPeriodButtonBackground;
+(UIImage*)highlightedChartPeriodButtonBackground;

@end
