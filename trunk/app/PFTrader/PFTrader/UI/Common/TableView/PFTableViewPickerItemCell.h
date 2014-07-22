#import "PFTableViewItemCell.h"

#import <UIKit/UIKit.h>

@class PFBasePickerField;

@interface PFTableViewPickerItemCell : PFTableViewItemCell

@property ( nonatomic, strong ) IBOutlet PFBasePickerField* valueField;

@end
