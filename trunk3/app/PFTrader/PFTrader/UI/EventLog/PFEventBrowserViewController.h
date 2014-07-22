#import "PFViewController.h"

@protocol PFReportTable;

@interface PFEventBrowserViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UIButton* nextButton;
@property ( nonatomic, strong ) IBOutlet UIButton* previousButton;

@property ( nonatomic, strong ) IBOutlet UIActivityIndicatorView* loadingView;
@property ( nonatomic, strong ) IBOutlet UIWebView* browserView;

-(id)initWithReport:( id< PFReportTable > )report_;

-(IBAction)nextAction:( id )sender_;
-(IBAction)previousAction:( id )sender_;

@end
