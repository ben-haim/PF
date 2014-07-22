
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
@property (nonatomic, retain) UILabel *lblTitle;
@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, retain) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, retain) NSString* propertyPath;
@property (nonatomic, retain) PropertiesStore* properties;
@end
