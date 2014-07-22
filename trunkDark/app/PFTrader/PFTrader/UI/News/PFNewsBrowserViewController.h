#import "PFViewController.h"

@protocol PFStory;

@interface PFNewsBrowserViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UIActivityIndicatorView* loadingView;
@property ( nonatomic, weak ) IBOutlet UIWebView* browserView;

-(id)initWithStory:( id< PFStory > )strory_;

@end
