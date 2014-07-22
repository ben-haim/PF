#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFWithdrawalViewController : PFTableViewController

@property (strong, nonatomic) IBOutlet UIButton* submitButton;

-(IBAction)submitAction:( id )sender_;

-(id)initWithAccount:( id< PFAccount > )account;

@end
