

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#import "../Plot/Utils.h"
#import "ToolbarDefines.h"

@protocol ChartNotificationsDelegate;
@class ToolbarButton;
@interface ToolbarButtonSegment : NSObject 
{
    BOOL                isDown; //0 - up, 1 - down
    BOOL                isVisible;
	uint                action;
	NSString*           text;
    UIImage*            image;
    NSMutableArray*     subsegments;
    uint                selectedSegmentTag;
    uint                rows_count;
    uint                cols_count;
    id <ChartNotificationsDelegate>  tb_delegate;
    ToolbarButton*      btn;
} 
- (void)drawInContext:(CGContextRef)ctx 
                        InRect:(CGRect)rect  
                        IconXOffset:(int)offset
                        Line1px:(float)line1px
                        AndSeparatorIsShown:(BOOL)isSeparatorShown
                        IsSelected:(BOOL)isSelected;
- (ToolbarButtonSegment *) addSubSegment:(uint)Action WithText:(NSString*)Text AndImage:(UIImage*)Image;
- (ToolbarButtonSegment *) GetSegmentWithAction:(uint)_action;

@property( assign) BOOL isDown;
@property( assign) BOOL isVisible;
@property( assign) uint action;
@property( nonatomic, retain) NSString *text;
@property( nonatomic, retain) UIImage *image;
@property( nonatomic, retain) NSMutableArray *subsegments;
@property( assign) uint selectedSegmentTag;
@property( assign) uint rows_count;
@property( assign) uint cols_count;
@property( assign) id tb_delegate;
@property( assign) ToolbarButton* btn;
@end

