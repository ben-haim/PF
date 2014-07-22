#import "PFTableViewController.h"

@protocol PFAccount;

@interface PFSecureLogsController : PFTableViewController

@property ( nonatomic, weak ) IBOutlet UITextView* textView;
@property ( nonatomic, weak ) IBOutlet UIImageView* textViewBackground;

-(void)showReportWithDate:( NSDate* )date_;
+(BOOL)isAvailable;

@end
