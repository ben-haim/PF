#import "PFButton.h"

#import <UIKit/UIKit.h>

typedef NSString* (^PFActionChoiceToStringBlock)( id choice_ );
typedef UIImage* (^PFActionChoiceToImageBlock)( id choice_ );

@interface PFActionSheetButton : UIControl

@property ( nonatomic, assign ) IBOutlet UIView* presenterView;

@property ( nonatomic, strong ) UIImage* image;
@property ( nonatomic, strong, readonly ) UIButton* button;

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, strong ) NSString* prompt;

@property ( nonatomic, strong ) NSArray* choices;
@property ( nonatomic, strong ) id currentChoice;

@property ( nonatomic, copy ) PFActionChoiceToStringBlock toStringBlock;
@property ( nonatomic, copy ) PFActionChoiceToImageBlock toImageBlock;


@end
