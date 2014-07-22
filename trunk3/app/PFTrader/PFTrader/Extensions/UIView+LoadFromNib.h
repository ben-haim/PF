#import <UIKit/UIKit.h>

@interface UIView (LoadFromNib)

+(id)viewAsFirstObjectFromNibNamed:( NSString* )nib_name_;
+(id)viewAsFileOwnerFromNibNamed:( NSString* )nib_name_;

@end
