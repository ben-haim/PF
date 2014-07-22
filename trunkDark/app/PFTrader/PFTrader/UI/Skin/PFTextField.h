#import <UIKit/UIKit.h>

typedef enum
{
   PFTextFieldBackgroundModeSingle = 0
   , PFTextFieldBackgroundModeTop = 1
   , PFTextFieldBackgroundModeBottom = 2
} PFTextFieldBackgroundMode;

@interface PFTextField : UITextField

@property ( nonatomic, assign ) PFTextFieldBackgroundMode backgroundMode;

@end

@interface PFSearchField : PFTextField

@end
