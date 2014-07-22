#import <UIKit/UIKit.h>

@class PFMenuItem;
@class PFBadgeView;

@interface PFMenuCell : UITableViewCell

@property ( nonatomic, weak ) IBOutlet UIButton* menuButton;
@property ( nonatomic, weak ) IBOutlet UILabel* menuTitleLabel;
@property ( nonatomic, weak ) IBOutlet PFBadgeView* badgeView;
@property ( nonatomic, strong ) PFMenuItem* menuItem;
@property ( nonatomic, weak ) UIViewController* menuController;

+(id)cell;

-(IBAction)menuAction:( id )sender_;

@end
