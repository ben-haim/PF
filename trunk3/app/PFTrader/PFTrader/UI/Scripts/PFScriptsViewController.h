#import "PFViewController.h"

@interface PFScriptsViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UIWebView* scriptsView;
@property ( nonatomic, strong ) IBOutlet UIActivityIndicatorView* loadingIndicator;

+(BOOL)isAvailable;

@end
