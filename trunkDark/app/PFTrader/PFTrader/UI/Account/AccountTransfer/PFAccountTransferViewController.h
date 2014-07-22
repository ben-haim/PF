#import "PFTableViewController.h"

@protocol PFAccount;
@class PFSegmentedControl;
@class PFActionSheetButton;

@interface PFAccountTransferViewController : PFTableViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;
@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* modeSelector;
@property ( nonatomic, weak ) IBOutlet PFActionSheetButton* modeButton;
@property ( nonatomic, weak ) IBOutlet UIButton* submitButton;
@property ( nonatomic, strong ) id< PFAccount > sourceAccount;
@property ( nonatomic, strong ) id< PFAccount > targetAccount;

-(id)initWithAccount:( id< PFAccount > )account_;
-(void)updateTargetAccount;
-(IBAction)submitAction:( id )sender_;
-(IBAction)modeChangedAction:( id )sender_;

@end
