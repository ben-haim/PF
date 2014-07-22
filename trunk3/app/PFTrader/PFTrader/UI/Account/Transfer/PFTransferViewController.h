#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFTransferViewController : PFTableViewController

@property ( nonatomic, strong ) id< PFAccount > sourceAccount;
@property ( nonatomic, strong ) id< PFAccount > targetAccount;

@property (strong, nonatomic) IBOutlet UIButton* submitButton;

-(IBAction)submitAction:( id )sender_;

-(id)initWithAccount:( id< PFAccount > )account_;
-(void)updateTargetAccount;

@end
