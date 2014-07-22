#import <UIKit/UIKit.h>

@protocol ESSelectableButtonDelegate;

@interface ESSelectableButton : UIButton

@property ( nonatomic, strong ) id userInfo;
@property ( nonatomic, unsafe_unretained ) id< ESSelectableButtonDelegate > delegate;

+(id)selectableButton;

@end
