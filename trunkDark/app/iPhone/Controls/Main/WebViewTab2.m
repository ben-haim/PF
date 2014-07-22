
#import "WebViewTab2.h"


@implementation WebViewTab2

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
	
	self.navigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	self.tabBarController.moreNavigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath)
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}

	NSString *urlAddress = @"";
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	UIBarButtonItem *btnReload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)];
	
	self.navigationItem.rightBarButtonItem = btnReload; 
	[btnReload release];
	
	
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
	[activity release];	
}
- (void)webViewDidFinishLoad:(UIWebView *)webView 
{
	UIView *v = [self.view viewWithTag:999];
	[v removeFromSuperview];
	
}

-(void)refreshClicked:(id)sender
{
	[webView reload];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
