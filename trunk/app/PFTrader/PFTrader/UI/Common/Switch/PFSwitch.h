#import <UIKit/UIKit.h>

@interface PFSwitch : UIControl

@property ( nonatomic, assign, getter = isOn ) BOOL on;
@property ( nonatomic, strong ) NSString* onText;
@property ( nonatomic, strong ) NSString* offText;

-(void)setOn:( BOOL )on_ animated:( BOOL )animated_;

@end
