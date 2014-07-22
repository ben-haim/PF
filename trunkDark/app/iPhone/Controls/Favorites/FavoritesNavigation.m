

#import "FavoritesNavigation.h"
#import "MySingleton.h"


@implementation FavoritesNavigation
@synthesize doneButton, editButton;


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
    [super dealloc];
}


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
	editing = NO;
	//editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit  target:self action:@selector(toggleEdit:)];
	doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone  target:self action:@selector(toggleEdit:)];
	
	self.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
}


-(void)toggleEdit:(id)sender
{
	editing = !editing;	
	
	if(editing)
		self.navigationItem.leftBarButtonItem = doneButton;
	else
		self.navigationItem.leftBarButtonItem = editButton;
	
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}

@end
