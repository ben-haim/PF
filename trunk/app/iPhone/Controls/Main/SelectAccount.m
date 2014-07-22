
#import "SelectAccount.h"
#import "iTraderAppDelegate.h"


@implementation SelectAccount

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewDidLoad
{
	self.tableView.rowHeight = 70;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil)
																   style:UIBarButtonItemStyleBordered
																  target:self 
																  action:@selector(back:)];
	
	[[self navigationItem] setLeftBarButtonItem:backButton];
	[backButton release];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_EDIT", nil)
																   style:UIBarButtonItemStyleBordered
																  target:self 
																  action:@selector(editStarted:)];
	
	[[self navigationItem] setRightBarButtonItem:editButton];
	[editButton release];	
}

-(IBAction) back:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"accountDlgClosed" object:self];
}

-(IBAction) editStarted:(id)sender
{
	[super setEditing:YES animated:YES];
	[self.tableView setEditing:YES animated:YES];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_DONE", nil)
																   style:UIBarButtonItemStyleDone
																  target:self 
																  action:@selector(editEnded:)];
	
	[[self navigationItem] setRightBarButtonItem:editButton];
	[editButton release];
}

-(IBAction) editEnded:(id)sender
{
	[super setEditing:NO animated:YES];
	[self.tableView setEditing:NO animated:YES];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_EDIT", nil)
																   style:UIBarButtonItemStyleDone
																  target:self 
																  action:@selector(editStarted:)];
	
	[[self navigationItem] setRightBarButtonItem:editButton];
	[editButton release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath 
{
	
	int pos = proposedDestinationIndexPath.row;
	int cnt = [accountData count];	
	if(pos<cnt)
		return proposedDestinationIndexPath;
	else
		return [NSIndexPath indexPathForRow:cnt-1 inSection:0];
}

// Process the row move. This means updating the data model to correct the item indices.

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{
	
	NSString *item = [[accountData objectAtIndex:fromIndexPath.row] retain];
	[accountData removeObject:item];
	[accountData insertObject:item atIndex:toIndexPath.row];
	[item release];
	
	[storage saveAccounts:accountData];
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
		[accountData removeObjectAtIndex:indexPath.row];
		[[appDelegate storage] saveAccounts:accountData];		
		
		if ([accountData count]==0)
			[[NSNotificationCenter defaultCenter] postNotificationName:@"accountDlgClosed" object:self];
		else
			[self.tableView reloadData];

	}

}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [accountData count];
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AccountCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
		
	NSString *strAccount = [accountData objectAtIndex:indexPath.row];
	NSArray *accInfo = [strAccount componentsSeparatedByString:@"\0"];	
	
	cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [[[accInfo objectAtIndex:0] stringByAppendingString:@"\n"] stringByAppendingString:[accInfo objectAtIndex:2]];
	[cell.textLabel setFrame:CGRectMake(cell.textLabel.bounds.origin.x+5, cell.textLabel.bounds.origin.y,
										cell.textLabel.bounds.size.width, cell.textLabel.bounds.size.height)];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //ServerInfo *si = [storage.Servers objectAtIndex:indexPath.row];
	NSString *strAccount = [accountData objectAtIndex:indexPath.row];
	NSArray *accInfo = [strAccount componentsSeparatedByString:@"\0"];	
	
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[appDelegate storage] setSelected_server:[NSString stringWithFormat:@"%@", [accInfo objectAtIndex:2]]];
	[[appDelegate storage] loadFavorites];
	//[storage setSelected_server:[NSString stringWithFormat:@"%@", [accInfo objectAtIndex:2]]];
	storage.login = [accInfo objectAtIndex:0];
	storage.password = [accInfo objectAtIndex:1];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"accountDlgClosed" object:self];
	[accountData release];
}

-(void)SetAccounts:(ParamsStorage*)_storage
{
	storage = _storage;
	accountData = [storage getSavedAccounts];
}

- (void)dealloc {
    [super dealloc];
}


@end
