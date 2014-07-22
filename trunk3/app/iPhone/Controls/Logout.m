

#import "Logout.h"
#import "iTraderAppDelegate.h"


@implementation Logout

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)viewWillAppear:(BOOL)animated
{
	//[self.navigationController popViewControllerAnimated:YES];
	
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	//[[appDelegate mainView] setSelectedIndex:0];
	[appDelegate logout];
	
	
	/*int i=-1;
	for (UIViewController *aController in [[appDelegate mainView] viewControllers]) 
	{
		i++;
		if ([aController.title isEqualToString:NSLocalizedString(@"EXIT_EXIT", nil)] || [aController.title isEqualToString:NSLocalizedString(@"EXIT_LOGOUT", nil)])
		{
			continue;
			
		//	[[appDelegate mainView] setSelectedIndex:i];
		//	NSLog(@"%@", aController.title);
		//	return;
		}
		//if (!)
		//{
			[[appDelegate mainView] setSelectedIndex:i];
			NSLog(@"%@", aController.title);
			return;
		//}
		
	}*/
}

- (void)viewDidAppear:(BOOL)animated
{
	[self.navigationController popViewControllerAnimated:YES];
}
 

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
    [super dealloc];
}


@end
