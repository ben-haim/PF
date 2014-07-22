
#import "FavoritesEditCtl.h"
#import "TradePaneController.h"
#import "MarketWatchCell.h"
#import "SelectSymbolDlg.h"

@implementation FavoritesEditCtl
@synthesize storage, FavSymbols;
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
 }*/


/*-(void)loadView 
 {
 //[[self view] setBackgroundColor:[UIColor darkGrayColor ]];
 //UIView *firstView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
 [firstView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
 [firstView setBackgroundColor:[UIColor]];
 self.view = firstView;
 [firstView release];
 }*/

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.tableView.rowHeight = 60;
	[super setEditing:YES animated:YES];
	[self.tableView setEditing:YES animated:YES];
	FavSymbols = [[NSMutableArray alloc] init];
	
	NSEnumerator *enumerator = [storage.FavSymbols objectEnumerator];
	id value;
	
	while ((value = [enumerator nextObject])) 
	{
        SymbolInfo *si = (SymbolInfo *)[[storage Symbols] objectForKey:(NSString*)value];
		
		if (si != nil)
        {
            NSString *sym_copy = [NSString stringWithFormat:@"%@", (NSString*)value];
            [FavSymbols addObject:sym_copy];
        }
	}

	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_DONE", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.navigationItem setLeftBarButtonItem:addButton];
	//UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(DeleteButtonAction:)];
	//[self.navigationItem setLeftBarButtonItem:deleteButton];
	[addButton release];
	//[deleteButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(symbolDlgSelected:)
												 name:@"symbolDlgSelected" object:nil];	
	
	tradePane = [[TradePaneController alloc] initWithNibName:@"SymbolTrade" bundle:nil];	
	tradePane.storage = storage;
	[tradePane setMytype:TRADE_PANE_FAVORITES];
	[tradePane retain];
}

- (void)symbolDlgSelected:(NSNotification *)notification
{
	NSString *symbol_selected = (NSString *)[notification object];
	[self.navigationController popToViewController:self animated:YES];
	
	[FavSymbols insertObject:symbol_selected atIndex:[FavSymbols count]];
	[self.tableView reloadData];
}
- (IBAction) EditTable:(id)sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"customizationEnded" object:nil];
	/*if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[self.tableView setEditing:NO animated:NO];
		[self.tableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
	}
	else
	{
		[super setEditing:YES animated:YES];
		[self.tableView setEditing:YES animated:YES];
		[self.tableView reloadData];
		[self.navigationItem.leftBarButtonItem setTitle:@"Done"];
		[self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
	}*/
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return NO;
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
-(void)rebind
{
	if(self.editing)
		return;
	[self.tableView reloadData];
}


-(void)SymbolUpdated:(NSString*)symbol
{
	if(self.editing)
		return;
	[self.tableView reloadData];
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
	int count = [FavSymbols count];
	if(self.editing) count++;
	return count;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	// No editing style if not editing or the index path is nil.
	if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
	// Determine the editing style based on whether the cell is a placeholder for adding content or already
	
	// existing content. Existing content can be deleted.
	
	if (self.editing && indexPath.row == ([FavSymbols count])) 
	{
		return UITableViewCellEditingStyleInsert;
		
	} else 
	{
		return UITableViewCellEditingStyleDelete;
	}
	return UITableViewCellEditingStyleNone;
}

// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		[FavSymbols removeObjectAtIndex:indexPath.row];
		[self.tableView reloadData];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) 
	{
		
		/*	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Specify instrument name" message:@""
		 delegate:self cancelButtonTitle:@"Cancel"
		 otherButtonTitles: @"OK", nil];
		 
		 [alert addTextFieldWithValue:@"" label:@"Specify instrument name"];
		 textfieldName = [alert textFieldAtIndex:0];
		 textfieldName.keyboardType = UIKeyboardTypeAlphabet;
		 textfieldName.keyboardAppearance = UIKeyboardAppearanceAlert;
		 textfieldName.autocorrectionType = UITextAutocorrectionTypeNo;
		 textfieldName.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
		 
		 [alert show];
		 [alert release];*/
		
		SelectSymbolDlg *selectPane = [[SelectSymbolDlg alloc] initWithNibName:@"SelectSymbolDlg" bundle:nil];	
		selectPane.storage = storage;
		[self.navigationController pushViewController:selectPane animated:YES];
		[selectPane release];		
		
	}
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *instr_name = [textfieldName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		for(int i=0;i<[FavSymbols count];i++)
		{
			if([(NSString*)[FavSymbols objectAtIndex:i] isEqualToString:instr_name])
				return;
		}
		[FavSymbols insertObject:textfieldName.text atIndex:[FavSymbols count]];
		[self.tableView reloadData];
	}
}

// Determine whether a given row is eligible for reordering or not.

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
	int pos = indexPath.row;
	int cnt = [FavSymbols count];
	return pos < cnt;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
		targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath 
{
	
	int pos = proposedDestinationIndexPath.row;
	int cnt = [FavSymbols count];	
	if(pos<cnt)
		return proposedDestinationIndexPath;
	else
		return [NSIndexPath indexPathForRow:cnt-1 inSection:0];
}

// Process the row move. This means updating the data model to correct the item indices.

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath 
{

	NSString *item = [[FavSymbols objectAtIndex:fromIndexPath.row] retain];
	[FavSymbols removeObject:item];
	[FavSymbols insertObject:item atIndex:toIndexPath.row];
	[item release];
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	if(indexPath.row == ([FavSymbols count]) && self.editing)
	{
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			//cell.hidesAccessoryWhenEditing = YES;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}
		
		cell.textLabel.text = NSLocalizedString(@"FAVS_ADD_INSTRUMENT", nil); 
		return cell;
	}	
	
	NSString *symbol_name = (NSString *)[FavSymbols objectAtIndex:indexPath.row];
	SymbolInfo *si = (SymbolInfo *)[[storage Symbols] objectForKey:symbol_name];
	//if(self.editing)
	{
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			//cell.hidesAccessoryWhenEditing = YES;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
		}
		
		cell.textLabel.text = symbol_name;
		
		return cell;
	}
//	TickData *td = [[storage Prices] objectForKey:si.Symbol];
//	
//	BOOL isUP = YES;
//    static NSString *CellIdentifier = @"MWPriceUp";
//	if(td != nil && td.Bid!=nil && td.direction==0)
//	{
//		CellIdentifier = @"MWPriceDown";
//		isUP = NO;
//	}
//	else
//	{
//		CellIdentifier = @"MWPriceUp";
//		isUP = YES;
//	}
//	
//    
//    MarketWatchCell *cell = (MarketWatchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//	
//    if (cell == nil) 
//	{
//        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
//		NSArray *topLevelObjects = [[NSBundle mainBundle]
//									loadNibNamed:@"MarketWatchCell" 
//									owner:nil 
//									options:nil];
//		
//		for(id currentObject in topLevelObjects)
//		{
//			if([currentObject isKindOfClass:[UITableViewCell class]])
//			{
//				cell = (MarketWatchCell *)currentObject;
//				[cell setIsUp:isUP];
//				//cell.lblSymbol.font = [UIFont boldSystemFontOfSize:16];
//				//cell.lblBid.font	= [UIFont boldSystemFontOfSize:16];
//				//cell.lblAsk.font	= [UIFont boldSystemFontOfSize:16];
//				//
//				
//				/*cell.lblTitleAsk.text = NSLocalizedString(@"RATES_ASK", nil);
//				cell.lblTitleBid.text = NSLocalizedString(@"RATES_BID", nil);
//				cell.lblTitleHigh.text = NSLocalizedString(@"RATES_MAX", nil);
//				cell.lblTitleLow.text = NSLocalizedString(@"RATES_MIN", nil);*/
//				
//				if(isUP)
//				{
//					cell.lblBid.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
//					cell.lblAsk.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
//					[cell.imgArrow setImage:[UIImage imageNamed:@"up_blue.png"]];
//				}
//				else
//				{
//					cell.lblBid.textColor = HEXCOLOR(0xCC0000FF);//[UIColor redColor];
//					cell.lblAsk.textColor = HEXCOLOR(0xCC0000FF);
//					[cell.imgArrow setImage:[UIImage imageNamed:@"down_red.png"]];
//				}
//				break;
//			}
//		}
//    }
//	else
//		[cell.lblSymbol setTitle:si.Symbol forState:( UIControlStateNormal | UIControlStateApplication | UIControlStateHighlighted)];
//	
//	[cell.lblSymbol setTitle:si.Symbol forState:( UIControlStateNormal | UIControlStateApplication | UIControlStateHighlighted)];
//	if(td != nil && td.Bid!=nil)
//	{
//		cell.lblBid.text = td.Bid;
//		cell.lblAsk.text = td.Ask;
//		cell.lblLow.text = td.Min;
//		cell.lblHigh.text = td.Max;
//	}
//	//[si autorelease];
//    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(self.editing)
		return;
	NSString *symbol_name = (NSString *)[FavSymbols objectAtIndex:indexPath.row];
	SymbolInfo *si = (SymbolInfo *)[[storage Symbols] objectForKey:symbol_name];
	
	[self.navigationController pushViewController:tradePane animated:YES];
	[tradePane ShowForSymbol:si AndParams:storage];
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


- (void)dealloc 
{
    [super dealloc];
	[FavSymbols dealloc];
}


@end

