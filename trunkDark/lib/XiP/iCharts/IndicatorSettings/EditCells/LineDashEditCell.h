
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface LineDashEditCell : UITableViewCell <V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource> 
{
    
    IBOutlet UILabel *lblTitle;
    V8HorizontalPickerView *valueHPicker;
    PropertiesStore* properties;
    NSString* propertyPath;
}
-(void)SelectDash:(uint)_dash;
@property (nonatomic, strong) UILabel *lblTitle;
//@property (nonatomic, retain) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) V8HorizontalPickerView* valueHPicker;
@property (nonatomic, strong) NSString* propertyPath;
@property (nonatomic, strong) PropertiesStore* properties;
@end
