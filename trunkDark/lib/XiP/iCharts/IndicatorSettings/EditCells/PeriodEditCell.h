
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface PeriodEditCell : UITableViewCell <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource> 
{    
    IBOutlet UILabel *lblTitle;
    NSMutableArray *pickerViewArray;
    V8HorizontalPickerView *valueHPicker;
    PropertiesStore* properties;
    NSString* propertyPath;
    
    double min;
    double max;
    double step;
    uint digits;
}
-(void)SetMin:(uint)_min AndMax:(uint)_max;
-(void)SetInternalMin:(double)_min AndMax:(double)_max AndStep:(double)_step AndDigits:(uint)_digits;
-(void)SelectValue:(double)_value;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, strong) NSString* propertyPath;
@property (nonatomic, strong) PropertiesStore* properties;
@property (assign) double min;
@property (assign) double max;
@property (assign) double step;
@property (assign) uint digits;

@end
