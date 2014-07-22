
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface LineWidthEditCell : UITableViewCell <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource> 
{
    
    IBOutlet UILabel *lblTitle;
    V8HorizontalPickerView *valueHPicker;
    PropertiesStore* properties;
    NSString* propertyPath;
}
-(void)SelectWidth:(uint)_width;
@property (nonatomic, strong) UILabel *lblTitle;
//@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, strong) NSString* propertyPath;
@property (nonatomic, strong) PropertiesStore* properties;
@end
