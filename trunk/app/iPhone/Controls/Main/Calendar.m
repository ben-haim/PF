
#import "Calendar.h"


@implementation Calendar
@synthesize webView;
/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	

    [super viewDidLoad];
	webView.delegate = self;

	//[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.8;"];

	
	[self refreshClicked:NULL];
    
	self.tabBarController.moreNavigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	self.navigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	self.navigationItem.title = NSLocalizedString(@"TABS_CALENDAR", nil);
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
	
	UIBarButtonItem *btnReload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
	
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
	self.navigationItem.rightBarButtonItem = btnReload; 
	[btnReload release];
	
}
//TODO: Provide a url to your forex calendar
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	NSURL *requestURL= [request URL];
	NSString * urlString = [requestURL absoluteString];
	if( [urlString isEqualToString: @"http://www.cocacola.com/calendar.html"])
	{
		return YES;
	}
	
		return NO;	
}
- (void)webViewDidStartLoad:(UIWebView *)webView 
{
	activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activity.center = self.view.center;
	activity.tag = 999;
	activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | 
	UIViewAutoresizingFlexibleTopMargin | 
	UIViewAutoresizingFlexibleRightMargin | 
	UIViewAutoresizingFlexibleBottomMargin;
	
	[self.view addSubview:activity];
	
	
	
	[activity startAnimating];
	//[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.8;"];
	[activity release];	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	//[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none'; document.body.style.webkiTUserSelect='none'" ];

	
	//[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 0.8;"];
		UIView *v = [self.view viewWithTag:999];
	[v removeFromSuperview];
	
}
//TODO: Provide a url to your forex calendar
-(void)refreshClicked:(id)sender
{	
	NSURL *url = [NSURL URLWithString:@"http://www.cocacola.com/calendar.html"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	
	webView.scalesPageToFit = YES;

}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
