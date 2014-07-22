
#import "MailView.h"
#import "iFXWebView.h"


@implementation MailView
@synthesize webView, mailIndex;
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
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DELETE", nil)
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self 
                                                                    action:@selector(deleteMail)];
	[[self navigationItem] setRightBarButtonItem:deleteButton];
	[deleteButton release];
    
    [self setMailIndex:-1];
}

- (void)deleteMail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMail" object:[NSNumber numberWithInteger:mailIndex]];
    [[self navigationController] popViewControllerAnimated:YES];
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

-(void) showMailBody:(NSString*)htmlBody withIndex:(NSInteger)index
{	
	//NSLog(@"%@", htmlBody);
	[webView loadHTMLString:htmlBody baseURL:[NSURL URLWithString:@""]];
	[webView setScalesPageToFit:YES];
	[webView setMultipleTouchEnabled:YES];
    
    [self setMailIndex:index];
}

-(void) showMailData:(NSData*)htmlBody withIndex:(NSInteger)index
{	
    [webView setScalesPageToFit:YES];
	[webView setMultipleTouchEnabled:YES];
	//NSLog(@"%@", htmlBody);
    [webView loadData:htmlBody MIMEType:@"text/html" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
    
    [self setMailIndex:index];
}

@end
