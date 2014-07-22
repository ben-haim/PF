
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface ColorEditCell : UITableViewCell <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource> 
{
    
    IBOutlet UILabel *lblTitle;
    V8HorizontalPickerView *valueHPicker;
    PropertiesStore* properties;
    NSString* propertyPath;
}
-(void)SelectColor:(uint)_color;
@property (nonatomic, retain) UILabel *lblTitle;
//@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, retain) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, retain) NSString* propertyPath;
@property (nonatomic, retain) PropertiesStore* properties;
@end
