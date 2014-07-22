#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFReportsViewController : PFTableViewController

@property (strong, nonatomic) IBOutlet UIButton* reportButton;

-(id)initWithAccount:( id< PFAccount > )account_;

-(IBAction)reportAction:( id )sender_;

@end
