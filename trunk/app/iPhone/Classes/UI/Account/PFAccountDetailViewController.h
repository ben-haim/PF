#import <UIKit/UIKit.h>

@protocol PFAccount;

@interface PFAccountDetailViewController : UITableViewController

@property ( nonatomic, strong ) IBOutlet UIView* headerView;
@property ( nonatomic, strong ) IBOutlet UISegmentedControl* informationSwitchBox;

+(id)detailControllerWithAccount:( id< PFAccount > )account_;

-(IBAction)informationSwitchAction:( id )sender_;

@end
