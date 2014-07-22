#import "PFViewController.h"

@protocol PFReportTable;

@interface PFEventBrowserViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UIButton* nextButton;
@property ( nonatomic, weak ) IBOutlet UIButton* previousButton;

@property ( nonatomic, weak ) IBOutlet UIActivityIndicatorView* loadingView;
@property ( nonatomic, weak ) IBOutlet UIWebView* browserView;

-(id)initWithReport:( id< PFReportTable > )report_;

@end
