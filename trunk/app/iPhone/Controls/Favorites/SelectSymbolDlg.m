
#import "SelectSymbolDlg.h"
#import "CustomAlert.h"


@implementation SelectSymbolDlg

@synthesize storage;
// The designated initializer. Override to perform setup that is required before the view is loaded.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
 {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
 {
 //this is the label on the tab button itself
 self.title = @"Prefs";
 
 //use whatever image you want and add it to your project
 self.tabBarItem.image = [UIImage imageNamed:@"prefs_icon.png"];
 
 // set the long name shown in the navigation bar
 self.navigationItem.title=@"Preferences";
 }
 return self;
 }


/*-(void)loadView 
 {
 //[[self view] setBackgroundColor:[UIColor darkGrayColor ]];
 //UIView *firstView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
 //[firstView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
 //[firstView setBackgroundColor:[UIColor]];
 //self.view = firstView;
 //[firstView release];
 }
/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


- (void)viewDidLoad {
    [super viewDidLoad];
	skips = 0;
}
/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
-(void)rebind
{
	if(self.editing)
		return;
	[self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(storage==nil)
		return 0;
	int cnt = [[storage SymGroups] count];
    return (cnt==0)?1:cnt;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(storage==nil)
		return nil;
	int cnt = [[storage SymGroups] count];
	if(storage==nil || section > (cnt-1))
		return nil;
	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];
	return sg.name;
}
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	if(storage==nil)
		return 0;
	int cnt = [[storage SymGroups] count];
	if(storage==nil || section > (cnt-1))
		return 0;
	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];	
    return [[sg symbols] count];
}





// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"Cell";
		
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	int section= indexPath.section;	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];
	NSArray *syms = [sg symbols];
	
	SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:indexPath.row];
	
	/*NSEnumerator *enumerator = [[storage FavSymbols] objectEnumerator];
	NSString* value;
	while ((value = [enumerator nextObject])) 
	{
		//NSLog(@"value: %@ -", value);
		if ([value isEqualToString:si.Symbol])
		{
			[FavSymbols addObject:value];
		}
	} */
/*	for (int i=0; i<[FavSymbols count]; i++)
	{
		if ([[[storage FavSymbols] objectAtIndex:i] isEqualToString:si.Symbol])
		{
			skips++;
			si = (SymbolInfo *)[syms objectAtIndex:indexPath];
		}
	}*/
	
	cell.textLabel.text = si.Symbol;
	return cell;

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{
    int section= indexPath.section;	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];
	NSArray *syms = [sg symbols];	
	SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:indexPath.row];
	for (int i=0; i<[[storage FavSymbols] count]; i++)
	{
		if ([[[storage FavSymbols] objectAtIndex:i] isEqualToString:si.Symbol])
		{
			CustomAlert *alert = [[CustomAlert alloc] initWithTitle:si.Symbol
															message:NSLocalizedString(@"FAVORITES_ALREADY_EXISTS", nil)  
														   delegate:self 
												  cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			return;
		}
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"symbolDlgSelected" object:si.Symbol];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
 {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) 
 {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) 
 {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [super dealloc];
}


@end

