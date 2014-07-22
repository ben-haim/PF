#import "PFViewController.h"

@class PFMenuItem;

@interface PFGeneralMenuViewController : PFViewController < UITableViewDelegate, UITableViewDataSource >

@property ( nonatomic, weak ) IBOutlet UITableView* menuTable;
@property ( nonatomic, weak ) IBOutlet UIView* accountInfoView;
@property ( nonatomic, weak ) IBOutlet UILabel* accountTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* accountValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* balanceTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* balanceValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openNetPLTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openNetPLValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* marginTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* marginValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* marginAvailableTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* marginAvailableValueLabel;
@property ( nonatomic, weak ) IBOutlet UIButton* chatButton;
@property ( nonatomic, strong ) PFMenuItem* currentItem;

-(id)initWithMenuItems:( NSArray* )menu_items_;
-(void)updateMenuWithItems:( NSArray* )menu_items_;
-(IBAction)chatAction:( id )sender_;

@end
