

#import "TradeView.h"
#import "iTraderAppDelegate.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation TradeView
@synthesize storage, tr;
@synthesize lblSymbol, lblOrderNo;
@synthesize lblOpenTime;
@synthesize lblSwap;
@synthesize lblOrderType;
@synthesize lblProfit;
@synthesize lblVolume, edtOpenPrice, lblClosePrice;
@synthesize edtSL, edtTP, edtVol;
@synthesize btnClose, btnUpdate, btnDelete;
@synthesize lblExecution;
@synthesize lblCommission;

@synthesize lblTitleOrderNo;
@synthesize lblTitleOpenTime;
@synthesize lblTitleSymbol;
@synthesize lblTitleBuyLimit;
@synthesize lblTitleSwap;
@synthesize lblTitleOpenPrice;
@synthesize lblTitleClosePrice;
@synthesize lblTitleVolume;
@synthesize lblTitleProfit;
@synthesize lblTitleCommission;
@synthesize lblTitleSL;
@synthesize lblTitleTP;
@synthesize lblVolOriginal;
@synthesize line, bgView, edtVolView, volPopup, pricePicker;
@synthesize btnClearSL, btnClearTP, btnClearPrice;

- (void) initialize
{
	lblTitleOrderNo.text = [NSLocalizedString(@"SCREEN_TRADE_PROGRESS", nil) stringByAppendingString:@":"];
	lblTitleOpenTime.text = [NSLocalizedString(@"OPEN_TIME", nil) stringByAppendingString:@":"];
	lblTitleSymbol.text = [NSLocalizedString(@"SYMBOL", nil) stringByAppendingString:@":"];
	lblTitleSwap.text = NSLocalizedString(@"ORDER_SWAP", nil);
	lblTitleOpenPrice.text = [NSLocalizedString(@"OPEN_PRICE", nil) stringByAppendingString:@":"];
	lblTitleClosePrice.text = [NSLocalizedString(@"CLOSE_PRICE", nil) stringByAppendingString:@":"];
	lblTitleVolume.text = NSLocalizedString(@"ORDER_VOLUME", nil);
	lblTitleProfit.text = NSLocalizedString(@"ORDER_PL", nil);
	lblTitleCommission.text = NSLocalizedString(@"ORDER_COMM", nil);
	
	[btnClose setTitle:NSLocalizedString(@"CLOSE_TRADE", nil) forState:UIControlStateNormal];
	[btnClose setTitle:NSLocalizedString(@"CLOSE_TRADE", nil) forState:UIControlStateHighlighted];
	
	[btnUpdate setTitle:NSLocalizedString(@"UPDATE", nil) forState:UIControlStateNormal];
	[btnUpdate setTitle:NSLocalizedString(@"UPDATE", nil) forState:UIControlStateHighlighted];
	
	[btnDelete setTitle:NSLocalizedString(@"DELETE", nil) forState:UIControlStateNormal];
	[btnDelete setTitle:NSLocalizedString(@"DELETE", nil) forState:UIControlStateHighlighted];
	
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
			
	[volPopup setFrame:CGRectMake(volPopup.frame.origin.x, -150, volPopup.frame.size.width, volPopup.frame.size.height)]; 
	
    numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setDecimalSeparator:@"."];
	[numberFormatter setGeneratesDecimalNumbers:TRUE];
	[numberFormatter setMinimumIntegerDigits:1];

    
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
#define kOFFSET_FOR_KEYBOARD 95
- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillHideNotification object:self.view.window]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
	// unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil]; 
}
//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
	
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard 
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
	
    [UIView commitAnimations];
}

UITextField *_textField = nil;
- (void)keyboardWillShow:(NSNotification *)notif
{
    //keyboard will be shown now. depending for which textfield is active, move up or move down the view appropriately
	
    if ([_textField isFirstResponder] && self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (![_textField isFirstResponder] && self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(priceChanged:)
												 name:@"priceChanged" object:nil];	
	[super viewDidLoad];
	
	[self initialize];
}

- (void)priceChanged:(NSNotification *)notification
{
	//TickData *dat = (TickData *)[notification object];
	//if(![dat.Symbol isEqualToString:sym.Symbol])
	//return;
	//Handle
	@try
	{ 
		TickData *dat = [storage.Prices objectForKey:tr.symbol];
		if(dat!=nil && tr.cmd<=1)
		{
			if(tr.close_price!=0)
			{
				lblClosePrice.text = [storage formatPrice:tr.close_price forSymbol:tr.symbol];		
			}
			
			if (storage.openTradesView != OPEN_TRADE_VIEW_POINTS)
			{
				if(tr.profit>0)	
                    lblProfit.textColor = HEXCOLOR(0x00CC00FF);
				else	
					lblProfit.textColor = HEXCOLOR(0xCC0000FF);
			}
			else
			{
				lblProfit.textColor = HEXCOLOR(0x0000CCFF);
			}
			
			lblProfit.text = [storage formatProfit:tr.profit];
		}
		else 
		{
			[self UpdatePrice];
		}
	}
	@catch (...) 
	{
		;//
	}
}
- (IBAction) textFieldDidBeginEditing:(id)sender
{
	UITextField *textField = (UITextField *)sender;	
	_textField = textField;
	textField.textColor = [UIColor blackColor];
	//if ([sender isEqual:edtOpenPrice] )
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (IBAction) textFieldEditingDidEnd:(id)sender   
{
	UITextField *textField = (UITextField *)sender;	
	if([textField.text length]==0)
		textField.text = @"0";
	
	[self setViewMovedUp:NO];
}
-(void)ShowForTrade:(TradeRecord *)_tr AndParams:(ParamsStorage*)p
{	
	self.tr = _tr;
	lblSymbol.text = tr.symbol;
	lblOrderNo.text = [[NSString alloc] initWithFormat:@"%d", tr.order];
	lblOrderType.text = [tr cmd_str];
	
	lblCommission.text = [storage formatProfit:tr.commission];
	
	NSDate *dt_open= tr.open_time;
	//NSDate *dt_close= tr.close_time;
	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
	//[format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // timeZoneWithAbbreviation:@"GMT"]];
	if(dt_open!=nil)
		lblOpenTime.text = [format stringFromDate:dt_open];
	//if(dt_close!=nil)
	lblSwap.text = [storage formatProfit:tr.storage];
	[format autorelease];
	
	lblVolume.text = [storage formatVolume:tr.volume];
	edtVol.text = [storage formatVolume:tr.volume];
	lblVolOriginal.text = [@"/ " stringByAppendingString:[storage formatVolume:tr.volume]];
	
	SymbolInfo *sym = [storage.Symbols objectForKey:tr.symbol];
	//NSLog(@"--%@", sym.Symbol);
	
	self.tr.execCommand = sym.ExecMode;
	if (self.tr.execCommand == 2)
		lblExecution.text = NSLocalizedString(@"BUTTONS_MARKET_EXECUTION", nil);
	else 
		lblExecution.text = NSLocalizedString(@"BUTTONS_INSTANT", nil);
	
	
	[edtOpenPrice setTitle:[storage formatPrice:tr.open_price forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtOpenPrice setTitle:[storage formatPrice:tr.open_price forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	edtOpenPrice.userInteractionEnabled = (tr.cmd>1 && tr.cmd<=5);
	
	if(tr.close_price!=0)
	{
		lblClosePrice.text = [storage formatPrice:tr.close_price forSymbol:tr.symbol];		
	}
	
	else 
		[self UpdatePrice];
	
	if(tr.profit>0)	
		lblProfit.textColor = HEXCOLOR(0x00CC00FF);
	else	
		lblProfit.textColor = HEXCOLOR(0xCC0000FF);
	lblProfit.text = [storage formatProfit:tr.profit];
	
	//edtSL.text = [storage formatPrice:tr.sl forSymbol:tr.symbol];	
	//edtTP.text = [storage formatPrice:tr.tp forSymbol:tr.symbol];
	[edtSL setTitle:[storage formatPrice:tr.sl forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtTP setTitle:[storage formatPrice:tr.tp forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtSL setTitle:[storage formatPrice:tr.sl forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	[edtTP setTitle:[storage formatPrice:tr.tp forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	
	//btnClose.enabled = (tr.cmd<2);
	btnDelete.enabled = (tr.cmd>=2);
	
	edtVolView.hidden = (tr.cmd>=2);
	
	edtVol.enabled = (sym.TradeMode > 0 && tr.cmd<2);
	edtSL.enabled = (sym.TradeMode > 0);
	edtTP.enabled = (sym.TradeMode > 0);

	btnClose.enabled = !tr.isOrder;
	btnUpdate.enabled = (sym.TradeMode > 0);

	NSLog(@"Trade mode: %d", sym.TradeMode);
}

- (void)UpdatePrice
{
	TickData *dat = [[storage Prices] objectForKey:tr.symbol];
	if(dat==nil)
		return;
	
	if (tr.cmd % 2 == 0)
	{
		lblClosePrice.text = dat.Ask; //[storage formatPrice:dat.Ask forSymbol:tr.symbol];
	}
	else 
	{
		lblClosePrice.text = dat.Bid; //[storage formatPrice:dat.Bid forSymbol:tr.symbol];
	}
	
}

- (IBAction) closeClicked:(id)sender
{		
	[self HideSpinner:self];
	
	//double price = [lblClosePrice.text doubleValue];
	//double volume = [edtVol.text doubleValue];
   
   [ [ PFSession sharedSession ] closePositionWithId: tr.positionId amount: [edtVol.text doubleValue] ];
   
	//[storage.trade_progress SendCloseOrder:tr AtPrice:price forVolume:volume];
	[self.navigationController popViewControllerAnimated:NO];
}
- (IBAction) updateClicked:(id)sender
{	 
	[self HideSpinner:self];
	
	//edtVol.text = [storage formatVolume:tr.volume];
	
	//if(![self ValidateTextEdit:edtSL])
	//	return;
	//if(![self ValidateTextEdit:edtTP])
	//	return;
	//if(![self ValidateTextEdit:edtOpenPrice])
	//	return;
	
	/*TradeRecord * tr_copy = [[TradeRecord alloc] init];
	tr_copy.order = tr.order;
	tr_copy.symbol = tr.symbol; //[[NSString alloc] initWithFormat:@"%@", tr.symbol];
	tr_copy.cmd = tr.cmd;
	tr_copy.volume = (int)([lblVolume.text floatValue]*100);
	tr_copy.tp = [edtTP.titleLabel.text floatValue];
	tr_copy.sl = [edtSL.titleLabel.text floatValue];
	tr_copy.open_price = [edtOpenPrice.text floatValue];*/
	
   
   
	/*TradeRecord * tr_copy = [tr copy];
	tr_copy.tp = [edtTP.titleLabel.text floatValue];
	tr_copy.sl = [edtSL.titleLabel.text floatValue];
	tr_copy.open_price = [edtOpenPrice.titleLabel.text floatValue];
	
	[storage.trade_progress SendOrderUpdateRequest:tr_copy];
	//[tr autorelease];
	[tr_copy release];*/

   if ( tr.isOrder )
   {
      [ [ PFSession sharedSession ] updateOrderWithId: tr.order
                                           withAmount: [ edtVol.text doubleValue ]
                                                price: [ edtOpenPrice.titleLabel.text doubleValue ]
                                        stopLossPrice: [ edtSL.titleLabel.text doubleValue ]
                                      takeProfitPrice: [ edtTP.titleLabel.text doubleValue ] ];
   }
   else
   {
      [ [ PFSession sharedSession ] updatePositionWithId: tr.positionId
                                           stopLossPrice: [ edtSL.titleLabel.text doubleValue ]
                                         takeProfitPrice: [ edtTP.titleLabel.text doubleValue ] ];
   }

	[self.navigationController popViewControllerAnimated:NO];
}
- (IBAction) deleteClicked:(id)sender
{	
	[self HideSpinner:self];
	
	/*TradeRecord * tr_copy = [[TradeRecord alloc] init];
	tr_copy.order = tr.order;
	tr_copy.symbol = [NSString stringWithFormat:@"%@", tr.symbol];
	tr_copy.cmd = tr.cmd;
	tr_copy.volume = (int)([lblVolume.text floatValue]*100);
	tr_copy.tp = [edtTP.titleLabel.text floatValue];
	tr_copy.sl = [edtSL.titleLabel.text floatValue];
	tr_copy.open_price = [edtOpenPrice.titleLabel.text floatValue];
	
	[storage.trade_progress SendOrderDeleteRequest:tr_copy];
	[tr autorelease];*/

   [ [ PFSession sharedSession ] cancelOrderWithId: tr.order ];

	[self.navigationController popViewControllerAnimated:NO];
}

- (void)goBack
{

}

//////////////////////////////////////////////////////////////////
// TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextBox
{
	[aTextBox resignFirstResponder];
	return YES;
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
	return YES;
}

- (IBAction) ValidateVolume:(id)sender
{
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	    
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
	if (vol > tr.volume)
		vol = tr.volume; 
	
	edtVol.text = [storage formatVolume:vol];
	//tr.volume = vol;
}


//////////////////////////////////////////////////////////////////
// Volume Picker Methods

- (IBAction) volumeChanged:(id)sender
{
   BOOL volume_changed_ = [edtVol.text doubleValue] != tr.volume;

   lblVolOriginal.hidden = !volume_changed_;
   btnUpdate.enabled = tr.isOrder || !volume_changed_;
}

- (IBAction) volumeClicked:(id)sender
{
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	[volPopup setFrame:CGRectMake(volPopup.frame.origin.x, 107, volPopup.frame.size.width, volPopup.frame.size.height)]; 
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
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
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
	if (vol > tr.volume)
    {
		vol = tr.volume;
	}
	edtVol.text = [storage formatVolume:vol];
	
	[self volumeChanged:self];
}

- (IBAction) volumeDownClicked:(id)sender
{	
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? sym.Lot_Min * 100 : round([edtVol.text doubleValue] * 100);
	unsigned long step = round(sym.Lot_Step * 100);	
	unsigned long mod = vol1 % step;
	
	double vol = (vol1 - step - mod) / 100.0 ;
	
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
	if (vol > tr.volume)
    {
		vol = tr.volume; 
	}
	edtVol.text = [storage formatVolume:vol];
	
	[self volumeChanged:self];
}

- (IBAction) volumeUp10Clicked:(id)sender
{	
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
	unsigned long vol1 = ([edtVol.text doubleValue] <= 0) ? sym.Lot_Min * 100 : round([edtVol.text doubleValue] * 100);
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
	if (vol > tr.volume)
    {
		vol = tr.volume; 
	}
	edtVol.text = [storage formatVolume:vol];
	
	[self volumeChanged:self];
}

- (IBAction) volumeDown10Clicked:(id)sender
{
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
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
	if (vol > tr.volume)
    {
		vol = tr.volume; 
	}
	edtVol.text = [storage formatVolume:vol];
	
	[self volumeChanged:self];
}

//////////////////////////////////////////////////////////////////
// Number Picker Methods

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView*)picker {
	// Number of columns you want (1 column is like in when clicking an <select /> in Safari, multi columns like a date selector)
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
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


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {  
	
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
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
	return title;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	[self getSpinnerValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
	if (component == pickerComponentsCount-1 && (sym.Digits == 3 || sym.Digits == 5))
		return 50;
	else if (component == 0)
		return 80;
	else 
		return 60;
}

-(void) showSpinner: (BOOL)isSL IsPending: (BOOL)isPendingOrder
{
	//if (pricePicker != nil)
	//	return;
	
	_isSL = isSL;
	isPending = isPendingOrder;
	
	SymbolInfo *sym = [[storage Symbols] objectForKey:tr.symbol];
	
	NSString *p1, *p2, *p3;
	
	[self HideSpinner:self];
	
	[self ValidateTextEdit:edtVol];
	
	NSString *price1;
	NSString *price2;
	NSString *price3;
	if (isSL)         // if is SL
	{
		if ([edtSL.titleLabel.text floatValue] == 0)
		{
			NSString* price;
			SymbolInfo *sym = [[storage Symbols] objectForKey:tr.symbol];
			
			if (tr.cmd == 0) // buy
			{
				float fprice = [lblClosePrice.text floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
				price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				NSLog(@"%f stops:%f\nprice:%@", [lblClosePrice.text floatValue], (float)([sym StopsLevel]/pow(10, sym.Digits)), price);
			}
			else if (tr.cmd == 1) // sell
			{
				float fprice = [lblClosePrice.text floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
				price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				
			}
			else if (tr.cmd == 2) // buy limit
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else
				{
					float fprice = [dat.Ask floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 3) // sell limit
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else 
				{
					float fprice = [dat.Bid floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 4) // buy stop
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else
				{
					float fprice = [dat.Ask floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 5) // sell stop
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else 
				{
					float fprice = [dat.Bid floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			
			
			[storage SplitPrice:price P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			 price1 = p1;
			 price2 = p2;
			 price3 = p3;
			
			NSLog(@"price1, price2, price3: %@ %@ %@", p1, p2, p3);
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
		if ([edtOpenPrice.titleLabel.text floatValue] == 0)
		{
			[storage SplitPrice:[storage formatPrice:tr.open_price forSymbol:tr.symbol] P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			price1 = p1;
			price2 = p2;
			price3 = p3;
		}
		else 
		{
			[storage SplitPrice:edtOpenPrice.titleLabel.text P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			price1 = p1;
			price2 = p2;
			price3 = p3;
		}
	}
	else //if (!isSL)    // else if is TP
	{
		if ([edtTP.titleLabel.text floatValue] == 0)
		{
			NSString* price;
			SymbolInfo *sym = [[storage Symbols] objectForKey:tr.symbol];
			
			if (tr.cmd == 0) // buy
			{
				float fprice = [lblClosePrice.text floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
				price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				NSLog(@"%f stops:%f\nprice:%@", [lblClosePrice.text floatValue], (float)([sym StopsLevel]/pow(10, sym.Digits)), price);
			}
			else if (tr.cmd == 1) // sell
			{
				float fprice = [lblClosePrice.text floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
				price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				
			}
			else if (tr.cmd == 2) // buy limit
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else 
				{
					float fprice = [dat.Ask floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 3) // sell limit
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else
				{
					float fprice = [dat.Bid floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 4) // buy stop
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else
				{
					float fprice = [dat.Ask floatValue] + (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			else if (tr.cmd == 5) // sell stop
			{
				TickData *dat = [[storage Prices] objectForKey:tr.symbol];
				if(dat==nil)
				{
					price = [storage formatPrice:[dat.Ask doubleValue] forSymbol:sym.Symbol];
				}			 
				else
				{
					float fprice = [dat.Bid floatValue] - (float)([sym StopsLevel]/pow(10, sym.Digits));
					price = [storage formatPrice:fprice forSymbol:sym.Symbol];
				}
			}
			
			[storage SplitPrice:price P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			 price1 = p1;
			 price2 = p2;
			 price3 = p3;
		}
		else
		{
			[storage SplitPrice:edtTP.titleLabel.text P1:&p1 P2:&p2 P3:&p3 forSymbol:sym.Symbol];
			price1 = p1;
			price2 = p2;
			price3 = p3;
		}
	}
	
	
	pricePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -300, 320, 300)]; //y=152 heigh=300
	pricePicker.showsSelectionIndicator = YES;
	
	
	//[newView setFrame:CGRectMake( 0.0f, 480.0f, 320.0f, 480.0f)]; //notice this is OFF screen!
	//[pricePicker setFrame:CGRectMake(0, 480, 320, 300)];
	[UIView beginAnimations:@"animateTableView" context:nil];
	[UIView setAnimationDuration:0.4];
	[pricePicker setFrame:CGRectMake(0, 0, 320, 300)]; //notice this is ON screen! y=152
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
		[pricePicker selectRow:([price3 intValue]+5000) inComponent:(pickerComponentsCount-1) animated:NO]; // last component
		[pricePicker selectRow:([price2 intValue]+5000) inComponent:(pickerComponentsCount-2) animated:NO];
		if (sym.Digits == 5)
		{
			int tmpPrice = round( ([price1 doubleValue] - [price1 intValue]) * 100 );
			[pricePicker selectRow:tmpPrice+5000 inComponent:1 animated:NO];
			
		}
	}
	else 
	{
		[pricePicker selectRow:([price2 intValue]+5000) inComponent:(pickerComponentsCount-1) animated:NO]; // last component
		if (sym.Digits == 4)
		{
			int tmpPrice = round( ([price1 doubleValue] - [price1 intValue]) * 100 );
			[pricePicker selectRow:tmpPrice+5000 inComponent:1 animated:NO];
		}
	}
	
}

- (IBAction) SLClicked:(id)sender
{
	if (pricePicker != nil && _isSL==YES && isPending==NO)
		return;
	[self showSpinner:YES IsPending:NO];

	btnClearSL.hidden = NO;
	
}

- (IBAction) TPClicked:(id)sender
{
	if (pricePicker != nil && _isSL==NO && isPending==NO)
		return;
	[self showSpinner:NO IsPending:NO];
	
	btnClearTP.hidden = NO;
}

- (IBAction) PriceClicked:(id)sender
{
	if (pricePicker != nil && isPending == YES)
		return;
	[self showSpinner:NO IsPending:YES];
	
	btnClearPrice.hidden = NO;
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
	
	btnClearSL.hidden = YES;
	btnClearTP.hidden = YES;
	btnClearPrice.hidden = YES;
	
	if (pricePicker == nil)
		return;
	
	self.navigationItem.leftBarButtonItem = nil;
	[pricePicker removeFromSuperview];
	[pricePicker release];
	pricePicker = nil;
	
}

-(NSString*) getSpinnerValue
{
	NSString *price;
	SymbolInfo* sym = [[storage Symbols] objectForKey:tr.symbol];
	
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
	
	if (_isSL)
	{
		[edtSL setTitle:price forState:UIControlStateNormal];
		[edtSL setTitle:price forState:UIControlStateHighlighted];
	}
	else if (isPending)
	{
		[edtOpenPrice setTitle:price forState:UIControlStateNormal];
		[edtOpenPrice setTitle:price forState:UIControlStateHighlighted];
	}
	else
	{
		[edtTP setTitle:price forState:UIControlStateNormal];
		[edtTP setTitle:price forState:UIControlStateHighlighted];
	}
	return price;
}

//////////////////////////////////////////////////////////////////

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction) clearSL:(id)sender
{
	[edtSL setTitle:[storage formatPrice:0.0 forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtSL setTitle:[storage formatPrice:0.0 forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
}
- (IBAction) clearTP:(id)sender
{
	[edtTP setTitle:[storage formatPrice:0.0 forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtTP setTitle:[storage formatPrice:0.0 forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
}

- (IBAction) clearPrice:(id)sender
{
	[edtOpenPrice setTitle:[storage formatPrice:tr.open_price forSymbol:tr.symbol] forState:UIControlStateNormal];
	[edtOpenPrice setTitle:[storage formatPrice:tr.open_price forSymbol:tr.symbol] forState:UIControlStateHighlighted];
	
	[self HideSpinner:self];
	
}

@end
