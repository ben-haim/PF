
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "Utils.h"

@interface PickerColorRenderer : UIView <V8HorizontalPickerElementState>
{
    NSArray *colors;
    bool isSelected;
    int item_index;
}
// element views should know how display themselves based on selected status
- (void)setSelectedElement:(BOOL)selected;
@property (nonatomic, retain) NSArray *colors;
@property (assign) bool isSelected;
@property (assign) int item_index;
@end
