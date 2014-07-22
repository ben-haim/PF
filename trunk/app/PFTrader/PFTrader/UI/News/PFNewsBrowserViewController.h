#import "PFViewController.h"

@protocol PFStory;

@interface PFNewsBrowserViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UIButton* nextButton;
@property ( nonatomic, strong ) IBOutlet UIButton* previousButton;
@property ( nonatomic, strong ) IBOutlet UIButton* refreshButton;

@property ( nonatomic, strong ) IBOutlet UIActivityIndicatorView* loadingView;

@property ( nonatomic, strong ) IBOutlet UIWebView* browserView;

-(id)initWithStory:( id< PFStory > )strory_;

-(IBAction)nextAction:( id )sender_;
-(IBAction)previousAction:( id )sender_;
-(IBAction)refreshAction:( id )sender_;

@end
