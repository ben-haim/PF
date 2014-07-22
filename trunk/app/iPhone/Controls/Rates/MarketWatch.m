
#import "MarketWatch.h"
#import "MarketWatchCell.h"
#import "MarketWatchHeaderGridCell.h"


@implementation MarketWatch
@synthesize storage, isSelecting, gridCtl;
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

/*- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"TABS_RATES", nil);
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
		
	isSelecting = NO;
	
	tradePane = [[TradePaneController alloc] initWithNibName:@"SymbolTrade" bundle:nil];	
	tradePane.storage = storage;
	[tradePane setMytype:TRADE_PANE_RATES];
	[tradePane retain];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChanged" object:nil];		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tradeInstrument:)
												 name:@"tradeInstrument" object:nil];
	
    [super viewDidLoad];
	self.gridCtl = [[GridViewController alloc] initWithNibName:@"GridView" bundle:nil];
	[[self view] addSubview:[self.gridCtl view]];
	[[self.gridCtl view] setFrame: self.view.bounds];
	[[self.gridCtl view] setFrame:CGRectMake(self.view.bounds.origin.x, 33, self.view.bounds.size.width, 426)]; 
	gridCtl.grid_view.tableDelegate = self;
	[self rebind];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	MarketWatchHeaderGridCell *market_header = [[MarketWatchHeaderGridCell alloc] init];
	[[self view] addSubview:market_header];

	//[gridCtl.grid_view setContentInset:UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f)];
	
	
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
	[gridCtl.grid_view ClearCells];
	
	//MarketWatchHeaderGridCell *market_header = [[MarketWatchHeaderGridCell alloc] init];
	//[gridCtl.grid_view AddCell:market_header];
	
	if(storage==nil)
		return;
	int grp_cnt = [[storage SymGroups] count];
	for(int g=0; g<grp_cnt; g++)
	{			
		//BOOL first = (g==0)?YES:NO;
		
		
		SymbolGroup *sg = [[storage SymGroups] objectAtIndex:g];
		if ([[sg symbols] count] == 0) 
			continue;
		HeaderGridCell *gs_sep; 
		//NSLog(@"%@,%@,%d.", sg.name, sg.desc, sg.index);
		gs_sep = [[HeaderGridCell alloc] initWithText:sg.name isFirst:(g==0)];
		gs_sep.isGroupRow = YES;
		//gs_sep.Height = 26;
		[gridCtl.grid_view AddCell:gs_sep];
		[gs_sep autorelease];
		int syms_count = [[sg symbols] count];
		for(int s=0; s<syms_count; s++)
		{
			NSArray *syms = [sg symbols];
			SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:s];
			
			/*TickData *price;
			@try {
				price = [[storage Prices] objectForKey:si.Symbol];
			}
			@catch (NSException * e) {
				NSLog(@"MarketWatch exception:%@",[NSThread callStackSymbols]);
			}
			//TickData *price = [[storage Prices] objectForKey:Symbol];
			if(price==nil)
			{
				continue;
			}*/
			
			MarketWatchGridCell *gs = [[MarketWatchGridCell alloc] init];
			gs.firstInGroup = (s==0);
			gs.lastInGroup = (s==syms_count-1);
			gs.Symbol = si.Symbol; //NSLog(@"%@", si.Symbol);
			gs.storage = storage;
			gs.group_index = g;
			gs.symbol_index = s; 
			[gridCtl.grid_view AddCell:gs];
			[gs autorelease];
		}
	}
	[gridCtl.grid_view RecalcScroll:NO];
	[gridCtl.grid_view setNeedsDisplay];
}


-(void)SymbolUpdated:(NSString*)symbol
{
	
	//[self.tableView reloadData];
}

- (void)priceChanged:(NSNotification *)notification
{
	[self.gridCtl.grid_view setNeedsDisplay];
}


- (void)tradeInstrument:(NSNotification *)notification
{
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:0];
	NSArray *syms = [sg symbols];
	SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:0];
	
	TickData *price = [[storage Prices] objectForKey:si.Symbol];
	if(price==nil)
	{
		return;
	}
	
	NSLog(@"Symbol to show chart: %@", si.Symbol);
	
	[self.navigationController pushViewController:tradePane animated:YES];
	[tradePane ShowForSymbol:si AndParams:storage];
}

#pragma mark Table view methods
/*
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
	
	int section= indexPath.section;	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];
	NSMutableArray *syms = [sg symbols];
	
	SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:indexPath.row];

	TickData *td = [[storage Prices] objectForKey:si.Symbol];
	
	BOOL isUP = YES;
    static NSString *CellIdentifier = @"MWPriceUp";
	if(td != nil && td.Bid!=nil && td.direction==0)
	{
		CellIdentifier = @"MWPriceDown";
		isUP = NO;
	}
	else
	{
		CellIdentifier = @"MWPriceUp";
		isUP = YES;
	}
	
    
    MarketWatchCell *cell = (MarketWatchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) 
	{
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		NSArray *topLevelObjects = [[NSBundle mainBundle]
								   loadNibNamed:@"MarketWatchCell" 
									owner:nil 
									options:nil];

		for(id currentObject in topLevelObjects)
		{
			if([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (MarketWatchCell *)currentObject;
				[cell setIsUp:isUP];
				//cell.lblSymbol.font = [UIFont boldSystemFontOfSize:16];
				//cell.lblBid.font	= [UIFont boldSystemFontOfSize:16];
				//cell.lblAsk.font	= [UIFont boldSystemFontOfSize:16];
				//
				if(isUP)
				{
					cell.lblBid.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
					cell.lblAsk.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
					[cell.imgArrow setImage:[UIImage imageNamed:@"up_blue.png"]];
				}
				else
				{
					cell.lblBid.textColor = HEXCOLOR(0xCC0000FF);//[UIColor redColor];
					cell.lblAsk.textColor = HEXCOLOR(0xCC0000FF);
					[cell.imgArrow setImage:[UIImage imageNamed:@"down_red.png"]];
				}
				break;
			}
		}
    }
	else
		;//[cell.lblSymbol setTitle:si.Symbol forState:( UIControlStateNormal | UIControlStateApplication | UIControlStateHighlighted)];
	
	cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
	//[si autorelease];
    return cell;
}*/

/*- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath 
{
	return UIButtonTypeDetailDisclosure;
}*/
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
/*- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	isSelecting = YES;
	return indexPath;
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    int section= indexPath.section;	
	SymbolGroup *sg = [[storage SymGroups] objectAtIndex:section];
	NSArray *syms = [sg symbols];	
	SymbolInfo *si = (SymbolInfo *)[syms objectAtIndex:indexPath.row];
	
	/*TickData *price = [[storage Prices] objectForKey:si.Symbol];
	if(price==nil)
	{
		return;
	}*/
	
	NSLog(@"Symbol to show chart: %@", si.Symbol);
	
/*	TradePaneController * tradeViewPnl = [[TradePaneController alloc] initWithNibName:@"SymbolTrade" bundle:nil];	
	tradeViewPnl.storage = storage;
	[self.navigationController pushViewController:tradeViewPnl animated:YES];
	[tradeViewPnl ShowForSymbol:si AndParams:storage];
	[tradeViewPnl autorelease];*/
	
	[self.navigationController pushViewController:tradePane animated:YES];
	[tradePane ShowForSymbol:si AndParams:storage];
	//[tradePane release];
	isSelecting = NO;

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

