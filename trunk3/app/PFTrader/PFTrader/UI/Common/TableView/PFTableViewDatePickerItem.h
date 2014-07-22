#import "PFTableViewBasePickerItem.h"

#import "PFDatePickerField.h"

#import <Foundation/Foundation.h>

@interface PFTableViewDatePickerItem : PFTableViewBasePickerItem< PFDatePickerFieldDelegate >

@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign ) UIDatePickerMode dateMode;
@property ( nonatomic, assign ) BOOL fromTodayMode;

@end
