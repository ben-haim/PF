
#import "TradePaneController.h"
#import "TradeProgress.h"
#import "MySingleton.h"
#import "Base64.h"
#import "iTraderAppDelegate.h"
#import "CustomAlert.h"

#import <ProFinanceApi/ProFinanceApi.h>

typedef enum
{
   PFOrderPendingBuyLimit
   , PFOrderPendingSellLimit
   , PFOrderPendingBuyStop
   , PFOrderPendingSellStop
} PFOrderPendingType;

@implementation TradePaneController
@synthesize lblSymbol;
@synthesize btnBuy, btnSell, btnPlacePending;
@synthesize edtVol, edtSL, edtTP;
@synthesize lblBidPrice1;
@synthesize lblBidPrice2;
@synthesize lblBidPrice3;
@synthesize lblAskPrice1;
@synthesize lblAskPrice2;
@synthesize lblAskPrice3;
@synthesize chart, storage;
@synthesize pnlInstant, pnlPending, btnPendingType, edtPendingPrice;
@synthesize lblTitleAtPrice, lblTitleVol, lblTitleSL, lblTitleTP, lblTitleBuy, lblTitleSell;
@synthesize segmentedControl, titleLabel, trade_edit_bg, trade_bg;
@synthesize pricePicker, volPopup, clearPopup, clear_panel;
@synthesize mytype, sym;
@synthesize modal_chart;

- (void)dealloc 
{
	//[lblSymbol dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[segmentedControl release];
	[segmentBarItem release];
	[titleLabel release];
	[trade_bg release];
	[pricePicker release];
	[modal_chart release];
	[sym release];
	
    [super dealloc];
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
- (void) UpdatePrices:(TickData*)dat
{
	NSString *p1, *p2, *p3;
	[storage SplitPrice:dat.Bid P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
	
	lblBidPrice1.text = p1;
	lblBidPrice2.text = p2;
	lblBidPrice3.text = p3;
	
	[storage SplitPrice:dat.Ask P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
	
	lblAskPrice1.text = p1;
	lblAskPrice2.text = p2;
	lblAskPrice3.text = p3;	
	bid = [dat.Bid doubleValue];
	ask = [dat.Ask doubleValue];
}

-(void)ShowForSymbol:(SymbolInfo *)si AndParams:(ParamsStorage*)p;
{
	sym = si;
	
	if (self.ExecMode == 2)
	{
		[segmentedControl setTitle:NSLocalizedString(@"BUTTONS_MARKET_EXECUTION", nil) forSegmentAtIndex:0];
		//edtSL.enabled = NO;
		//edtTP.enabled = NO;		
	}
	else 
	{
		[segmentedControl setTitle:NSLocalizedString(@"BUTTONS_INSTANT", nil) forSegmentAtIndex:0];
		edtSL.enabled = (si.TradeMode==2);
		edtTP.enabled = (si.TradeMode==2);
	}
    
	storage = p;	
 	
    lblSymbol.text = sym.Desc;
	
	titleLabel.text = sym.Symbol;
	
 	btnBuy.enabled = (si.TradeMode==2);
 	btnSell.enabled = (si.TradeMode==2);
	btnPlacePending.enabled = (si.TradeMode==2);
	
	edtPendingPrice.enabled = (si.TradeMode==2);
	edtVol.enabled = (si.TradeMode==2);

	[chart ShowForSymbol:si AndParams:p];
	
	[edtSL setTitle:[storage formatPrice:0 forSymbol:sym.Symbol] forState:UIControlStateNormal];
	[edtTP setTitle:[storage formatPrice:0 forSymbol:sym.Symbol] forState:UIControlStateNormal];
	TickData *dat = [[storage Prices] objectForKey:sym.Symbol];
	if(dat!=nil)
		[self UpdatePrices:dat];
	
	NSString *str = [storage formatVolume:0];
	edtVol.text = str;
	[edtPendingPrice setTitle:@"" forState:UIControlStateNormal];
	[edtPendingPrice setTitle:@"" forState:UIControlStateHighlighted];
	[btnPendingType setSelectedSegmentIndex:0];
    
    [segmentedControl setSelectedSegmentIndex:0];
    [self segmentAction:segmentedControl];
}

- (int) ExecMode
{
	//NSLog(@"%d", sym.ExecMode);
	return sym.ExecMode;
}

-(void)goBack:(id)sender
{
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	int i = 0;
	for (UIViewController *aController in [[appDelegate mainView] viewControllers]) 
	{
		
		if ([aController.title isEqualToString:NSLocalizedString(@"TABS_POSITIONS", nil)])
		{
			[[appDelegate mainView] setSelectedIndex:i];
		}

		i++;
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack:) name:@"order_proccessed" object:nil];
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		UIImageView *imgView = [[[UIImageView alloc] initWithImage:image] autorelease];
		imgView.contentMode = UIViewContentModeScaleAspectFit;
		self.navigationItem.titleView = imgView;
	}

	UIImage *img1 = [UIImage imageNamed:@"trade_edit_bg.png"];
	UIImage *stretchImage1 = [img1 stretchableImageWithLeftCapWidth:7 topCapHeight:7];
	
	[trade_edit_bg setImage:stretchImage1];
	
	CGRect labelFrame = CGRectMake(0, 0, 140, 40);//self.navigationItem.titleView.bounds;
	//UILabel *
	titleLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	titleLabel.textAlignment = UITextAlignmentCenter;
	//titleLabel.text = sym.Symbol;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:18];
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 12;	
	titleLabel.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = titleLabel;
	
//	self.navigationItem.titleView = [UIView alloc] ini //[[[ alloc] initWithImage:image] autorelease];
	
	lblTitleAtPrice.text = NSLocalizedString(@"TRADE_AT_PRICE", nil);	
	lblTitleVol.text = NSLocalizedString(@"ORDER_VOLUME", nil);
	[btnPlacePending setTitle:NSLocalizedString(@"ORDER_PLACE_APPENDING", nil) forState:UIControlStateNormal];
	[btnPlacePending setTitle:NSLocalizedString(@"ORDER_PLACE_APPENDING", nil) forState:UIControlStateHighlighted];
		
	lblSymbol.text = sym.Desc;
	[self.navigationItem setTitle:sym.Symbol];	
	//[storage.charts GetChart:sym.Symbol AndRange:@"1"];
	TickData *dat = [[storage Prices] objectForKey:sym.Symbol];
	if(dat!=nil)
		[self UpdatePrices:dat];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChanged" object:nil];		

	
	segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 NSLocalizedString(@"BUTTONS_INSTANT", nil),
											 NSLocalizedString(@"BUTTONS_PENDING", nil),
											 nil]];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	segmentedControl.selectedSegmentIndex = 0;
	
	segmentedControl.tintColor = [[MySingleton sharedMySingleton] segmentedColor]; //[UIColor darkGrayColor];
	
	
	
	
	
	
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;	
	
	segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	self.navigationItem.rightBarButtonItem = segmentBarItem; 
	
	segmentBarItem.style = UISegmentedControlStyleBar;

	//chart.parent = self;
	self.chart = [[[ChartViewController alloc] initWithNibName:@"ChartView" bundle:nil]autorelease];
	self.chart.storage = storage;
    self.chart.parentVC = self;
	[self.chart setMytype:[self mytype]];
	[[self view] addSubview:[self.chart view]];
	[[self.chart view] setFrame: CGRectMake(0, 155, 320, 220)]; 
	//[chart.chart_view RecalcScroll];
	
	//modal_chart = [[ChartViewController alloc] initWithNibName:@"ChartView" bundle:nil];
//	modal_chart.storage = storage;
	
	//[chart ShowForSymbol:sym AndParams:storage];
	//[chart buttonsAction:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(maximizeChart:) name: @"maximizeChart" object: nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(minimizeChart:) name: @"minimizeChart" object: nil];
	
    numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setDecimalSeparator:@"."];
	[numberFormatter setGeneratesDecimalNumbers:TRUE];
	[numberFormatter setMinimumIntegerDigits:1];
}


-(void)viewDidDisappear:(BOOL)animated
{
	[edtVol resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
	//[storage.charts setCurrentSymbol:@"" ForScreen:[self mytype]];
}

- (void)viewDidAppear:(BOOL)animate 
{
	[storage.charts setCurrentSymbol:[sym Symbol] ForScreen:[self mytype]];
    if (modal_chart != nil)
    {
        if(modal_chart.chart_view.chart_data != nil)
        {
            [modal_chart.chart_view newBarAdded];
        }
    }
    if (chart != nil)
    {
        if(chart.chart_view.chart_data != nil)
        {
            [chart.chart_view newBarAdded];
        }
    }
}
	 
- (void) segmentAction:(id)sender 
{
	segmentedControl = (UISegmentedControl *)sender;
	int index =  [segmentedControl selectedSegmentIndex];

	pnlInstant.hidden = (index==1);
	pnlPending.hidden = (index==0);
	
	[self HideSpinner:self];
	
	if (index == 0)
	{
		if (self.ExecMode == 2)
		{
			edtSL.enabled = NO;
			edtTP.enabled = NO;
		}
		else 
		{
			edtSL.enabled = (sym.TradeMode==2);
			edtTP.enabled = (sym.TradeMode==2);
		}
	}
	else
	{
		edtSL.enabled = (sym.TradeMode==2);
		edtTP.enabled = (sym.TradeMode==2);
	}
	
    NSString *zeroVolume = [storage formatPrice:0 forSymbol:sym.Symbol];
    [edtSL setTitle:zeroVolume forState:UIControlStateNormal];
    [edtTP setTitle:zeroVolume forState:UIControlStateNormal];
}

-(void) maximizeChart: (NSNotification*) notification
{
	ChartViewController *temp = (ChartViewController *)[notification object];
	if([[[temp sym] Symbol] isEqualToString:[[self sym] Symbol]] && [temp mytype] == [self mytype])
	{
		
		//NSString *temp = (NSString *)[notification object];
		//if([temp isEqualToString:[[self sym] Symbol] ])
		//{		
			//small_chart_rect = chart.view.frame;
			//chart.chart_view.isMaximized = NO;
		
			modal_chart = [[ChartViewController alloc] initWithNibName:@"ChartView" bundle:nil];
			[self.parentViewController.parentViewController presentModalViewController:modal_chart animated:YES];
			modal_chart.storage = storage;
			[modal_chart ShowForSymbol:sym AndParams:storage];
			[modal_chart buttonsAction:nil];
			[modal_chart.chart_view RecalcScroll];
            modal_chart.parentVC = self;
        
			//modal_chart.chart_view.isMaximized = YES;
			modal_chart.mytype = [self mytype];
		
			//[self.parentViewController.parentViewController presentModalViewController:modal_chart animated:YES];
			//[modal_chart release];
			
			[chart.chart_view RecalcScroll];
			[chart.chart_view setNeedsDisplay];
			[chart.chart_view RecalcScroll];
		//}
	}
}

-(void) minimizeChart: (NSNotification*) notification
{
	ChartViewController *temp = (ChartViewController *)[notification object];
	if([[[temp sym] Symbol] isEqualToString:[[self sym] Symbol]] && [temp mytype] == [self mytype])
	{
	//chart = (ChartViewController*)[[self modalViewController] retain];
	//[[NSNotificationCenter defaultCenter] removeObserver:modal_chart];
		[self.parentViewController.parentViewController dismissModalViewControllerAnimated:NO];
	//[modal_chart release];
//	[[self view] addSubview:[self.chart view]];
	//[[self.chart view] setFrame: small_chart_rect]; 
	//[chart.chart_view RecalcScroll];
//	[chart.chart_view setNeedsDisplay];
	}
}

-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3
{	
	int pos = 0;
	int len = [Price length];
	if (len<3) 
	{
		*p1 = @" ";
		*p2 = Price;
		*p3 = @" ";
	}
	else if (len>0) {
		
		NSRange r;
		if(sym.Digits == 3 || sym.Digits == 5)
		{
			pos++;
			r.location = len-pos;
			r.length = 1;
			*p3 = [Price substringWithRange:r];
		}
		else
			*p3 = @" ";
		pos+=2;
		r.location = len-pos;
		r.length = 2;
		*p2 = [Price substringWithRange:r]; 
		//*p2 = Regex.Replace(s, @"dfsd", "");
		if (len>pos)
			*p1 = [Price substringToIndex:len-pos];
		else 
			*p1 = @" ";
	}
	else
	{
		*p1 = @" ";
		*p2 = @" ";
		*p3 = @" ";
	}
}

- (void)priceChanged:(NSNotification *)notification
{
	//TickData *dat = (TickData *)[notification object];
	//if(![dat.Symbol isEqualToString:sym.Symbol])
		//return;
	//Handle
	@try
	{	
//		NSLog(@"price update for chart: %@", sym.Symbol);
		TickData *dat = [storage.Prices objectForKey:sym.Symbol];
		if(dat!=nil)
			[self UpdatePrices:dat];
	}
	@catch (...) 
	{
		;//
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[chart.chart_view RecalcScroll];
	[chart.chart_view setNeedsDisplay];
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
	//[chart.chart_view RecalcScroll];
	[chart.chart_view setNeedsDisplay];
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextBox
{
	[aTextBox resignFirstResponder];
	return YES;
}

- (IBAction) textFieldDidBeginEditing:(id)sender   
{
	[self HideSpinner:self];
	
	UITextField *textField = (UITextField *)sender;	
	textField.textColor = [UIColor blackColor];
}

- (IBAction) textFieldEditingDidEnd:(id)sender   
{
	UITextField *textField = (UITextField *)sender;	
	if([textField.text length]==0)
		textField.text = @"0";
}

- (IBAction) buyClicked:(id)sender
{	
    if ([edtVol.text doubleValue] == 0)
    {
        [self showVolumeZeroDialog];
    }
    else
    {
        [self DoInstantOrder:PFMarketOperationBuy];
    }
}

//////////////////////////////////////////////////////////////////
// Number Picker Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)picker {
	// Number of columns you want (1 column is like in when clicking an <select /> in Safari, multi columns like a date selector)
	if (sym.Digits == 5) 
		pickerComponentsCount = 4; //return 4;
	else if (sym.Digits == 4)
		pickerComponentsCount = 3; //return 3;
	else if (sym.Digits == 3)
		pickerComponentsCount = 3; //return 3;
	else if (sym.Digits == 2)
		pickerComponentsCount = 2; //return 2;
	else 
		pickerComponentsCount = 2; //return 1;
	
	return pickerComponentsCount;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {

	return 16384;
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{  
    NSString *title = nil;
	if(component == 0)
	{
		if (sym.Digits != 0)
			title = [NSString stringWithFormat:@"%d.", row];
		else 
			title = [NSString stringWithFormat:@"%d", row];
		
	}
	
	else if ((sym.Digits == 5 && component == 3) || (sym.Digits == 3 && component == 2) || (sym.Digits == 1 && component == 1)) 
	{
		title = [NSString stringWithFormat:@"%d", row%10];
	}
	
	else
	{
		title = [NSString stringWithFormat:@"%02d", row%100];
	}
	NSNumber *c = [NSNumber numberWithInteger:[title integerValue]];
	title = [numberFormatter stringFromNumber:c];
	return title;  // give titles
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	[self getSpinnerValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	if (component == pickerComponentsCount-1 && (sym.Digits == 3 || sym.Digits == 5))
		return 50;
	else if (component == 0)
		return 80;
	else 
		return 60;
}

-(void) showSpinner: (BOOL)forBid IsPending: (BOOL)isPendingOrder
{
	//if (pricePicker != nil)
	//	return;
		
	NSString *p1, *p2, *p3;
	
	[self HideSpinner:self];
	
	[self ValidateTextEdit:edtVol];
	
	NSString *price1;
	NSString *price2;
	NSString *price3;
	if (forBid)         // if is SL
	{
		isSL = YES;
		isPending = NO;
		if ([edtSL.titleLabel.text floatValue] == 0)
		{
			price1 = lblBidPrice1.text;
			price2 = lblBidPrice2.text;
			price3 = lblBidPrice3.text;
		}
		else 
		{
			[storage SplitPrice:edtSL.titleLabel.text P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			price1 = p1;
			price2 = p2;
			price3 = p3;
		}

	}
	else if (isPendingOrder) // else if is Pending order
	{
		isSL = NO;
		isPending = YES;
		//if ([edtPendingPrice.titleLabel.text floatValue] == 0)
		//{
			price1 = lblBidPrice1.text;
			price2 = lblBidPrice2.text;
			price3 = lblBidPrice3.text;
		//}
		//else 
		//{
		//	[storage SplitPrice:edtPendingPrice.titleLabel.text P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
		//	price1 = p1;
		//	price2 = p2;
		//	price3 = p3;
		//}
		
		
		
		
		/*
		price1 = lblBidPrice1.text;
		price2 = lblBidPrice2.text;
		price3 = lblBidPrice3.text;*/
	}
	else //if (!forBid)    // else if is TP
	{
		isSL = NO;
		isPending = NO;
		if ([edtTP.titleLabel.text floatValue] == 0)
		{
			price1 = lblAskPrice1.text;
			price2 = lblAskPrice2.text;
			price3 = lblAskPrice3.text;
		}
		else
		{
			[storage SplitPrice:edtTP.titleLabel.text P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			price1 = p1;
			price2 = p2;
			price3 = p3;
		}
	}
	
	
	pricePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 480, 320, 300)]; //y=152 heigh=300
	pricePicker.showsSelectionIndicator = YES;
	
	
	//[newView setFrame:CGRectMake( 0.0f, 480.0f, 320.0f, 480.0f)]; //notice this is OFF screen!
	//[pricePicker setFrame:CGRectMake(0, 480, 320, 300)];
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	[pricePicker setFrame:CGRectMake(0, 152, 320, 300)]; //notice this is ON screen! y=152
	[UIView commitAnimations];
	
	[pricePicker setDelegate:self];
    [pricePicker setDataSource:self];
	[[self view] addSubview:pricePicker];
	[self showHideButton:self];
	
	[pricePicker selectRow:[price1 intValue] inComponent:0 animated:NO]; // first component
	
	if (sym.Digits == 0 || sym.Digits == 1)
	{
		int tmpPrice = [price2 intValue];
		if (sym.Digits == 1 && [price2 length]>1)	
			tmpPrice = [[price2 substringFromIndex:1] intValue];
		/*if (sym.Digits == 1)
		{
			tmpPrice *= 10;
		}*/
		[pricePicker selectRow:(tmpPrice+5000) inComponent:1 animated:NO]; 
		
		return;
	}
	
	if (sym.Digits == 3 || sym.Digits == 5)
	{
        int componentIndex = (pickerComponentsCount-1);
        if (componentIndex < 0)
        {
            componentIndex = 0;
        }
		[pricePicker selectRow:([price3 intValue]+5000) inComponent:componentIndex animated:NO]; // last component
        componentIndex = (pickerComponentsCount-2);
        if (componentIndex < 0)
        {
            componentIndex = 0;
        }
		[pricePicker selectRow:([price2 intValue]+5000) inComponent:componentIndex animated:NO];
		if (sym.Digits == 5)
		{
			int tmpPrice = round( ([price1 doubleValue] - [price1 intValue]) * 100);
			[pricePicker selectRow:tmpPrice+5000 inComponent:1 animated:NO];
			
		}
	}
	else 
	{
		[pricePicker selectRow:([lblBidPrice2.text intValue]+5000) inComponent:(pickerComponentsCount-1) animated:NO]; // last component
		if (sym.Digits == 4)
		{
			int tmpPrice = round( ([price1 doubleValue] - [price1 intValue]) * 100);
			[pricePicker selectRow:tmpPrice+5000 inComponent:1 animated:NO];
		}
	}
	
}

- (IBAction) SLClicked:(id)sender
{
	if (pricePicker != nil && isSL==YES)
		return;
	[self showSpinner:YES IsPending:NO];
	
	//if (isClearPanel_rotated)
	//{
		[self rotateClearPanel];
	//	isClearPanel_rotated = NO;
	//}
	
	 [clearPopup setFrame:CGRectMake(162, -100, 48, 44)];
	 [UIView beginAnimations:@"animateTableView" context:nil];
	 [UIView setAnimationDuration:0.5];
	 [clearPopup setFrame:CGRectMake(162, -5, 48, 44)]; 
	 [UIView commitAnimations];
	
}

- (IBAction) TPClicked:(id)sender
{
	if (pricePicker != nil && isSL==NO && isPending==NO)
		return;
	[self showSpinner:NO IsPending:NO];
	
	//if (isClearPanel_rotated)
	//{
		[self rotateClearPanel];
	//	isClearPanel_rotated = NO;
	//}
	
	[clearPopup setFrame:CGRectMake(263, -100, 48, 44)];
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.5];
	[clearPopup setFrame:CGRectMake(263, -5, 48, 44)]; 
	[UIView commitAnimations];
}

- (IBAction) PendingClicked:(id)sender
{
	if (pricePicker != nil && isPending == YES)
		return;
	[self showSpinner:NO IsPending:YES];
	
	if (!isClearPanel_rotated)
	{
		[self rotateClearPanel];
		isClearPanel_rotated = YES;
	}
	
	//clear_panel.transform = CGAffineTransformMakeRotation(3.14);
	//[clear_panel setFrame:CGRectMake(clear_panel.bounds.origin.x, clear_panel.bounds.origin.y+5, clear_panel.bounds.size.width, clear_panel.bounds.size.height)];
	
	[clearPopup setFrame:CGRectMake(95, -100, 48, 44)];
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.5];
	[clearPopup setFrame:CGRectMake(95, 72, 48, 44)]; 
	[UIView commitAnimations];
}

-(void)rotateClearPanel
{
	//if (isClearPanel_rotated)
	//{
	//	clear_panel.transform = CGAffineTransformMakeRotation(0);
	//	[clear_panel setFrame:CGRectMake(clear_panel.bounds.origin.x, clear_panel.bounds.origin.y, clear_panel.bounds.size.width, clear_panel.bounds.size.height)];
	//}
	//else
	//{
	//	clear_panel.transform = CGAffineTransformMakeRotation(3.14);
	//	[clear_panel setFrame:CGRectMake(clear_panel.bounds.origin.x, clear_panel.bounds.origin.y+5, clear_panel.bounds.size.width, clear_panel.bounds.size.height)];
	//}
	
}

-(void) showHideButton:(id)sender
{
	UIBarButtonItem *btnHide = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HIDE", nil)  
																 style:UIBarButtonItemStyleBordered 
																target:self 
																action:@selector(HideSpinner:)] autorelease];
	
	self.navigationItem.leftBarButtonItem = btnHide; 
}

-(void) HideSpinner:(id)sender
{
	/*[pricePicker setFrame:CGRectMake(0, 480, 320, 80)];
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	[pricePicker setFrame:CGRectMake(0, 480, 320, 80)]; 
	[UIView commitAnimations];*/
	
	if (pricePicker == nil)
		return;
	
	self.navigationItem.leftBarButtonItem = nil;
	[pricePicker removeFromSuperview];
	[pricePicker release];
	pricePicker = nil;
	
	[clearPopup setFrame:CGRectMake(0, 500, 320, 80)];

}

-(NSString*) getSpinnerValue
{
	NSString *price;
	
	if (sym.Digits == 0)
		price = [NSString stringWithFormat:@"%d%02d", [pricePicker selectedRowInComponent:0],
				  [pricePicker selectedRowInComponent:1]%100];
	else if (sym.Digits == 1)
		price = [NSString stringWithFormat:@"%d.%d", [pricePicker selectedRowInComponent:0],
				 [pricePicker selectedRowInComponent:1]%10];
	else if (sym.Digits == 2)
		price = [NSString stringWithFormat:@"%d.%02d", [pricePicker selectedRowInComponent:0],
				 [pricePicker selectedRowInComponent:1]%100];
	else if (sym.Digits == 3)
		price = [NSString stringWithFormat:@"%d.%02d%d", [pricePicker selectedRowInComponent:0],
				 [pricePicker selectedRowInComponent:1]%100, [pricePicker selectedRowInComponent:2]%10];
	else if (sym.Digits == 4)
		price = [NSString stringWithFormat:@"%d.%02d%02d", [pricePicker selectedRowInComponent:0],
				 [pricePicker selectedRowInComponent:1]%100, [pricePicker selectedRowInComponent:2]%100];
	else if (sym.Digits == 5)
		price = [NSString stringWithFormat:@"%d.%02d%02d%d", [pricePicker selectedRowInComponent:0],
				 [pricePicker selectedRowInComponent:1]%100, [pricePicker selectedRowInComponent:2]%100,
				 [pricePicker selectedRowInComponent:3]%10];
	
	price = [storage formatPrice:[price doubleValue] forSymbol:sym.Symbol];
	
	if (isSL)
		[edtSL setTitle:price forState:UIControlStateNormal];
	else if (isPending)
		[edtPendingPrice setTitle:price forState:UIControlStateNormal];
	else
		[edtTP setTitle:price forState:UIControlStateNormal];
	
	return price;
}

-(void)viewWillAppear:(BOOL)animated
{
	[volPopup setFrame:CGRectMake(volPopup.frame.origin.x, -150, volPopup.frame.size.width, volPopup.frame.size.height)];
	[clearPopup setFrame:CGRectMake(162, 500, 48, 44)];
	NSLog(@"TradePaneController viewWillAppear for symbol: %@", [sym Symbol]);
}

//////////////////////////////////////////////////////////////////
// Volume Picker Methods

- (IBAction) ValidateVolume:(id)sender
{
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? sym.Lot_Min * 100 : round([edtVol.text doubleValue] * 100);
	unsigned long step = round(sym.Lot_Step * 100);	
	unsigned long mod = vol1 % step;
    
	double vol = (vol1 - mod) / 100.0 ;
	
	
	//NSLog(@"vol1:%d, vol:%f, step:%d, mod:%d", vol1, vol, step, mod);
	
	if (vol <= sym.Lot_Min)
    {
        vol1 = sym.Lot_Min * 100;
        mod = vol1 % step;
        if (mod == 0) 
        {
            vol = vol1 / 100.0 ;
        }
        else
        {
            vol = (vol1 + step - mod) / 100.0 ;
        }

    }
	else if (vol > sym.Lot_Max)
    {
		vol = sym.Lot_Max;
	}
    edtVol.text = [storage formatVolume:vol];
}

- (IBAction) volumeClicked:(id)sender
{
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.5];
	[volPopup setFrame:CGRectMake(volPopup.frame.origin.x, -13, volPopup.frame.size.width, volPopup.frame.size.height)]; 
	[UIView commitAnimations];
}

-(IBAction) HideVolume:(id)sender
{
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	[volPopup setFrame:CGRectMake(volPopup.frame.origin.x, -150, volPopup.frame.size.width, volPopup.frame.size.height)]; 
	[UIView commitAnimations];
}

- (IBAction) volumeUpClicked:(id)sender
{			
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? 0 : round([edtVol.text doubleValue] * 100);
	unsigned long step = round(sym.Lot_Step * 100);	
	unsigned long mod = vol1 % step;

	double vol = (vol1 + step - mod) / 100.0 ;
	
	
	//NSLog(@"vol1:%d, vol:%f, step:%d, mod:%d", vol1, vol, step, mod);
	
	if (vol <= sym.Lot_Min)
    {
        vol1 = sym.Lot_Min * 100;
        mod = vol1 % step;
        if (mod == 0) 
        {
            vol = vol1 / 100.0 ;
        }
        else
        {
            vol = (vol1 + step - mod) / 100.0 ;
        }
    }
	else if (vol > sym.Lot_Max)
    {
		vol = sym.Lot_Max;
	}
    edtVol.text = [storage formatVolume:vol];
}

- (IBAction) volumeDownClicked:(id)sender
{
	//double vol = [edtVol.text doubleValue];
	//vol -= sym.Lot_Step;
	//double mod = fmod(vol, sym.Lot_Min);
	//vol -= mod;
	
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? sym.Lot_Min * 100 : round([edtVol.text doubleValue] * 100);
	unsigned long step = round(sym.Lot_Step * 100);	
	unsigned long mod = vol1 % step;
	
	double vol = (vol1 - step - mod) / 100.0 ;
	long volCheck = vol1 - step - mod;
	if (volCheck <= sym.Lot_Min * 100)
    {
        vol1 = sym.Lot_Min * 100;
        mod = vol1 % step;
        if (mod == 0) 
        {
            vol = vol1 / 100.0 ;
        }
        else
        {
            vol = (vol1 + step - mod) / 100.0 ;
        }
    }
	else if (vol > sym.Lot_Max)
    {
		vol = sym.Lot_Max;
	}
    edtVol.text = [storage formatVolume:vol];
}

- (IBAction) volumeUp10Clicked:(id)sender
{
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? 0 : round([edtVol.text doubleValue] * 100);
	unsigned long step = round(sym.Lot_Step*100);	
	unsigned long mod = vol1 % step;
	
	double vol = (vol1 + step*10 - mod)/100.0 ;
	
	if (vol <= sym.Lot_Min)
    {
        vol1 = sym.Lot_Min * 100;
        mod = vol1 % step;
        if (mod == 0) 
        {
            vol = vol1 / 100.0 ;
        }
        else
        {
            vol = (vol1 + step - mod) / 100.0 ;
        }
    }
	else if (vol > sym.Lot_Max)
    {
		vol = sym.Lot_Max;
	}
    edtVol.text = [storage formatVolume:vol];
}

- (IBAction) volumeDown10Clicked:(id)sender
{
	long vol1 = ([edtVol.text doubleValue] <= 0) ? sym.Lot_Min * 100 : round([edtVol.text doubleValue] * 100);
	long step = round(sym.Lot_Step*100);	
	long mod = vol1 % step;
	
	double vol = (vol1 - step*10 - mod)/100.0 ;
	
	//NSLog(@"vol1:%d, step:%d, mod:%d, vol:%f, lot_min:%f, lot_max:%f", vol1, step, mod, vol, sym.Lot_Min, sym.Lot_Max);
	
	if (vol <= sym.Lot_Min)
    {
        vol1 = sym.Lot_Min * 100;
        mod = vol1 % step;
        if (mod == 0) 
        {
            vol = vol1 / 100.0 ;
        }
        else
        {
            vol = (vol1 + step - mod) / 100.0 ;
        }
    }
	else if (vol > sym.Lot_Max)
    {
		vol = sym.Lot_Max;
	}
    edtVol.text = [storage formatVolume:vol];
}

//////////////////////////////////////////////////////////////////

- (IBAction) sellClicked:(id)sender
{
    if ([edtVol.text doubleValue] == 0)
    {
        [self showVolumeZeroDialog];
    }
    else
    {
        [self DoInstantOrder:PFMarketOperationSell];
    }
}


- (IBAction) placePending:(id)sender
{
    if ([edtVol.text doubleValue] == 0)
    {
        [self showVolumeZeroDialog];
    }
    else
    {
        [self HideSpinner:self];
        
        //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
        //[prefs setObject:edtVol.text forKey:[@"volume_" stringByAppendingString:sym.Symbol]];
        
        if(![self ValidateTextEdit:edtVol])
            return;
        //if(![self ValidateTextEdit:edtSL])
		//return;
        //if(![self ValidateTextEdit:edtTP])
        //	return;
        //if(![self ValidateTextEdit:edtPendingPrice])
        //	return;

       PFOrder* order_ = [ PFOrder new ];

       PFOrderPendingType pending_type_ = btnPendingType.selectedSegmentIndex;
       
       BOOL is_limit_ = pending_type_ == PFOrderPendingBuyLimit || pending_type_ == PFOrderPendingSellLimit;
       order_.type = is_limit_ ? PFOrderLimit : PFOrderStop;
       order_.instrumentId = sym.instrumentId;
       order_.routeId = sym.routeId;
       order_.accountId = self.storage.account.accountId;
       
       BOOL is_buy_ = pending_type_ == PFOrderPendingBuyLimit || pending_type_ == PFOrderPendingBuyStop;
       order_.operationType = is_buy_ ? PFMarketOperationBuy : PFMarketOperationSell;

       order_.price = [edtPendingPrice.titleLabel.text doubleValue];

       order_.amount = [edtVol.text doubleValue];
       order_.takeProfitPrice = [edtTP.titleLabel.text doubleValue];
       order_.stopLossPrice = [edtSL.titleLabel.text doubleValue];
       
       [ [ PFSession sharedSession ] createOrder: order_ ];
       
       [ order_ release ];
       
        //[self.navigationController popViewControllerAnimated:NO];
    }
}

-(BOOL)ValidateTextEdit:(UITextField*)aTextBox
{	
	[aTextBox resignFirstResponder];
	if(![storage validateFloat:aTextBox.text])
	{
		aTextBox.textColor = [UIColor redColor];
		if([aTextBox.text length]==0)
			aTextBox.text = @"*";
		return NO;
	}
	
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	//[prefs setObject:self.edtVol.text forKey:@"volume"];
	
	return YES;
}
-(void)DoInstantOrder:(PFMarketOperationType)operation_type_
{
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];	
	//[prefs setObject:edtVol.text forKey:[@"volume_" stringByAppendingString:sym.Symbol]];

	[self HideSpinner:self];
	
	if(![self ValidateTextEdit:edtVol])
		return;
	//if(![self ValidateTextEdit:edtSL])
		//return;
	//if(![self ValidateTextEdit:edtTP])
		//return;

   PFOrder* order_ = [ PFOrder new ];
   
   order_.type = PFOrderMarket;
   order_.instrumentId = sym.instrumentId;
   order_.routeId = sym.routeId;
   order_.accountId = self.storage.account.accountId;
   order_.operationType = operation_type_;
   order_.price = operation_type_ == PFMarketOperationBuy?ask:bid;
   order_.amount = [edtVol.text doubleValue];
   order_.takeProfitPrice = [edtTP.titleLabel.text doubleValue];
   order_.stopLossPrice = [edtSL.titleLabel.text doubleValue];

   [ [ PFSession sharedSession ] createOrder: order_ ];
   
   [ order_ release ];
}

- (IBAction) clearSL:(id)sender
{
	[edtSL setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateNormal];
	[edtSL setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
}
- (IBAction) clearTP:(id)sender
{
	[edtTP setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateNormal];
	[edtTP setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
}

- (IBAction) clearPending:(id)sender
{
	[edtPendingPrice setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateNormal];
	[edtPendingPrice setTitle:[storage formatPrice:0.0 forSymbol:sym.Symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
}

- (IBAction) clearField:(id)sender
{
	if (isPending)
		[self clearPending:self];
	else if (isSL)
		[self clearSL:self];
	else 
		[self clearTP:self];
}

- (void)showVolumeZeroDialog
{
    CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"RET_TRADE_BAD_VOLUME", nil)
                                                    message:NSLocalizedString(@"TRADE_VOLUME_CANNOT_BE_ZERO", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

@end
