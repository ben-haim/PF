
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
@property (nonatomic, retain) UILabel *lblTitle;
//@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, retain) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, retain) NSString* propertyPath;
@property (nonatomic, retain) PropertiesStore* properties;
@end
