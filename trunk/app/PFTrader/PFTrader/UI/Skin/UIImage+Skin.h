#import <UIKit/UIKit.h>

@interface UIImage (NavigationBar)

+(UIImage*)barButtonBackground;
+(UIImage*)highlightedBarButtonBackground;

+(UIImage*)backBarButtonBackground;
+(UIImage*)highlightedBackBarButtonBackground;

@end

@interface UIImage (TextField)

+(UIImage*)textFieldBackground;

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

@end

@interface UIImage (Separator)

+(UIImage*)separatorBackground;

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

+(UIImage*)borderedButtonBackgroundImage;
+(UIImage*)highlightedBorderedButtonBackgroundImage;

+(UIImage*)transparentButtonBackgroundImage;
+(UIImage*)highlightedTransparentButtonBackgroundImage;

@end
