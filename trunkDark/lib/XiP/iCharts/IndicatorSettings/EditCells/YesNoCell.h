
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"

@class PropertiesStore;

@interface YesNoCell : UITableViewCell
{    
    IBOutlet UILabel *lblTitle;
    PropertiesStore* properties;
    NSString* propertyPath;
    IBOutlet UISwitch *swYesNo;
}
-(void)SelectBool:(uint)_bool_value;
- (IBAction)valueChanged:(id)sender;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) NSString* propertyPath;
@property (nonatomic, strong) PropertiesStore* properties;
@end
