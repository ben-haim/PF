

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XiPFramework/Utils.h>


@interface SegPlotNavigation : UISegmentedControl 
{
    NSMutableArray *items;
	
	UIFont  *font;
	UIColor *selectedItemColor;
	UIColor *unselectedItemColor;
	
}
- (void)hide;
/**
 * Font for the segments with title
 * Default is sysyem bold 18points
 */
@property (nonatomic, retain) UIFont  *font;

/**
 * Color of the item in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *selectedItemColor;

/**
 * Color of the items not in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *unselectedItemColor;

@end
