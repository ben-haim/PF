
#import "HistoryViewController.h"
#import "../OpenTrades/Balancecell.h"
#import "../../Classes/iTraderAppDelegate.h"
#import "CustomAlert.h"
#import "SelectDateDialog.h"
#import "DepositCell.h"
#import "CloseTradeCell.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface HistoryViewController()

@property ( nonatomic, strong ) NSDateFormatter* dateFormatter;

@end

@implementation HistoryViewController

@synthesize storage = _storage;
@synthesize items = _items;
@synthesize dateFormatter = _dateFormatter;

- (void)dealloc  
{
   [ _storage release ];
   [ _items release ];
   [ _dateFormatter release ];

   [ super dealloc ];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.navigationItem.title = NSLocalizedString(@"TABS_HISTORY", nil);
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
		
	c = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dateDlgClosed:)
												 name:@"dateDlgClosed" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(HistoryOrdersReceived:)
												 name:@"HistoryOrdersReceived" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(HistoryOrdersFailedToReceive:)
												 name:@"HistoryOrdersFailedToReceive" object:nil];	
	
	self.items = [ NSMutableArray array ];
	self.tableView.rowHeight = 85;
	self.tableView.separatorColor = HEXCOLOR(0x000000FF);
	
	self.dateFormatter = [ [ NSDateFormatter new ] autorelease ];
	[self.dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];	
	deposit = 0;
	withdrawal = 0;
	pl = 0;
	netCredit = 0;
	
	//[date_format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
-(void)RequestHistory
{
	SelectDateDialog *dateDlg = [[SelectDateDialog alloc] initWithNibName:@"SelectDateDlg" bundle:nil];	
	[dateDlg SetStage:1 AndParams:self.storage];
	[self.navigationController pushViewController:dateDlg animated:YES];
	[dateDlg release];
	
	c++;
	[self.tableView reloadData];	
}

- (void)dateDlgClosed:(NSNotification *)notification
{
	SelectDateDialog *dateDlg = (SelectDateDialog *)[notification object];
	int stage = dateDlg.stage;
	if(stage==1)
	{
		SelectDateDialog *dateDlg2 = [[SelectDateDialog alloc] initWithNibName:@"SelectDateDlg" bundle:nil];
		[dateDlg2 SetStage:2 AndParams:self.storage];
		[self.navigationController pushViewController:dateDlg2 animated:YES];
		[dateDlg2 release];
	}
	else
	{
		[self.navigationController popToViewController:self animated:YES];
		UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
		activity.center = self.view.center;
		activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
      UIViewAutoresizingFlexibleTopMargin |
      UIViewAutoresizingFlexibleRightMargin |
      UIViewAutoresizingFlexibleBottomMargin;
      
		[activity startAnimating];
      
		[self.storage SaveSettings];
      
      deposit = 0;
		withdrawal = 0;
		pl = 0;
		netCredit = 0;
      
      [ [ PFSession sharedSession ] historyFromDate: self.storage.history_start
                                             toDate: self.storage.history_finish
                                          doneBlock: ^( PFReportTable* report_, NSError* error_ )
       {
          for ( NSDictionary* row_ in report_.rows )
          {
             TradeRecord *tr = [TradeRecord tradeRecordWithTradeReportRow: row_];
             [self.items addObject:tr];
             
             if( tr.cmd == 6 && tr.profit>0 )
             {
                deposit+=tr.profit;
             }
             else if(tr.cmd == 6 && tr.profit<0)
             {
                withdrawal+=tr.profit;
             }
             else if(tr.cmd<2)
             {
                pl+=tr.profit;
                pl+=tr.commission;
                pl+=tr.storage;
             }
             else if (tr.cmd==7)
             {
                netCredit += tr.profit;
             }
          }
          
          [self.tableView reloadData];
          [ activity removeFromSuperview ];
       }];
	}
}

- (void) clearItems
{
	[self.items removeAllObjects];
	[self.tableView reloadData];
	deposit = 0;
	withdrawal = 0;
	pl = 0;
	netCredit = 0;
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.items count]+1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	
	if(indexPath.row==[self.items count])//balance
	{
		Balancecell *cell=nil;
		
		
		cell = (Balancecell *)[tableView dequeueReusableCellWithIdentifier:@"BalanceCell"];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"BalanceCell" 
										owner:nil 
										options:nil];			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (Balancecell *)currentObject;
					break;
				}
			}
		}
		
		cell.lblTitlePL.text = [NSLocalizedString(@"PL_PERIOD", nil) stringByAppendingString:@":"];
		cell.lblTitleDeposit.text = [NSLocalizedString(@"DEPOSIT", nil) stringByAppendingString:@":"];
		cell.lblTitleBalance.text = [NSLocalizedString(@"CREDIT", nil) stringByAppendingString:@":"];
		cell.lblTitleWithdrawal.text = [NSLocalizedString(@"WITHDRAWAL", nil) stringByAppendingString:@":"];
		
		cell.lblBalance.text = [self.storage formatProfit:netCredit];
		cell.lblDeposit.text = [self.storage formatProfit:deposit];
		cell.lblWithdrawal.text = [self.storage formatProfit:withdrawal];
		cell.lblPL.text = [self.storage formatProfit:pl];
		
		if(pl>0)
            cell.lblPL.textColor = HEXCOLOR(0x00CC00FF);		
		else
			cell.lblPL.textColor = HEXCOLOR(0xCC0000FF);
		
		
		//balanceCell = cell;
		return cell;
	}

	TradeRecord* tr = ((TradeRecord*)[self.items objectAtIndex:indexPath.row]);
	NSString *CellIdentifier = @"CT";
	
	if(tr.cmd==7) //credit
	{
		DepositCell *cell = nil;
		BOOL isBuy = YES;
		if(tr != nil && tr.profit>0)
		{
			CellIdentifier = @"CreditCell";
			isBuy = YES;
		}
		else
		{
			CellIdentifier = @"CreditCell";
			isBuy = NO;
		}
		
		//netCredit += tr.profit;
		
		cell = (DepositCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"DepositCell" 
										owner:nil 
										options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (DepositCell *)currentObject;
					
					if(isBuy)
					{
						cell.lblType.textColor = HEXCOLOR(0x0000CCFF);	
						//[cell.imgIcon setImage:[UIImage imageNamed:@"order_buy.png"]];
						cell.lblPL.textColor = HEXCOLOR(0x00CC00FF);
					}
					else
					{
						cell.lblType.textColor = HEXCOLOR(0xCC0000FF);//[UIColor redColor];
						//[cell.imgIcon setImage:[UIImage imageNamed:@"order_sell.png"]];
						cell.lblPL.textColor = HEXCOLOR(0x00CC00FF);
					}
					break;
				}
			}
		}
		
		cell.lblTitleBalance.text = NSLocalizedString(@"CREDIT", nil);
		cell.lblTitleAmount.text = NSLocalizedString(@"AMOUNT", nil);
		cell.lblTitleOrderNo.text = [NSLocalizedString(@"SCREEN_TRADE_PROGRESS", nil) stringByAppendingString:@"#:"];
		cell.lblTitleTransactionTime.text = [NSLocalizedString(@"TRANSACTION_TIME", nil) stringByAppendingString:@":"];
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[format setDateFormat:@"dd.MM.yy HH:mm"];	
		cell.lblOrderNo.text = [NSString stringWithFormat:@"%d", tr.order];
		cell.lblType.text = tr.profit>0?@"Credit in":@"Credit out";
		cell.lblCloseTime.text = [format stringFromDate:tr.open_time];
		cell.lblPL.text = [self.storage formatProfit:tr.profit];
		
		[format release];
		
		return cell;
	}
	
	else if(tr.cmd!=6)//order
	{
		CloseTradeCell *cell = nil;
		BOOL isBuy = YES;
		if(tr != nil && tr.symbol!=nil && (tr.cmd%2)==0)
		{
			CellIdentifier = @"CloseTradeCell";
			isBuy = YES;
		}
		else
		{
			CellIdentifier = @"CloseTradeCell";
			isBuy = NO;
		}
		
		
		cell = (CloseTradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"CloseTradeCell" 
										owner:nil 
										options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (CloseTradeCell *)currentObject;
					break;
				}
			}
		}
		
		if(isBuy)
		{
			cell.lblType.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];			
			[cell.imgIcon setImage:[UIImage imageNamed:@"order_buy.png"]];
		}
		else
		{
			cell.lblType.textColor = HEXCOLOR(0xCC0000FF);//[UIColor redColor];
			[cell.imgIcon setImage:[UIImage imageNamed:@"order_sell.png"]];
		}
		
		
		cell.lblTitleOrderNo.text = NSLocalizedString(@"ORDER_ORDER", nil);
		cell.lblTitleType.text = NSLocalizedString(@"ORDER_TYPE", nil);
		cell.lblTitleVol.text = NSLocalizedString(@"ORDER_VOLUME", nil);
		cell.lblTitlePL.text = NSLocalizedString(@"ORDER_PROFIT_LOSS", nil);
		cell.lblTitleCommission.text = NSLocalizedString(@"ORDER_COMM", nil);
		cell.lblTitleSwap.text = NSLocalizedString(@"ORDER_SWAP", nil);
		cell.lblTitleOpenPrice.text = [NSLocalizedString(@"HISTORY_OPEN_PRICE", nil) stringByAppendingString:@":"];
		cell.lblTitleClosePrice.text = [NSLocalizedString(@"HISTORY_CLOSE_PRICE", nil) stringByAppendingString:@":"];
		//cell.lblTitleTP.text = [NSLocalizedString(@"TAKE_PROFIT", nil) stringByAppendingString:@":"];		
		
		cell.lblSymbol.text = tr.symbol;
		cell.lblOrderNo.text = [NSString stringWithFormat:@"%d", tr.order];
		cell.lblType.text = [tr cmd_str];
		cell.lblOpenTime.text = [self.dateFormatter stringFromDate:tr.open_time];
		cell.lblCloseTime.text = [self.dateFormatter stringFromDate:tr.close_time];
		cell.lblVol.text = [self.storage formatVolume:tr.volume];
		cell.lblOpenPrice.text = tr.open_price_string;
		cell.lblClosePrice.text = tr.close_price_string;
		cell.lblSL.text = [self.storage formatPrice:tr.sl forSymbol:tr.symbol]; 
		cell.lblTP.text = [self.storage formatPrice:tr.tp forSymbol:tr.symbol]; 
		cell.lblSwap.text = [self.storage formatProfit:tr.storage]; 
		cell.lblCommission.text = [self.storage formatProfit:tr.commission];
		//cell.lblPL.text = [storage formatProfit:(tr.profit+tr.commission+tr.storage)];
		cell.lblPL.text = [self.storage formatProfit:tr.profit];
		if(tr.profit>0)
			cell.lblPL.textColor = HEXCOLOR(0x00CC00FF);	
		else
			cell.lblPL.textColor = HEXCOLOR(0xCC0000FF);
		return cell;
		
	}
	else
	{
		
		DepositCell *cell = nil;
		BOOL isBuy = YES;
		if(tr != nil && tr.profit>0)
		{
			CellIdentifier = @"DepositCell";
			isBuy = YES;
		}
		else
		{
			CellIdentifier = @"WithdrawalCell";
			isBuy = NO;
		}
		
		
		cell = (DepositCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"DepositCell" 
										owner:nil 
										options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (DepositCell *)currentObject;
					
					if(isBuy)
					{
						cell.lblType.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
						[cell.imgIcon setImage:[UIImage imageNamed:@"order_buy.png"]];
					}
					else
					{
						cell.lblType.textColor = HEXCOLOR(0xCC0000FF);//[UIColor redColor];
						[cell.imgIcon setImage:[UIImage imageNamed:@"order_sell.png"]];
					}
					break;
				}
			}
		}
		
		cell.lblTitleBalance.text = NSLocalizedString(@"BALANCE", nil);
		cell.lblTitleAmount.text = NSLocalizedString(@"AMOUNT", nil);
		cell.lblTitleOrderNo.text = [NSLocalizedString(@"SCREEN_TRADE_PROGRESS", nil) stringByAppendingString:@"#:"];
		cell.lblTitleTransactionTime.text = [NSLocalizedString(@"TRANSACTION_TIME", nil) stringByAppendingString:@":"];
		
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"dd.MM.yyyy HH:mm"];	
		cell.lblOrderNo.text = [NSString stringWithFormat:@"%d", tr.order];
		cell.lblType.text = tr.profit>0?@"Deposit":@"Withdrawal";
		cell.lblCloseTime.text = [format stringFromDate:tr.open_time];
		cell.lblPL.text = [self.storage formatProfit:tr.profit];
		if(tr.profit>0)
			cell.lblPL.textColor = HEXCOLOR(0x0000CCFF);//[UIColor blueColor];
		else
			cell.lblPL.textColor = HEXCOLOR(0xCC0000FF);
		
		[format release];
		
		return cell;
		
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


@end

