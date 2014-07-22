
#import "ExitViewCtrl.h"
#import "CustomAlert.h"
#import "iTraderAppDelegate.h"


@implementation ExitViewCtrl

@synthesize btnLogout, btnExit;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[btnExit setTitle:NSLocalizedString(@"EXIT_QUIT", nil)   forState:UIControlStateNormal];
	[btnExit setTitle:NSLocalizedString(@"EXIT_QUIT", nil)   forState:UIControlStateHighlighted];
	
	[btnLogout setTitle:NSLocalizedString(@"EXIT_LOGOUT", nil)   forState:UIControlStateNormal];
	[btnLogout setTitle:NSLocalizedString(@"EXIT_LOGOUT", nil)   forState:UIControlStateHighlighted];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[btnLogout release];
	[btnExit release];
    [super dealloc];
}

- (IBAction)exitClicked:(id)sender
{
	if (isLogoutRequest)
		return;
	
	isExitRequest = YES;
	exitCounter = 0;
	alert = [[CustomAlert alloc] initWithTitle:[NSLocalizedString(@"EXIT_QUIT_TITLE", nil)   stringByAppendingString:@" 5"]
									   message:NSLocalizedString(@"EXIT_QUIT_MSG", nil)   
									  delegate:self 
							 cancelButtonTitle: NSLocalizedString(@"OPTIONS_CANCEL", nil)
							 otherButtonTitles: nil];
	
	[alert show];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownForQuit) userInfo:nil repeats:YES];
}

- (IBAction)logoutClicked:(id)sender
{
	if (isExitRequest)
		return;
	
	logoutCounter = 0;
	alert = [[CustomAlert alloc] initWithTitle:[NSLocalizedString(@"EXIT_LOGOUT_TITLE", nil)   stringByAppendingString:@" 5"]
									   message:NSLocalizedString(@"EXIT_LOGOUT_MSG", nil)  
									  delegate:self 
							 cancelButtonTitle: NSLocalizedString(@"OPTIONS_CANCEL", nil)
							 otherButtonTitles: nil];
	
	[alert show];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownForLogout) userInfo:nil repeats:YES];
}

- (void)countDownForQuit
{
	exitCounter++;
	if(exitCounter>=5)
	{
		[alert dismissWithClickedButtonIndex:0 animated:TRUE];	
		[timer invalidate];
		timer = nil;
		[alert release];
		exit(0);
	}
	else
	{
		NSString *Title  = [[NSString alloc] initWithFormat:[@"Shutting down in" stringByAppendingString:@" %d"], (5 - exitCounter)];
		[alert setTitle:Title];
		[Title release];
	}
}

- (void)countDownForLogout
{
	logoutCounter++;
	if(logoutCounter>=5)
	{
		[alert dismissWithClickedButtonIndex:0 animated:TRUE];	
		[timer invalidate];
		timer = nil;
		[alert release];
		//exit(0);
		
		
		iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
		[[appDelegate mainView] setSelectedIndex:0];
		[appDelegate logout];
		
	}
	else
	{
		NSString *Title  = [[NSString alloc] initWithFormat:[@"Logging out in" stringByAppendingString:@" %d"], (5 - logoutCounter)];
		[alert setTitle:Title];
		[Title release];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(timer==nil)
		return;
	
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];	
	
	[timer invalidate];
	timer = nil;
	[alert release];
	
	isExitRequest = NO;
	isLogoutRequest = NO;
	
	//[self.navigationController popViewControllerAnimated:YES];
}

@end
