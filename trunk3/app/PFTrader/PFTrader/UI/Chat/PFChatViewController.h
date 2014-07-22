#import "PFViewController.h"

@class PFTextView;

@interface PFChatViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet PFTextView* messageTextView;
@property ( nonatomic, strong ) IBOutlet UIView* contentView;
@property ( nonatomic, strong ) IBOutlet UITableView* tableView;
@property ( nonatomic, strong ) IBOutlet UIView* messagePanelView;
@property (strong, nonatomic) IBOutlet UIButton* sendButton;

-(IBAction)sendAction:( id )sender_;

+(BOOL)isAvailable;

@end
