#import "PFTableViewController.h"

#import <UIKit/UIKit.h>

@interface PFSettingsViewController : PFTableViewController

@property ( nonatomic, strong ) IBOutlet UIButton* changePasswordButton;

-(IBAction)changePasswordAction:( id )sender_;

@end
