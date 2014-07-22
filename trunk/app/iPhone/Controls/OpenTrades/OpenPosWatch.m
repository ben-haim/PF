
#import "OpenPosWatch.h"
#import "ClientParams.h"

#import "OpenPosViewChoices.h"
#import "UIBarButtonItem+WEPopover.h"
#import "CustomAlert.h"

#import "Conversion.h"

@implementation OpenPosWatch
@synthesize storage;
@synthesize open_items;
@synthesize pending_items;
@synthesize SymbolPositions;
@synthesize Dependencies, gridCtl, myView;
@synthesize txtAccount, txtBalance, txtCredit, txtFree, txtEquity, txtLevel, txtMargin, txtProfit;

@synthesize popoverController;


- (void)viewDidLoad 
{
    [super viewDidLoad];    
	
	self.navigationItem.title = NSLocalizedString(@"TABS_POSITIONS", nil);

    //Try setting this to UIPopoverController to use the iPad popover. The API is exactly the same!
	popoverClass = [WEPopoverController class];
    currentPopoverCellIndex = -1;
    UIBarButtonItem *popoverBarItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"popover_menu", nil)
                                                                       style:UIBarButtonItemStyleBordered 
                                                                      target:self 
                                                                      action:@selector(showPopover:)];
	self.navigationItem.rightBarButtonItem = popoverBarItem;
   [ popoverBarItem release ];

	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	//NSLog(@"%@", filepath);
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
	
	SymbolPositions = [[NSMutableDictionary alloc] init];
	Dependencies = [[NSMutableDictionary alloc] init];
	isAllShown = YES;
	[self rebind:NO];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChanged" object:nil];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resetTradeProfits)
												 name:@"resetTradeProfits" object:nil];	
    
	
	self.gridCtl = [[[GridViewController alloc] initWithNibName:@"GridView" bundle:nil]autorelease];
	[[self view] addSubview:[self.gridCtl view]];
	[[self.gridCtl view] setFrame: CGRectMake(0, 0, 320, 390)];
	gridCtl.grid_view.tableDelegate = self;
	[self rebind:NO];
	
	
	[self generateBalanceCell];
	//[self updateBalanceValues];
	
}


-(void)viewDidAppear:(BOOL)animated {
	 [super viewDidAppear:animated];
	 [self updateBalanceValues];
}
 

- (void)generateBalanceCell
{
	isBalanceExpanded = NO;
	int offset = -5;
	
	myView = [[[BalanceUIView alloc] initWithFrame:CGRectMake(0, 300, 330, 132)] autorelease];
	[myView setBackgroundColor:[ClientParams cellBalanceColor]];
	
	
	UIImageView* imgShadow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_line.png"]];
	[imgShadow1 setFrame:CGRectMake(0, -13, 320, 26)];
	[imgShadow1 setAlpha:0.6];
	[myView addSubview:imgShadow1];
	[imgShadow1 release];
	
	
	
	
	UIImageView* imgHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_header_clear.png"]];
	[imgHeader setFrame:CGRectMake(0, -13, 320, 26)];
	[myView addSubview:imgHeader];
	[imgHeader release];
	
	//UIFont* font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
	UIFont* midFont = [UIFont fontWithName:@"Helvetica-Bold" size:11.0f];
	UIFont* bigBlackFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
	UIFont* middleBlackFont = [UIFont fontWithName:@"Helvetica" size:11.0f];
	
/*	UILabel* lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(18, -11, 150, 20)];
	[lblHeader setBackgroundColor:[UIColor clearColor]];
	[lblHeader setFont:font];
	[lblHeader setTextColor:[UIColor whiteColor]];
	lblHeader.text = NSLocalizedString(@"BALANCE", nil);
	//[lblBalance setFrame:CGRectMake(15, 15, lblBalance.bounds.size.width, lblBalance.bounds.size.height)];
	CGSize textSize = [[lblHeader text] sizeWithFont:font];
	[lblHeader setFrame:CGRectMake(302-textSize.width, -5, 150, 20)];*/
	
	
	
/*	UIImage* imgTitle = [UIImage imageNamed:@"header_balance.png"];
	UIImage* imgTitleScaled = [imgTitle stretchableImageWithLeftCapWidth:17 topCapHeight:1];
	UIImageView* ScaledView = [[UIImageView alloc] initWithImage:imgTitleScaled];
	[ScaledView setFrame:CGRectMake(315-textSize.width-27, -11, textSize.width+27, 26)];//lblBalance.bounds.size.width, imgTitleScaled.size.height)];
	[myView addSubview:ScaledView];
	[ScaledView release];*/
	
	
	
	
/*	[myView addSubview:lblHeader];
	[lblHeader release];
	*/
	
	// captions
	UILabel* lblProfit = [[UILabel alloc] initWithFrame:CGRectMake(9, 20 + offset, 100, 15)];	
	[lblProfit setTextColor:[UIColor lightGrayColor]];
	[lblProfit setFont:midFont];
	[lblProfit setText:NSLocalizedString(@"CURRENT_PL", nil)];
	[lblProfit setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblProfit];
	[lblProfit release];
	
	UILabel* lblMargin = [[UILabel alloc] initWithFrame:CGRectMake(206, 20 + offset, 70, 15)];	
	[lblMargin setTextColor:[UIColor lightGrayColor]];
	[lblMargin setFont:midFont];
	[lblMargin setText:NSLocalizedString(@"MARGIN", nil)];
	[lblMargin setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblMargin];
	[lblMargin release];
	
	UILabel* lblBalance = [[UILabel alloc] initWithFrame:CGRectMake(9, 50 + offset, 100, 15)];	
	[lblBalance setTextColor:[UIColor lightGrayColor]];
	[lblBalance setFont:midFont];
	[lblBalance setText:[NSLocalizedString(@"BALANCE", nil) stringByAppendingString:@":"]];
	[lblBalance setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblBalance];
	[lblBalance release];
	
	UILabel* lblFree = [[UILabel alloc] initWithFrame:CGRectMake(206, 50 + offset, 70, 15)];	
	[lblFree setTextColor:[UIColor lightGrayColor]];
	[lblFree setFont:midFont];
	[lblFree setText:NSLocalizedString(@"FREE", nil)];
	[lblFree setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblFree];
	[lblFree release];
	
	UILabel* lblEquity = [[UILabel alloc] initWithFrame:CGRectMake(9, 80 + offset, 100, 15)];	
	[lblEquity setTextColor:[UIColor lightGrayColor]];
	[lblEquity setFont:midFont];
	[lblEquity setText:NSLocalizedString(@"EQUITY", nil)];
	[lblEquity setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblEquity];
	[lblEquity release];
	
	UILabel* lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(206, 80 + offset, 70, 15)];	
	[lblLevel setTextColor:[UIColor lightGrayColor]];
	[lblLevel setFont:midFont];
	[lblLevel setText:NSLocalizedString(@"LEVEL", nil)];
	[lblLevel setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblLevel];
	[lblLevel release];
	
	UILabel* lblAccount = [[UILabel alloc] initWithFrame:CGRectMake(9, 110 + offset, 100, 15)];	
	[lblAccount setTextColor:[UIColor lightGrayColor]];
	[lblAccount setFont:midFont];
	[lblAccount setText:NSLocalizedString(@"LOGIN_LOGIN", nil)];
	[lblAccount setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblAccount];
	[lblAccount release];
	
	UILabel* lblCredit = [[UILabel alloc] initWithFrame:CGRectMake(206, 109 + offset, 70, 15)];	
	[lblCredit setTextColor:[UIColor lightGrayColor]];
	[lblCredit setFont:midFont];
	[lblCredit setText:[NSLocalizedString(@"CREDIT", nil) stringByAppendingString:@":"]];
	[lblCredit setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:lblCredit];
	[lblCredit release];
	///////////////////////////////
	
	// data
	txtProfit = [[UILabel alloc] initWithFrame:CGRectMake(78, 18 + offset, 120, 15)];	
	[txtProfit setTextAlignment:UITextAlignmentRight];
	[txtProfit setFont:bigBlackFont];
	//[txtProfit setText:@"1 000 000"];
	[txtProfit setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtProfit];
	
	txtMargin = [[UILabel alloc] initWithFrame:CGRectMake(236, 20 + offset, 75, 15)];	
	[txtMargin setTextAlignment:UITextAlignmentRight];
	[txtMargin setFont:middleBlackFont];
	//[txtMargin setText:@"1 000 000"];
	[txtMargin setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtMargin];
	
	txtBalance = [[UILabel alloc] initWithFrame:CGRectMake(78, 48 + offset, 120, 15)];	
	[txtBalance setTextAlignment:UITextAlignmentRight];
	[txtBalance setFont:bigBlackFont];
	//[txtBalance setText:@"1 000 000"];
	[txtBalance setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtBalance];
	
	txtFree = [[UILabel alloc] initWithFrame:CGRectMake(236, 50 + offset, 75, 15)];	
	[txtFree setTextAlignment:UITextAlignmentRight];
	[txtFree setFont:middleBlackFont];
	//[txtFree setText:@"1 000 000"];
	[txtFree setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtFree];
	
	txtEquity = [[UILabel alloc] initWithFrame:CGRectMake(78, 78 + offset, 120, 15)];	
	[txtEquity setTextAlignment:UITextAlignmentRight];
	[txtEquity setFont:bigBlackFont];
	//[txtEquity setText:@"1 000 000"];
	[txtEquity setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtEquity];
	
	txtLevel = [[UILabel alloc] initWithFrame:CGRectMake(236, 80 + offset, 75, 15)];	
	[txtLevel setTextAlignment:UITextAlignmentRight];
	[txtLevel setFont:middleBlackFont];
	//[txtLevel setText:@"1 000 000"];
	[txtLevel setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtLevel];
	
	txtAccount = [[UILabel alloc] initWithFrame:CGRectMake(78, 108 + offset, 120, 15)];	
	[txtAccount setTextAlignment:UITextAlignmentRight];
	[txtAccount setFont:bigBlackFont];
	//[txtAccount setText:@"1 000 000"];
	[txtAccount setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtAccount];
	
	txtCredit = [[UILabel alloc] initWithFrame:CGRectMake(236, 109 + offset, 75, 15)];	
	[txtCredit setTextAlignment:UITextAlignmentRight];
	[txtCredit setFont:middleBlackFont];
	//[txtCredit setText:@"1 000 000"];
	[txtCredit setBackgroundColor:[UIColor clearColor]];
	[myView addSubview:txtCredit];
	
	
	UIButton *btnExpand = [[UIButton alloc] initWithFrame:myView.bounds];
	[btnExpand addTarget:self action:@selector(Expand:) forControlEvents:UIControlEventTouchUpInside];
	[myView insertSubview:btnExpand atIndex:0];
   [ btnExpand release ];
	
	
	
	[[self view] addSubview:myView];
	
	
	/*UIImageView* imgFooter = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"row_header_clear.png"]];
	[imgFooter setFrame:CGRectMake(0, 352, 320, 26)];
	[[self view] addSubview:imgFooter];
	[imgFooter release];*/
	//[myView setNeedsDisplay];

}

- (void)Expand:(id)sender
{
	if (isBalanceExpanded)
	{
		[UIView beginAnimations:@"animateTableView" context:nil];
		[UIView setAnimationDuration:0.4];
		[myView setFrame:CGRectMake(myView.bounds.origin.x, 300, myView.bounds.size.width, myView.bounds.size.height)]; 
		
		
		//[[self.gridCtl view] setFrame: CGRectMake(0, 0, 320, 380)];
		
		[UIView commitAnimations];
		
		isBalanceExpanded = NO;
	}
	else 
	{
		[UIView beginAnimations:@"animateTableView" context:nil];
		[UIView setAnimationDuration:0.4];
		[myView setFrame:CGRectMake(myView.bounds.origin.x, 235, myView.bounds.size.width, myView.bounds.size.height)]; 
	
		//[[self.gridCtl view] setFrame: CGRectMake(0, 0, 320, 315)];
		
		[UIView commitAnimations];
		
		isBalanceExpanded = YES;
	}
}

- (void)dealloc 
{
	[open_items release];
	[pending_items release];
	[SymbolPositions release];
	[Dependencies release];
	[myView release];
	[txtAccount release];
	[txtCredit release];
	[txtProfit release];
	[txtMargin release];
	[txtBalance release];
	[txtFree release];
	[txtEquity release];
	[txtLevel release];
    [super dealloc];	
}

-(void) ChangeView:(BOOL)_isAllShown
{
	isAllShown = _isAllShown;
	[self rebind:YES];
}

/*
 This function is used to collect the trade list data from the server
 As you can see in the dummy implementation, the function creates only one TradeRecord entry
 And stores it in the open_items and pending_items
 Most probably you will need to pass more than one TradeRecord entry in the trade array
 and store them all using a loop
 */
- (void) UpdateTradesList:(NSArray *)trade
{
	if(open_items==nil)
		open_items = [[NSMutableArray alloc] init];
	else
		[open_items removeAllObjects];
	
	if(pending_items==nil)
		pending_items = [[NSMutableArray alloc] init];
	else
		[pending_items removeAllObjects];

	
		TradeRecord *tr = [[TradeRecord alloc] init];   
		tr.order = 0;
		
		int time_temp = 0;
		
		int dateDaylightSaving = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[NSDate dateWithTimeIntervalSince1970:time_temp]];
		
		int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
		if (dateDaylightSaving == 0) 
		{
			gmt_delta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
		}
		
		tr.open_time = [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];
		tr.cmd = 0;
		tr.volume = 0;
		tr.symbol = @"EURUSD";
		tr.open_price = 0.0;
		tr.sl = 0.0;
		tr.tp = 0.0;
		tr.commission = 0.0;
		tr.storage = 0.0;
		tr.activation = 0;
		tr.row_type = (tr.cmd>1)?-1:1;

		if(tr.row_type==1)//open
		{
			[open_items addObject:tr];
		}
		else //pending
		{
			[pending_items addObject:tr];
		}
		[tr release];
	
	[self UpdateProfits:YES];
	[self rebind:NO];
	
	//[self updateBalanceValues];
}

-(NSMutableArray*)open_items
{
   if ( !open_items )
   {
      open_items = [ NSMutableArray new ];
   }
   return open_items;
}

-(void)addPosition:( TradeRecord* )trade_record_
{
   if ( trade_record_.isOrder )
   {
      [ self.pending_items addObject: trade_record_ ];
   }
   else
   {
      [ self.open_items addObject: trade_record_ ];
   }
   
   [self UpdateProfits:YES];
	[self rebind:NO];
}

-(void)addPositions:( NSArray* )trades_
{
   self.open_items = [ NSMutableArray array ];
   self.pending_items = [ NSMutableArray array ];
   
   for ( TradeRecord* trade_record_ in trades_ )
   {
      [ self addPosition: trade_record_ ];
   }

   [self UpdateProfits:YES];
	[self rebind:NO];
}

NSInteger tradesSort(TradeRecord* trade1, TradeRecord* trade2, void *reverse)
{
    int idx1 = [trade1 order];
    int idx2 = [trade2 order];
	
	if(idx1<idx2)
		return NSOrderedAscending;
	else
		if(idx1>idx2)
			return NSOrderedDescending;
		else		
			return NSOrderedSame;
}
/*
 This function is used when a new trade data or trade delete arrives from the server
 As you can see in the dummy implementation, the function creates one TradeRecords entry
 and stores it in the open_items and pending_items vectors or deletes it from them.
 */
- (void) UpdateTrades:(NSArray *)trade
{
	if(open_items==nil)
		open_items = [[NSMutableArray alloc] init];
	
	if(pending_items==nil)
		pending_items = [[NSMutableArray alloc] init];
    //TODO: changeMe should be changes with trade, changeMe is not the same everywhere in the code
    int changeMe = 0;
	NSString *cmd = [trade objectAtIndex:changeMe];
	if([cmd isEqualToString:@"add_trade"] || [cmd isEqualToString:@"act_trade"])
	{
		TradeRecord *tr = [[[TradeRecord alloc] init] autorelease];   
		tr.order = [[trade objectAtIndex:changeMe] integerValue];
        
		int time_temp = 0;
		
		int dateDaylightSaving = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:[NSDate dateWithTimeIntervalSince1970:time_temp]];
		
		int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
		if (dateDaylightSaving == 0) 
		{
			gmt_delta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
		}
		
		tr.open_time = [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];
		tr.cmd = 0;
		tr.volume = 0;
		tr.symbol = @"EURUSD";
		tr.open_price = 0.0;
		tr.sl = 0.0;
		tr.tp = 0.0;
		tr.commission = 0.0;
		tr.storage = 0.0;
		tr.activation = 0;
		tr.row_type = (tr.cmd>1)?-1:1;
		
		int trade_no = tr.order;
		
		if([cmd isEqualToString:@"add_trade"])
		{ 
			
			NSEnumerator *enumerator = [open_items objectEnumerator];
			id value;
			int existingIndex1 = -1;
			int c = 0;
			while ((value = [enumerator nextObject])) 
			{
				c++;
				TradeRecord *tr = (TradeRecord*)value;
				if(tr==nil || tr.order != trade_no)
					continue;
				existingIndex1 = c-1;
				break;
			}
			
			c=0;
			
			int existingIndex2 = -1;
			enumerator = [pending_items objectEnumerator];
			
			while ((value = [enumerator nextObject])) 
			{
				c++;
				TradeRecord *tr = (TradeRecord*)value;
				if(tr==nil || tr.order != trade_no)
					continue;
				existingIndex2 = c-1;
				break;
			}
			if(tr.row_type==1)//open
			{
				if(existingIndex1>=0)
					[open_items replaceObjectAtIndex:existingIndex1 withObject:tr];
				else
					[open_items addObject:tr];
				if(existingIndex2>=0)
					[pending_items removeObjectAtIndex:existingIndex2];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newOpenPosition" object:tr];
			}
			else //pending
			{
				if(existingIndex2>=0)
					[pending_items replaceObjectAtIndex:existingIndex2 withObject:tr];
				else					
					[pending_items addObject:tr];
				if(existingIndex1>=0)
					[open_items removeObjectAtIndex:existingIndex1];
			}
		}
	}
	else
	if([cmd isEqualToString:@"delete_trade"])
	{
		int trade_no = [[trade objectAtIndex:changeMe] integerValue];
		id value;	
		TradeRecord *tr = nil;
		BOOL is_release = NO;
		NSEnumerator *enumerator = [open_items objectEnumerator];
		while ((value = [enumerator nextObject])) 
		{
			tr = [(TradeRecord*)value retain];
			if(tr==nil || tr.order != trade_no)
				continue;			
			[open_items removeObject:value];
			is_release = YES;
			break;
		}
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeOpenPosition" object:tr];
        [tr release];
	
		is_release = NO;
		enumerator = [pending_items objectEnumerator];

		while ((value = [enumerator nextObject])) 
		{
			tr = (TradeRecord*)value;
			if(tr==nil || tr.order != trade_no)
				continue;
			[pending_items removeObject:value];
			is_release = YES;
			break;
		}		
	}
	
	BOOL reverseSort = NO;	
	NSArray * arr = [open_items sortedArrayUsingFunction:tradesSort context:&reverseSort];// retain];
	
	[open_items release];
	open_items = [[NSMutableArray alloc] initWithArray:arr];
	
	[self UpdateProfits:YES];

	if (storage.openTradesView == OPEN_TRADE_VIEW_AGR)
	{
		[aggragateViewControl rebild:YES];
	}
	else {
		[self rebind:YES];
	}	
	
	[self updateBalanceValues];
}

- (void) resetTradeProfits
{
    NSEnumerator *enumerator = [open_items objectEnumerator];
	id value;	
	while ((value = [enumerator nextObject])) 
	{
		TradeRecord *tr = (TradeRecord*)value;
        tr.close_price = 0;
    }
}

-(BOOL) UpdateProfits:(BOOL)forceChanged
{
    if (storage.openTradesView == OPEN_TRADE_VIEW_AGR)
    {
        return [aggragateViewControl updateProfits:forceChanged];
    }
        
	NSEnumerator *enumerator = [open_items objectEnumerator];
	id value;	
	BOOL changed = forceChanged;
	while ((value = [enumerator nextObject])) 
	{
		TradeRecord *tr = (TradeRecord*)value;
		if(tr==nil)
			return NO;
		double old_profit = tr.profit;
		SymbolInfo *sym = [[storage Symbols] objectForKey:tr.symbol]; 
		TickData *td = [[storage Prices] objectForKey:tr.symbol];
		if(sym==nil || td ==nil)
			return NO;
		NSString* close_price = (tr.cmd == 0)?td.Bid:td.Ask;
		double closePrice = [close_price doubleValue];
		
		if (closePrice != tr.close_price || storage.openTradesView == OPEN_TRADE_VIEW_POINTS)
		{
			tr.close_price = [close_price doubleValue];

			//NSLog(@"%@, profit mode: %d", sym.Symbol, sym.ProfitMode);
			if (storage.openTradesView == OPEN_TRADE_VIEW_POINTS)
            {
                switch(sym.ProfitMode)
                {
                    case 0: //Forex
                    {
                        int delta = (sym.Digits == 3 || sym.Digits == 5) ? 1 : 0;
                        if (tr.cmd == 0) //buy
                        {
                            tr.profit = (tr.close_price - tr.open_price) * pow(10, sym.Digits - delta);
                        }
                        else
                        {
                            tr.profit = (tr.open_price - tr.close_price) * pow(10, sym.Digits - delta);
                        }
                    }
                        break;
                    case 1: //CFD
                        if (tr.cmd == 0) //buy
                        {
                            tr.profit = (tr.close_price - tr.open_price) * pow(10, sym.Digits);
                        }
                        else
                        {
                            tr.profit = (tr.open_price - tr.close_price) * pow(10, sym.Digits);  
                        }
                        break;
                    case 2: //Futures
                        if (tr.cmd == 0) //buy
                        {
                            tr.profit = ([td.Bid doubleValue] - tr.open_price) * pow(10, sym.Digits);   
                        }
                        else
                        {
                            tr.profit = (tr.open_price - [td.Ask doubleValue]) * pow(10, sym.Digits);
                        }                        
                        break;
                }
            }
            else
            {              
                switch(sym.ProfitMode)
                {
                    case 0: //Forex
                        tr.profit = (tr.close_price - tr.open_price)*sym.ContractSize*tr.volume;
                        break;
                    case 1: //CFD
                        tr.profit = (tr.close_price - tr.open_price)*sym.ContractSize*tr.volume;
                        break;
                    case 2: //Futures
                        //NSLog(@"Before:: %@ %f %f %f", tr.symbol, tr.profit, tr.open_price, tr.close_price);
                        tr.profit = (tr.close_price - tr.open_price)*tr.volume*sym.TickValue/sym.TickSize;
                        //NSLog(@"After:: %@ %f %f %f", tr.symbol, tr.volume, sym.TickValue, sym.TickSize);
                        break;
                }
                
                if((tr.cmd%2)!=0)
                    tr.profit*=-1;
                
                BOOL isCFD = sym.ProfitMode == 1;
                
                [self Convert:tr UsingConv:sym.Conv1 isCFD:isCFD];
                [self Convert:tr UsingConv:sym.Conv2 isCFD:isCFD]; 
            }
			
			/*tr.profit = round(tr.profit*100.0);
			tr.profit/=100.0;*/
    
			if(tr.profit!=old_profit)
				changed = YES;
		}
	}
	
	[self updateBalanceValues];
	
	if(changed)
	{
		[self UpdateSummaryData];
		return changed;
	}
	
	NSEnumerator *enumerator_pending = [pending_items objectEnumerator];
	id value_pending;	
	while ((value_pending = [enumerator_pending nextObject])) 
	{
		TradeRecord *tr = (TradeRecord*)value_pending;
		if(tr==nil)
			return NO;
		
		SymbolInfo *sym = [[storage Symbols] objectForKey:tr.symbol]; 
		TickData *td = [[storage Prices] objectForKey:tr.symbol];
		if(sym==nil || td ==nil)
			return NO;
		
		NSString* close_price = (tr.cmd%2 != 0)?td.Bid:td.Ask;
		double closePrice = [close_price doubleValue];
		
		if (closePrice != tr.close_price)
		{
			tr.close_price = closePrice;
			return YES;
		}
	}
	
	return NO;
	
	//return changed;
}

- (void) Convert:(TradeRecord*)item UsingConv:(Conversion*)conv isCFD:(BOOL)cfd
{
	if (conv == nil || conv.Constant || [conv IsEmpty])
    {
		return;
    }
	if (conv.ReversePrevious)
    {
		item.profit = item.profit / item.close_price;
    }
	
	double Price;
	TickData *tick = [[storage Prices] objectForKey:conv.Pair];
    if (!cfd)
    {
        if (item.cmd % 2 == 0) //buy
        {
            Price = [tick.Bid doubleValue];
        }
        else //sell
        {
            Price = [tick.Ask doubleValue];
        }
	}
    else
    {
        Price = [tick.Bid doubleValue];
    }
    
	if (conv.Divide)
    {
        item.profit = item.profit / Price;
    }
	else
    {
		item.profit = item.profit * Price;
    }
}

-(void) UpdateSummaryData
{
    if (storage.openTradesView == OPEN_TRADE_VIEW_AGR)
    {
        return [aggragateViewControl updateSummaryData];
    }
    
	storage.SumSwap = 0.0;
	storage.SumSwapOrig = 0.0;
	storage.SumProfit = 0.0;
	storage.SumProfits = 0.0;
	storage.SumLosses = 0.0;
	NSEnumerator *enumerator = [open_items objectEnumerator];
	id value;	
	while ((value = [enumerator nextObject])) 
	{
		TradeRecord *tr = (TradeRecord*)value;
		if(tr==nil)
			return;
		storage.SumProfit += (tr.profit + tr.storage + tr.commission);
		storage.SumSwap += round(tr.storage*100.0)/100.0;
		storage.SumSwapOrig += tr.storage;
		
		if (tr.profit > 0) 
			storage.SumProfits += (tr.profit + tr.storage + tr.commission);
		else 
			storage.SumLosses += (tr.profit + tr.storage + tr.commission);
	}
	
	[self updateBalanceValues];
	
}

- (void)updateBalanceValues
{
    if (storage.openTradesView != OPEN_TRADE_VIEW_POINTS)
    {
        if (storage.SumProfit < 0)
            [txtProfit setTextColor:HEXCOLOR(0xCC0000FF)];
        else
            [txtProfit setTextColor:HEXCOLOR(0x00CC00FF)];
    }
    else
    {
            [txtProfit setTextColor:HEXCOLOR(0x000000FF)];
    }
    
    txtBalance.text = [storage formatProfit:storage.Balance];
	txtMargin.text = [storage formatProfit:storage.Margin];
	txtCredit.text = [storage formatProfit:storage.Credit];
	txtAccount.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
	
	
	
	double FreePct = 0;
	if(storage.Margin!=0)
		FreePct = 100 * (storage.Balance + storage.SumProfit + storage.Credit) / storage.Margin;
	else
		FreePct = 0;
    
	if (storage.openTradesView != OPEN_TRADE_VIEW_POINTS)
    {
        txtProfit.text = [storage formatProfit:storage.SumProfit];
        
        txtEquity.text = [storage formatProfit:(storage.Balance + storage.SumProfit + storage.Credit)];
        
        if (storage.Margin_Mode == MARGIN_USE_ALL) 
            txtFree.text = [storage formatProfit:(storage.Balance + storage.SumProfit + storage.Credit -storage.Margin)];
        else if (storage.Margin_Mode == MARGIN_DONT_USE)
            txtFree.text = [storage formatProfit:(storage.Balance + storage.Credit - storage.Margin)];
        else if (storage.Margin_Mode == MARGIN_USE_PROFIT)
            txtFree.text = [storage formatProfit:(storage.Balance + storage.Credit + MAX(0, storage.SumProfit) - storage.Margin)];
        else if (storage.Margin_Mode == MARGIN_USE_LOSS)
            txtFree.text = [storage formatProfit:(storage.Balance + storage.Credit + MIN(0, storage.SumProfit) - storage.Margin)];
        
        txtLevel.text = [NSString stringWithFormat:@"%@%%", [storage formatPercentage:(round(FreePct*100)/100)]];
    }
    else
    {
        txtProfit.text = @"N/A";
        txtEquity.text = @"N/A";
        txtFree.text   = @"N/A";
        txtLevel.text  = @"N/A";
    }
}

// segment action
- (void) segmentAction:(id)sender 
{
	UISegmentedControl* segCtl = sender;
	[self ChangeView:( [segCtl selectedSegmentIndex] == 0 )];
}
-(void)rebind:(BOOL)keepScroll
{	
	CGPoint old_contentOffset = [gridCtl.grid_view contentOffset]; 
	
	[gridCtl.grid_view ClearCells];	

	if(storage==nil)
		return;
	
	BOOL firstHeader = YES;
	
	HeaderGridCell *gs_sep;
	
	if ([open_items count]>0)
	{
		gs_sep = [[HeaderGridCell alloc] initWithText:NSLocalizedString(@"HEADER_OPEN_POSITIONS", nil) isFirst:YES];
		gs_sep.isGroupRow = YES;
		//gs_sep.Height = 50;
		[gridCtl.grid_view AddCell:gs_sep];
		[gs_sep autorelease];
		firstHeader = NO;
	}
	
	for(int i=0; i< [open_items count]; i++)
	{	
		OpenPosGridCell *gs = [[OpenPosGridCell alloc] init];
		gs.firstInGroup = (i==0);
		gs.lastInGroup = (i==[open_items count]-1 && [pending_items count]!=0);
		gs.watch = self;
		gs.storage = storage;
		gs.group_index = 0;
		gs.symbol_index = i;
		
		[gridCtl.grid_view AddCell:gs];
		[gs autorelease];

	}
	
	if(isAllShown)
	{
		
		if ([pending_items count]>0)
		{
			gs_sep = [[HeaderGridCell alloc] initWithText:NSLocalizedString(@"HEADER_PENDING_ORDERS", nil)];
			gs_sep.isGroupRow = YES;

			[gridCtl.grid_view AddCell:gs_sep];
			[gs_sep autorelease];
		}
		
		for(int i=0; i< [pending_items count]; i++)
		{	
			PendingPosGridCell *gs = [[PendingPosGridCell alloc] init];
			gs.firstInGroup = (i==0);

			gs.watch = self;
			gs.storage = storage;
			gs.group_index = 2;
			gs.symbol_index = i;
			
			[gridCtl.grid_view AddCell:gs];
			[gs autorelease];
		}
	}

	[gridCtl.grid_view RecalcScroll:keepScroll]; 
	
	if(keepScroll)
		[gridCtl.grid_view setContentOffset:old_contentOffset];
	
	[gridCtl.grid_view setNeedsDisplay];
}

- (void)priceChanged:(NSNotification *)notification
{
	if([self UpdateProfits:NO])
	{
		[gridCtl.grid_view setNeedsDisplay];
	}
}
-(void)SymbolUpdated:(NSString*)symbol
{
	[gridCtl.grid_view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	if(isAllShown)
		return 1 + 1 + 1;
	else
		return 1 + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{

	if(isAllShown)
	{
		if(section==1)
			return 1; // balance
		if(section==0)//open
			return [open_items count];
		else
			return [pending_items count];			
	}
	else
	{
		if(section==1)
			return 1; // balance
		if(section==0)//open
			return [open_items count];
	}
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if(isAllShown)
	{
		if(section==1)
			return @"Balance";
		else
		if(section==0)//open
			return @"Open positions";
		else
			return @"Pending orders";			
	}
	else
	{
		if(section==1)
			return @"Balance";
		else
		if(section==0)//open
			return @"Open positions";
	}
	return @"none";
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	int section= indexPath.section;	
	
	int item_type = 0;
	if(isAllShown)
	{
		if(section==0)//open
			item_type = 0;
		else
			if(section==2)//pending
				item_type = 1;	
			else//balance
				item_type = 2;
	}
	else
	{
		if(section==0)//open
			item_type = 0;	
		else//balance
			item_type = 2;
		
	}
	if(item_type==0)//open
		return 70;
	else
	if(item_type==1)//pending
		return 55;
	else
		return 57;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
	
    static NSString *CellIdentifier = nil;
	int section= indexPath.section;	

	int item_type = 0;
	if(isAllShown)
	{
		if(section==0)//open
			item_type = 0;
		else
		if(section==2)//pending
			item_type = 1;	
		else//balance
			item_type = 2;
	}
	else
	{
		if(section==0)//open
			item_type = 0;	
		else//balance
			item_type = 2;
		
	}
	if(item_type==0)//open
	{
		TradeRecord *tr = (TradeRecord *)[open_items objectAtIndex:indexPath.row];
		
		
		BOOL isBuy = YES;
		if(tr != nil && tr.symbol!=nil && (tr.cmd%2)==0)
		{
			CellIdentifier = @"OTBuy";
			isBuy = YES;
		}
		else
		{
			CellIdentifier = @"OTSell";
			isBuy = NO;
		}
		
		
		OpenTradeCell *cell = (OpenTradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"OpenTradeCell" 
										owner:nil 
										options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (OpenTradeCell *)currentObject;
					
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
		TickData *td = [[storage Prices] objectForKey:tr.symbol];
		NSString* close_price = (tr.cmd == 0)?td.Bid:td.Ask;
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"dd.MM.yyyy HH:mm"];	
		cell.lblSymbol.text = tr.symbol;
		cell.lblOrderNo.text = [NSString stringWithFormat:@"%d", tr.order];
		cell.lblType.text = [tr cmd_str];
		cell.lblOpenTime.text = [format stringFromDate:tr.open_time];
		cell.lblVol.text = [storage formatVolume:tr.volume];
		cell.lblOpenPrice.text = [storage formatPrice:tr.open_price forSymbol:tr.symbol]; 
		cell.lblClosePrice.text = close_price;
		cell.lblSL.text = [storage formatPrice:tr.sl forSymbol:tr.symbol]; 
		cell.lblTP.text = [storage formatPrice:tr.tp forSymbol:tr.symbol]; 
		cell.lblSwap.text = [storage formatProfit:tr.storage]; 
		cell.lblCommission.text = [storage formatProfit:tr.commission];
		cell.lblPL.text = [storage formatProfit:tr.profit];
		if(tr.profit>0)
			cell.lblPL.textColor = HEXCOLOR(0x00CC00FF);
		else
			cell.lblPL.textColor = HEXCOLOR(0xCC0000FF);
		return cell;
		
	}
	else	
	if(item_type==1)//pending
	{
		TradeRecord *tr = (TradeRecord *)[pending_items objectAtIndex:indexPath.row];
		
		
		BOOL isBuy = YES;
		if(tr != nil && tr.symbol!=nil && (tr.cmd%2)==0)
		{
			CellIdentifier = @"PTBuy";
			isBuy = YES;
		}
		else
		{
			CellIdentifier = @"PTSell";
			isBuy = NO;
		}
		
		
		PendingTradeCell *cell = (PendingTradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) 
		{
			//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
			NSArray *topLevelObjects = [[NSBundle mainBundle]
										loadNibNamed:@"PendingTradeCell" 
										owner:nil 
										options:nil];
			
			for(id currentObject in topLevelObjects)
			{
				if([currentObject isKindOfClass:[UITableViewCell class]])
				{
					cell = (PendingTradeCell *)currentObject;
					
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
		TickData *td = [[storage Prices] objectForKey:tr.symbol];
		NSString* close_price = (tr.cmd == 0)?td.Bid:td.Ask;
		NSDateFormatter *format = [[NSDateFormatter alloc] init];
		[format setDateFormat:@"dd.MM.yyyy HH:mm"];	
		cell.lblSymbol.text = tr.symbol;
		cell.lblOrderNo.text = [NSString stringWithFormat:@"%d", tr.order];
		cell.lblType.text = [tr cmd_str];
		cell.lblCreateTime.text = [format stringFromDate:tr.open_time];
		cell.lblVol.text = [storage formatVolume:tr.volume];
		cell.lblOpenPrice.text = [storage formatPrice:tr.open_price forSymbol:tr.symbol]; 
		cell.lblClosePrice.text = close_price;
		cell.lblSL.text = [storage formatPrice:tr.sl forSymbol:tr.symbol]; 
		cell.lblTP.text = [storage formatPrice:tr.tp forSymbol:tr.symbol]; 
		return cell;
		
	}	
	else
	{
		CellIdentifier = @"BalanceCell";
		
		Balancecell *cell = (Balancecell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
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
		cell.lblPL.text = [storage formatProfit:storage.SumProfit];
		cell.lblBalance.text = [storage formatProfit:storage.Balance];
		double Equity = storage.Balance + storage.SumProfit;
		cell.lblEquity.text = [storage formatProfit:(storage.Balance + storage.SumProfit)];
		cell.lblMargin.text = [storage formatProfit:storage.Margin];
		cell.lblFree.text = [storage formatProfit:(Equity-storage.Margin)];
		double FreePct = 100 * Equity / storage.Margin;
		cell.lblLevel.text = [[NSString alloc] initWithFormat:@"%@%%", [storage formatProfit:(round(FreePct*10)/10)]];

		return cell;
	}
	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}





*/


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (storage.openTradesView != OPEN_TRADE_VIEW_AGR)
    {
        int section= indexPath.section;	
        
        if(section == 1) //balance
            return;
        
        TradeRecord *tr = nil;
        if(section == 0)//open
        {
            tr = [open_items objectAtIndex:indexPath.row];
        }
        else
        {
            tr = [pending_items objectAtIndex:indexPath.row];
        }
		
        TradeView * tradeViewPnl = [[TradeView alloc] initWithNibName:@"TradeView" bundle:nil];	
        tradeViewPnl.storage = storage;
        [self.navigationController pushViewController:tradeViewPnl animated:YES];
        [tradeViewPnl ShowForTrade:tr AndParams:storage];
        [tradeViewPnl autorelease];
    }
	else 
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"CLOSE", nil) message:NSLocalizedString(@"switch_to_normal", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
 // Return YES for supported orientations
	return NO;// (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 

#pragma mark - Popover handling

- (WEPopoverContainerViewProperties *)improvedContainerViewProperties 
{
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 4.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

- (IBAction)showPopover:(id)sender 
{	
	if (!self.popoverController)
    {		
		OpenPosViewChoices *contentViewController = [[OpenPosViewChoices alloc] initWithStyle:UITableViewStylePlain];
		self.popoverController = [[[popoverClass alloc] initWithContentViewController:contentViewController] autorelease];
		self.popoverController.delegate = self;
		self.popoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		[contentViewController setParentController:self];
        [contentViewController setCurrentView:[storage openTradesView]];
		
		CGRect rect = CGRectMake(262, 27, 53, 30);
		/*[self.popoverController presentPopoverFromBarButtonItem:sender
									   permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
													   animated:YES];*/
		[self.popoverController presentPopoverFromRect:rect 
												inView:[self.popoverController keyView] 
							  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) 
											  animated:YES];
        
		[contentViewController release];
	}
    else
    {
		[self dismissPopover];
	}
}

- (void)dismissPopover
{
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

- (void)dismissPopoverAndChangeToView:(OpenTradesViewType)openTradesViewType
{
    [self dismissPopover];
    [storage setOpenTradesView:openTradesViewType];
    
    switch (openTradesViewType)
    {
		case OPEN_TRADE_VIEW_POINTS:
			[self rebind:NO];
			break;

        case OPEN_TRADE_VIEW_DEPOSIT_CUR:
            if (aggragateViewControl)
            {
                [aggragateViewControl release];
                aggragateViewControl = nil;
            }
            [self rebind:NO];
            break;
        case OPEN_TRADE_VIEW_AGR:
            aggragateViewControl = [AggrOpenPosWatch new];
            [aggragateViewControl setGridCtl:gridCtl];
            [aggragateViewControl setParent:self];
            [aggragateViewControl rebild:NO];
            break;
        default:
            break;
    }
}

#pragma mark - WEPopoverControllerDelegate implementation

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController 
{
	//Safe to release the popover here
	self.popoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController 
{
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

@end