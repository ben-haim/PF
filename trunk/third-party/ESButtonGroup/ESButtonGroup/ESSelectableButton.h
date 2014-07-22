#import <UIKit/UIKit.h>

@protocol ESSelectableButtonDelegate;

@interface ESSelectableButton : UIButton

@property ( nonatomic, strong ) id userInfo;
@property ( nonatomic, weak ) id< ESSelectableButtonDelegate > delegate;

+(id)selectableButton;

@end
