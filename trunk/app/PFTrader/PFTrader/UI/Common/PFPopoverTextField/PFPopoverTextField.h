#import <UIKit/UIKit.h>

typedef void (^PFPopoverTextFieldDoneBlock)();

@interface PFPopoverTextField : UITextField

@property ( nonatomic, copy ) PFPopoverTextFieldDoneBlock doneBlock;

@end
