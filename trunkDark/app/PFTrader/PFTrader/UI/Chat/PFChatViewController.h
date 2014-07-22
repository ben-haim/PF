#import "PFViewController.h"

@class PFTextView;

@interface PFChatViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet PFTextView* messageTextView;
@property ( nonatomic, weak ) IBOutlet UIView* contentView;
@property ( nonatomic, weak ) IBOutlet UITableView* tableView;
@property ( nonatomic, weak ) IBOutlet UIView* messagePanelView;
@property ( nonatomic, weak ) IBOutlet UIButton* sendButton;

-(IBAction)sendAction:( id )sender_;

+(BOOL)isAvailable;

@end
