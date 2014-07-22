#import "PFBasePickerField.h"

@interface PFDatePickerField : PFBasePickerField

@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign ) UIDatePickerMode dateMode;
@property ( nonatomic, assign ) BOOL fromTodayMode;

@end

@protocol PFDatePickerFieldDelegate <PFBasePickerFieldDelegate>

-(void)pickerField:( PFDatePickerField* )picker_field_
     didSelectDate:( NSDate* )date_;

@end

