

#import "SelectionListViewController.h"

@implementation SelectionListViewController
@synthesize list;
@synthesize lastIndexPath;
@synthesize initialSelection;
@synthesize delegate;

-(IBAction)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)save
{
    //[self.delegate rowChosen:[lastIndexPath row]];
	[self.delegate rowChosen:selectedRow];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
- (id)initWithStyle:(UITableViewStyle)style
{
	selectedRow = -1;
    initialSelection = -1;
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	if (initialSelection > - 1 && initialSelection < [list count])
    {
		selectedRow = initialSelection;
        NSUInteger newIndex[] = {0, initialSelection};
        NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
        self.lastIndexPath = newPath;
        [newPath release];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
		[((UITableView *)[self view]) scrollToRowAtIndexPath:lastIndexPath
											atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)viewWillAppear:(BOOL)animated 
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:NSLocalizedString(@"OPTIONS_CANCEL", @"Cancel - for button to cancel changes")
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    [super viewWillAppear:animated];
}

- (void)dealloc 
{
    [list release];
    //[lastIndexPath release];
    [super dealloc];
}

#pragma mark -
#pragma mark Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *SelectionListCellIdentifier = @"SelectionListCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectionListCellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionListCellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger oldRow = selectedRow;//[lastIndexPath row];
	NSString *text = [[list objectAtIndex:row] description];
    [[cell textLabel] setText:text];
	if(row == oldRow && lastIndexPath != nil)
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    int newRow = [indexPath row];
    //int oldRow = [lastIndexPath row];
    //TODO: REMOVE NEW-OLD CHECK, FIX INITIAL SELECTION
    //if (newRow != oldRow)
    //{
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        lastIndexPath = indexPath;  
		selectedRow = newRow;
    //}
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	[self.delegate rowChosen:selectedRow];
    //[self.navigationController popViewControllerAnimated:YES];
}
@end
