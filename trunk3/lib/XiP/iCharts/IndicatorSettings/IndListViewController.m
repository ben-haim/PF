
#import "IndListViewController.h"
#import "PropertiesStore.h"

#define iPAD 1

@implementation IndListViewController
@synthesize default_properties, tableIndList, rootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [tableIndList release];
    [default_properties release];

    tableIndList = nil;
    default_properties = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil)
                                                                       style:UIBarButtonItemStyleBordered 
                                                                      target:self 
                                                                      action:@selector(close)];
        [[self navigationItem] setLeftBarButtonItem:backButton];
        [backButton release];
        [[self navigationController] navigationBar].tintColor = [UIColor colorWithRed:81.0/255 green:98.0/255.0 blue:113.0/255.0 alpha:1.0];
        [[self navigationItem] setTitle:NSLocalizedString(@"chart_indicators", nil)];
#ifdef iPAD
		if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"] forBarMetrics:UIBarMetricsDefault];
        }
#endif
    }
}

- (void)close
{
    [self dismissModalViewControllerAnimated:YES]; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == self.rootViewController.interfaceOrientation;
}

- (void)ShowIndicators:(PropertiesStore*)def_store
{
    if(default_properties)
        [default_properties release];
    [self setDefault_properties:def_store];
}
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [[default_properties getArray:@"indicators.order"] count]; 
}
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    NSString *CellText = nil;
    NSArray *indicators = [default_properties getArray:@"indicators.order"];
    
    NSString *indPropPath = [NSString stringWithFormat:@"indicators.%@.title", 
                             [indicators objectAtIndex:indexPath.row]];
    CellText = NSLocalizedString([default_properties getParam:indPropPath], "ind localized title");
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero 
//                                       reuseIdentifier:CellIdentifier] autorelease];
    }    
    cell.textLabel.text = CellText;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *indicators = [default_properties getArray:@"indicators.order"];    
    NSString *indID = [indicators objectAtIndex:indexPath.row];    
    [self dismissModalViewControllerAnimated:YES]; 
	[[NSNotificationCenter defaultCenter] postNotificationName:@"indListSelected" object:indID];
}

@end
