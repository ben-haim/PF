

#import "FavoritesCtl.h"
#import "TradePaneController.h"
#import "MarketWatchCell.h"
#import "SelectSymbolDlg.h"
#import "MarketWatchHeaderGridCell.h"

@implementation FavoritesCtl
@synthesize storage, gridCtl;
@synthesize tabBar;
@synthesize FavSymbols;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"SCREEN_FAVS_TITLE", nil);
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
		
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BUTTONS_EDIT", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(EditTable:)];
	[self.navigationItem setLeftBarButtonItem:addButton];
	[addButton release];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChanged" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(customizationEnded:)
												 name:@"customizationEnded" object:nil];	
	
	self.gridCtl = [[GridViewController alloc] initWithNibName:@"GridView" bundle:nil];
	[[self view] addSubview:[self.gridCtl view]];
	//[[self.gridCtl view] setFrame: self.view.bounds];
	[[self.gridCtl view] setFrame:CGRectMake(0, 33, 320, 426)];
	gridCtl.grid_view.tableDelegate = self;
	[self rebind];
	
	MarketWatchHeaderGridCell *market_header = [[MarketWatchHeaderGridCell alloc] init];
	[[self view] addSubview:market_header];
	
	tradePane = [[TradePaneController alloc] initWithNibName:@"SymbolTrade" bundle:nil];	
	tradePane.storage = storage;
	[tradePane setMytype:TRADE_PANE_FAVORITES];
	[tradePane retain];
}

- (void)viewDidAppear:(BOOL)animate 
{
	[self rebind];
}


- (IBAction) EditTable:(id)sender
{	
	favs_edit = [[FavoritesEditCtl alloc] initWithNibName:@"FavoritesEdit" bundle:nil];
	[favs_edit retain];
	favs_edit.storage = storage;
	[self.navigationController pushViewController:favs_edit animated:YES];
}

- (void)customizationEnded:(NSNotification *)notification
{
	[storage.FavSymbols removeAllObjects];
	NSEnumerator *enumerator = [favs_edit.FavSymbols objectEnumerator];
	id value;
	
	while ((value = [enumerator nextObject])) 
	{
		NSString *sym_copy = [NSString stringWithFormat:@"%@", (NSString*)value];
		[storage.FavSymbols addObject:sym_copy];
	}
	[storage saveFavorites];
	[favs_edit release];
	[self rebind];
	[self.navigationController popViewControllerAnimated:YES];
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
	[gridCtl.grid_view ClearCells];
	
	if(storage==nil)
		return;
    
    [FavSymbols release];
    FavSymbols = [[NSMutableArray alloc] init];

	NSEnumerator *enumerator = [storage.FavSymbols objectEnumerator];
	id value;
	int s =0;
	while ((value = [enumerator nextObject])) 
	{
		SymbolInfo *si = (SymbolInfo *)[[storage Symbols] objectForKey:(NSString*)value];
		
		if (si != nil)
        {	
            [FavSymbols addObject:si.Symbol];
            
            MarketWatchGridCell *gs = [[MarketWatchGridCell alloc] init];
            //gs.firstInGroup = (s==0);
            //gs.lastInGroup = (s==syms_count-1);
            gs.Symbol = si.Symbol;
            gs.storage = storage;
            gs.group_index = 0;
            gs.symbol_index = s;
            [gridCtl.grid_view AddCell:gs];
            [gs release];
            s++;
        }
	}
	
	[gridCtl.grid_view RecalcScroll:NO];
	//[gridCtl.grid_view rebind];
	[gridCtl.grid_view setNeedsDisplay];
}

-(void)SymbolUpdated:(NSString*)symbol
{
	[gridCtl.grid_view setNeedsDisplay];
}
#pragma mark Table view methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if(self.editing)
		return;
	NSString *symbol_name = (NSString *)[FavSymbols objectAtIndex:indexPath.row];
	SymbolInfo *si = (SymbolInfo *)[[storage Symbols] objectForKey:symbol_name];
	
	[self.navigationController pushViewController:tradePane animated:YES];	
	[tradePane ShowForSymbol:si AndParams:storage];
}


- (void)priceChanged:(NSNotification *)notification
{
	
	if(self.editing)
		return;
	[self.gridCtl.grid_view setNeedsDisplay]; 
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
	[tabBar release];
    [FavSymbols release];
    
    [super dealloc];
}


@end

