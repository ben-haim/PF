#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFReportsViewController : PFTableViewController

@property ( nonatomic, weak ) IBOutlet UIButton* reportButton;

-(id)initWithAccount:( id< PFAccount > )account_;

-(IBAction)reportAction:( id )sender_;

@end
