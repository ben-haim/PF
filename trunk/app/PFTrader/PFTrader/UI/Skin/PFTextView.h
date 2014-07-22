#import <UIKit/UIKit.h>

@interface PFTextView : UIView

@property ( nonatomic, strong ) UIImage* background;
@property ( nonatomic, strong ) NSString* text;
@property ( nonatomic, strong ) NSString* placeholder;
@property ( nonatomic, assign, readonly ) CGSize contentSize;
@property ( nonatomic, weak ) IBOutlet id< UITextViewDelegate > delegate;

@property ( nonatomic, assign ) BOOL bounces;

@end
