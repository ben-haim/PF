#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFSecureLogsController : PFTableViewController

@property ( strong, nonatomic ) IBOutlet UITextView* textView;

-(void)showReportWithDate:( NSDate* )date_;
+(BOOL)isAvailable;

@end
