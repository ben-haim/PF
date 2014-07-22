
#import "OpenPosNavigation.h"


@implementation OpenPosNavigation
@synthesize vc;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}


// The designated initializer. Override to perform setup that is required before the view is loaded.
/*- (id)init
{
    if (self = [super init]) 
	{
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
												[NSArray arrayWithObjects:
												 @"All",
												 @"Instant",
												 nil]];
		//[segmentedControl addTarget:self action:@selector(segmentAction forControlEvents:UIControlEventValueChanged];
		 segmentedControl.frame = CGRectMake(0, 0, 90, 40);
		 segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		 segmentedControl.momentary = YES;
		 [segmentedControl setTintColor:[UIColor blackColor]];
		 
		 UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
		self.navigationItem.rightBarButtonItem = segmentBarItem; 
    }
    return self;
}*/


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 @"All",
											 @"Open",
											 nil]];
	[segmentedControl addTarget:vc action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.selectedSegmentIndex = 0;

	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;


	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	self.navigationItem.rightBarButtonItem = segmentBarItem; 
	
	self.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



@end
