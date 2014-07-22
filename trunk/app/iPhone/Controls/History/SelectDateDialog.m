
#import "SelectDateDialog.h"


@implementation SelectDateDialog
@synthesize picker, storage, stage;
@synthesize actionLabel;
@synthesize txtDate;

/*
-(IBAction) dateChanged
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMMM dd, yyyy"];
	txtDate.text = [formatter stringFromDate:picker.date];
	[formatter release];
}*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}
-(void)SetStage:(int)_stage AndParams:( ParamsStorage *)_storage
{
	storage = _storage;
	stage = _stage;
	if(stage==1)
	{
		[self.navigationItem setTitle: NSLocalizedString(@"DATE_START", nil)];
		//[self.actionLabel setText:@"Start date:"];
		//actionLabel.text = @"SDFDFD";
	}
	else
	{
		[self.navigationItem setTitle: NSLocalizedString(@"DATE_END", nil)];
		//[self.actionLabel setText:@"End date:"];
	}
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
	
	//self.view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
	//self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"login_bg"]];
	//actionLabel.text = @"Start date:";
	
	//NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	//if (filepath) 
	//{
	//	UIImage *image = [UIImage imageNamed:@"logo_small.png"];
	//	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	//}
	
	//[self.navigationItem setTitle:@"Start date"];	
	UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_DONE", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneClicked:) ];
	//	[segmentedControl addTarget:vc action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	self.navigationItem.rightBarButtonItem = doneBtn;
   
   [ doneBtn release ];
	
	if(stage==1)
	{		
		[self.picker setDate:storage.history_start animated:NO];  
	}
	else
		if(stage==2)
		{		
			[self.picker setDate:storage.history_finish animated:NO];
		}
}

-(void)doneClicked:(id)sender
{
	//[self.navigationController popViewControllerAnimated:YES];
    NSDate *temp = [[self picker] date];
    NSLog(@"%@", [[self picker] date]);
	if(stage==1)
	{        
		storage.history_start = temp;
		//SelectDateDialog *dateDlg = [[SelectDateDialog alloc] initWithNibName:@"SelectDateDlg" bundle:nil];	
		//[self.navigationController pushViewController:dateDlg animated:YES];
		//[dateDlg SetStage:2 AndParams:storage];
		//[dateDlg release];
	}
	else
	{
		storage.history_finish = temp;
		//[self.navigationController popViewControllerAnimated:NO];
		//[self.navigationController popViewControllerAnimated:YES];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"dateDlgClosed" object:self];
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
