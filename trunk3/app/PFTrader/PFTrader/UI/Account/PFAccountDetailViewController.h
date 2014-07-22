#import "PFTableViewController.h"

#import <UIKit/UIKit.h>

@class PFSegmentedControl;

@protocol PFAccount;

@interface PFAccountDetailViewController : PFTableViewController

@property ( nonatomic, strong ) IBOutlet UIView* footerView;
@property ( nonatomic, strong ) IBOutlet UIView* headerView;
@property ( nonatomic, strong ) IBOutlet PFSegmentedControl* informationSwitchBox;
@property ( strong, nonatomic ) IBOutlet UIButton* makeActiveButton;
@property ( strong, nonatomic ) IBOutlet UIButton* withdrawalButton;
@property ( strong, nonatomic ) IBOutlet UIButton* transferButton;
@property ( nonatomic, strong ) IBOutlet PFTableView* assetsTable;

@property ( nonatomic, weak ) UINavigationController* parentNavigation;

+(id)detailControllerWithAccount:( id< PFAccount > )account_;

-(IBAction)makeActiveAction:( id )sender_;
-(IBAction)withdrawalAction:( id )sender_;
-(IBAction)transferAction:( id )sender_;

@end
