
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "Utils.h"

@interface LineDashRenderer : UIView <V8HorizontalPickerElementState>
{
    bool isSelected;
    int item_index;
}
// element views should know how display themselves based on selected status
- (void)setSelectedElement:(BOOL)selected;
@property (assign) bool isSelected;
@property (assign) int item_index;
@end
