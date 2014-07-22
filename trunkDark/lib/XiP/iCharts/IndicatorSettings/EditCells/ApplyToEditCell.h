
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface ApplyToEditCell : UITableViewCell <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource> 
{    
    IBOutlet UILabel *lblTitle;
    NSMutableArray *pickerViewArray;
    V8HorizontalPickerView *valueHPicker;
    PropertiesStore* properties;
    NSString* propertyPath;
}
-(void)SelectApplyTo:(uint)_apply_to_field;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, strong) NSString* propertyPath;
@property (nonatomic, strong) PropertiesStore* properties;
@end
