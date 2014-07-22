#import "PFViewController.h"

@interface PFSNavigationViewController : UIViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* navigationView;
@property ( nonatomic, weak ) IBOutlet UIView* contentView;
@property ( nonatomic, weak ) IBOutlet UILabel* previousTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* currentTitleLabel;
@property ( nonatomic, weak ) IBOutlet UIImageView* arrowImage;

@property ( nonatomic, strong ) NSString* currentTitle;
@property ( nonatomic, assign ) BOOL isFirstInStack;

-(id)initWithRootController:( UIViewController* )controller_
    previousControllerTitle:( NSString* )previous_title_;

@end
