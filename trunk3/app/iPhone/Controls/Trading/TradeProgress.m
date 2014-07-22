
#import "TradeProgress.h"
#import "../../Code/ServerConnection.h"
#import "../../Classes/iTraderAppDelegate.h"
#import "CustomAlert.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation TradeProgress
@synthesize serverConn, tradeConn, trade, storage, mainwnd;


- (void)dealloc {
    [_promptView release];
   [ trade release ];
    [super dealloc];
}

#pragma mark PromptView

- (void)createStatusView{    
    CGRect frame = CGRectMake(20, 6, 32, 32);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	
	
    _promptView = [[UIActionSheet alloc] initWithTitle:@"Connecting..." 
												delegate:self 
												cancelButtonTitle:NSLocalizedString(@"BACK", nil)
												destructiveButtonTitle:isCanceling?nil:NSLocalizedString(@"CANCEL_ORDER", nil) 
												otherButtonTitles: nil];
    _promptView.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [_promptView addSubview:progressInd];
	
    [progressInd release];
}

- (void)showPromptView:(NSString *)statusText
{
    if(!_promptView)
    {
        [self createStatusView];
    }
	
    if(![_promptView superview])
        [_promptView showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]];
	
    [_promptView setTitle:statusText];
}

- (void)dismissPromptView{
	isCanceling = NO;
    if([_promptView superview])
        [_promptView dismissWithClickedButtonIndex:0 animated:YES];
    if(_promptView)
    {
        [_promptView release];
        _promptView = nil;
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if ( buttonIndex == actionSheet.cancelButtonIndex )
      return;
   
	if(buttonIndex == 0 )//cancel
	{
		[ [ PFSession sharedSession ] cancelOrderWithId: trade.order ];

		[self dismissPromptView];
	}
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	[_promptView dismissWithClickedButtonIndex:0 animated:YES];
	
}
-(NSString*)GetDesc:(int)iRes
{
	switch(iRes) 
	{
		case -1:
			return @"Trading is currently unavailable in your region through this Application.";
			//"server technical problem";
		case RET_OLD_VERSION:
			return @"Old client terminal";
		case RET_NO_CONNECT:
			return @"No connection";
		case RET_NOT_ENOUGH_RIGHTS:
			return @"Not enough rights";
		case RET_TOO_FREQUENT:
			return @"Too frequently access to server";
		case RET_MALFUNCTION:
			return @"Mulfunctional operation";
		case RET_GENERATE_KEY:
			return @"Need to send public key";
		case RET_SECURITY_SESSION:
			return @"Security session start";
			//---- account status";
		case RET_ACCOUNT_DISABLED:
			return @"Account blocked";
		case RET_BAD_ACCOUNT_INFO:
			return @"Bad account info";
		case RET_PUBLIC_KEY_MISSING:
			return @"Key missing";
			//---- trade";
		case RET_TRADE_TIMEOUT:
			return @"Trade transatcion timeout expired";
		case RET_TRADE_BAD_PRICES:
			return NSLocalizedString(@"RET_TRADE_BAD_PRICES", nil);
		case RET_TRADE_BAD_STOPS:
			return NSLocalizedString(@"RET_TRADE_BAD_STOPS", nil);
		case RET_TRADE_BAD_VOLUME:
			return NSLocalizedString(@"RET_TRADE_BAD_VOLUME", nil);
		case RET_TRADE_MARKET_CLOSED:
			return NSLocalizedString(@"RET_TRADE_MARKET_CLOSED", nil);
		case RET_TRADE_DISABLE:
			return NSLocalizedString(@"RET_TRADE_DISABLE", nil);
		case RET_TRADE_NO_MONEY:
			return NSLocalizedString(@"RET_TRADE_NO_MONEY", nil);
		case RET_TRADE_PRICE_CHANGED:
			return NSLocalizedString(@"RET_TRADE_PRICE_CHANGED", nil);
		case RET_TRADE_OFFQUOTES:
			return NSLocalizedString(@"RET_TRADE_OFFQUOTES", nil);
		case RET_TRADE_BROKER_BUSY:
			return @"Broker is busy";
		case RET_TRADE_REQUOTE:
			return NSLocalizedString(@"TRADE_REQUOTE", nil);
		case RET_TRADE_ORDER_LOCKED:
			return @"Order is proceed by dealer and cannot be changed";
		case RET_TRADE_LONG_ONLY:
			return @"Allowed only BUY orders";
		case RET_TRADE_TOO_MANY_REQ:
			return @"Too many requests from one client";
			//---- order status notification";
		case RET_TRADE_ACCEPTED:
			return NSLocalizedString(@"TRADE_REQUEST_SENT", nil); //@"Trade request accepted";// by server and placed in request queue";
		case RET_TRADE_PROCESS:
			return NSLocalizedString(@"RET_TRADE_PROCESS", nil);// is being reviewed by dealer";
		case RET_TRADE_USER_CANCEL:
			return @"Trade request canceled";// by client";
			//---- additional return codes";
		case RET_TRADE_MODIFY_DENIED:
			return @"Trade modification denied";
		case RET_TRADE_EXPIRATION_DENIED:
			return @"ERROR_EXPIRATION_DENIED"; 
		case RET_TRADE_TOO_MANY_ORDERS:
			return @"Too many orders";
	}
	return @"";
}

-(void)SetNotification:(NSArray*)args
{ 
    //TODO: changeMe should be changed with args, changeME is not the same everywhere in the code
    int changeMe = 0;
    //TODO: change do_trade, trade_step, trade_done, busy etc to match your protocol
	BOOL isSuccess = YES;
	BOOL isFinished = NO;
	BOOL isReprice = NO;
	NSString *Title = nil;
	NSString *Message = nil;
	NSString *cmd = [args objectAtIndex:changeMe]; 
	if([cmd compare:@"do_trade"]==0)
	{
		NSString *subtype = [args objectAtIndex:changeMe];
		if([subtype compare:@"trade_step"]==0)
		{
			int step = [[args objectAtIndex:changeMe] intValue];
			int res = [[args objectAtIndex:changeMe] intValue];

			if(res==RET_TRADE_REQUOTE)
			{
				isFinished  = true;
				isSuccess = false;
				Title  = [NSString stringWithFormat:@"%@: 5", NSLocalizedString(@"TRADE_REQUOTE", nil)];
				if([args count]==7)
				{
					isReprice = YES;
					if(lastRequestSent==0)
						trade.open_price = (trade.cmd == 0)?[[args objectAtIndex:changeMe] doubleValue]:[[args objectAtIndex:changeMe] doubleValue];
					else
						lostClosePrice = (trade.cmd == 0)?[[args objectAtIndex:changeMe] doubleValue]:[[args objectAtIndex:changeMe] doubleValue];
					
                    NSString *str1 = [storage formatPrice:[[args objectAtIndex:changeMe] doubleValue] forSymbol:trade.symbol];
					NSString *str2 = [storage formatPrice:[[args objectAtIndex:changeMe] doubleValue] forSymbol:trade.symbol];
				
					Message  = [[NSString alloc] initWithFormat:[[/*@"%@. "*/@"" stringByAppendingString:NSLocalizedString(@"TRADE_NEW_PRICE", nil)] stringByAppendingString:@" \r\n%@/%@"], str1, str2];
					
					NSLog(@"%@", Message);
							
				}
				else
				{					
					Message  = [[NSString alloc] initWithFormat:@"%@.",
								[self GetDesc:res]
								];
					NSLog(@"%@", Message);
				}
				
			}
			if(res!=RET_TRADE_USER_CANCEL && res!=0)
			{
				NSString *stepStr = NSLocalizedString(@"TRADE_STEP", nil);
				NSString *msgStep1;
                msgStep1 = [self GetDesc:res];
				
				if (res!=RET_TRADE_REQUOTE || step!=2)
				{
					Title  = [[NSString alloc] initWithFormat:@"%@ %d. %@", stepStr, step+1, [self GetDesc:res]];
					NSLog(@"%@", Title);
					if((res!=RET_TRADE_ACCEPTED && step==0) ||
						(res!=RET_TRADE_PROCESS && step==1) ||
						res==RET_TRADE_OFFQUOTES)
					{
						isFinished  = true;
						isSuccess = false;
						Title  = NSLocalizedString(@"RET_TRADE_OFFQUOTES", nil);
						Message  = [self GetDesc:res];
					
					} 
				}
				else 
				{ 
				}
			}
			else
			if(res!=0)
			{
				isFinished  = true;
				isSuccess = true;
				Title  = NSLocalizedString(@"TRADE_CANCEL_REQUEST", nil);
				Message  =[self GetDesc:res];
			}
		}
		else
		if([subtype compare:@"trade_done"]==0)
		{
			isFinished  = true;
			isSuccess = true;
				
			//var dtDate:Date = new Date();
			//dtDate.setTime(params[7]*1000 + dtDate.timezoneOffset*60*1000);
			Title  = NSLocalizedString(@"TRADE_ORDER_PROCESSED", nil);
			
			//NSString* price =[args objectAtIndex:5];
			NSString *price = [storage formatPrice:[[args objectAtIndex:changeMe] doubleValue] forSymbol:trade.symbol];
			// [storage formatPrice:[[args objectAtIndex:2] doubleValue] 
										
			int time_temp = [[args objectAtIndex:changeMe] integerValue];
			int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
			
			NSDate *dt= [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"dd.MM.yyyy HH:mm"];	
			
			Message = [[NSString alloc] initWithFormat:@"#%@ %@ %.02f %@ %@ %@",
					   [args objectAtIndex:changeMe],
					   [trade cmd_str],
   					   [[args objectAtIndex:changeMe] doubleValue]/100,
					   trade.symbol,
					   NSLocalizedString(@"TRADE_AT_PRICE", nil),
						price];
			
			if ([[args objectAtIndex:changeMe] doubleValue] != 0) 
			{
				NSString *sl = [storage formatPrice:[[args objectAtIndex:changeMe] doubleValue] forSymbol:trade.symbol];
				Message = [[NSString alloc] initWithFormat:@"%@ S/L: %@", Message, sl];
			}
			if ([[args objectAtIndex:changeMe] doubleValue] != 0) 
			{
				NSString *tp = [storage formatPrice:[[args objectAtIndex:changeMe] doubleValue] forSymbol:trade.symbol];
				Message = [[NSString alloc] initWithFormat:@"%@ T/P: %@", Message, tp];
			}
			Message = [[NSString alloc] initWithFormat:@"%@ %@ %@", Message, NSLocalizedString(@"TRADE_APPROVED_ON", nil), [format stringFromDate:dt]];
			
			
			[format autorelease];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"order_proccessed" object:nil];
		}
		else
		if([subtype compare:@"error"]==0)
		{
			isFinished  = true;
			isSuccess = false;
			Title  = NSLocalizedString(@"ERROR", nil);
			if([args count]>2 && [[args objectAtIndex:changeMe] isEqualToString:@"send_login"])
			{
				Message  = [[NSString alloc] initWithString:NSLocalizedString(@"TRADE_ERROR_INVESTOR", nil)];	
			}
			else 
			{
				Message  = [[NSString alloc] initWithFormat:[NSLocalizedString(@"TRADE_ERROR_PROCCESSING", nil) stringByAppendingString:@" (%@)"], [args objectAtIndex:changeMe]];	
			}
			
		}
		else
		if([subtype compare:@"busy"]==0)
		{
			isFinished  = true;
			isSuccess = false;
			Title  = NSLocalizedString(@"ERROR", nil);
			Message  = [[NSString alloc] initWithString:NSLocalizedString(@"TRADE_CONTEXT_BUSY", nil)];
		}
	} 
	else
	if([cmd compare:@"cancel_trade"]==0)
	{
		NSString *subtype = [args objectAtIndex:changeMe];
		if([subtype compare:@"0"]==0)
		{      
			isFinished  = true;
			isSuccess = true;
			Title  = NSLocalizedString(@"TRADE_CANCEL_REQUEST", nil);
			Message  = NSLocalizedString(@"TRADE_REQUEST_CANCELED", nil); // @"Request was successfully cancelled";
		}
		else
		{
			isFinished  = false;
			isSuccess = false;
			//Title  = "Trade canceled";
			int res = [subtype intValue];
			Message  = [self GetDesc:res];
		}
	}
	else
	if([cmd compare:@"close_trade"]==0)
	{
		NSString *subtype = [args objectAtIndex:changeMe];
		if([subtype compare:@"trade_done"]==0)
		{
			isFinished  = true;
			isSuccess = true;
			
			//var dtDate:Date = new Date();
			//dtDate.setTime(params[7]*1000 + dtDate.timezoneOffset*60*1000);
			Title  = NSLocalizedString(@"TRADE_ORDER_PROCESSED", nil);
			NSString* price =[args objectAtIndex:changeMe];
			// [storage formatPrice:[[args objectAtIndex:2] doubleValue] 
			
			int time_temp = [[args objectAtIndex:changeMe] integerValue];
			int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
			
			NSDate *dt= [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];
			NSDateFormatter *format = [[NSDateFormatter alloc] init];
			[format setDateFormat:@"dd.MM.yyyy HH:mm"];	
			
			// forSymbol:trade.symbol];
			
			Message = [[NSString alloc] initWithFormat:[[[[@"#%@ %@ %.02f %@ " stringByAppendingString:NSLocalizedString(@"TRADE_CLOSED_AT", nil)] stringByAppendingString:@" %@ "] stringByAppendingString:NSLocalizedString(@"TRADE_APPROVED_ON", nil)] stringByAppendingString:@" %@"],
					   [args objectAtIndex:changeMe],
					   [trade cmd_str],
					   [[args objectAtIndex:changeMe] doubleValue]/100,
					   trade.symbol,
					   price,
					   [format stringFromDate:dt]];
			[format autorelease];
			//[dt autorelease];
			
			trade.volume -= [[args objectAtIndex:changeMe] doubleValue]/100;
			
			NSLog(@"%@", Message);
		}
		
	}
	else
	if([cmd compare:@"delete_trade"]==0)
	{
		NSString *subtype = [args objectAtIndex:changeMe];
		if([subtype compare:@"trade_done"]==0)
		{
			isFinished  = true;
			isSuccess = true;
			
			Title  = NSLocalizedString(@"TRADE_ORDER_PROCESSED", nil);
			
			NSString *msg = [NSLocalizedString(@"TRADE_THE_ORDER", nil) stringByAppendingString:@"#%d "];
			msg = [msg stringByAppendingString:NSLocalizedString(@"TRADE_DELETED", nil)];
			//Message = [[NSString alloc] initWithFormat:(@"Order #%d " stringByAppendingString:NSLocalizedString(@"TRADE_DELETED", nil)),// was successfuly deleted",
			//		   trade.order];
			Message = [[NSString alloc] initWithFormat:msg, trade.order];
			
		}
		
	}
	if(isFinished)
	{
		alert = [[CustomAlert alloc] initWithTitle:Title
														message:Message  
														delegate:self 
														cancelButtonTitle:@"OK"
														otherButtonTitles: nil];
		if(isReprice)
		{
			alert = [[CustomAlert alloc] initWithTitle:Title
											   message:Message  
												delegate:self 
												cancelButtonTitle:nil
												otherButtonTitles: NSLocalizedString(@"QUESTION_YES", nil), NSLocalizedString(@"QUESTION_NO", nil), nil];
			reprice_countdown_i = 0;
			timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownReprice) userInfo:nil repeats:YES];
		}
		else
		{
			alert = [[CustomAlert alloc] initWithTitle:Title
											   message:Message  
											  delegate:self 
									 cancelButtonTitle:@"OK"
									 otherButtonTitles: nil];
		}
		
		[alert show];
		[self dismissPromptView];
		[Message autorelease];
		if(tradeConn!=nil)
		{
			ServerConnection *sc = (ServerConnection*)tradeConn;
			[sc Disconnect];
			[tradeConn release];
			tradeConn = nil;
		}
	}
	else
	if(Title!=nil)
	{
		[_promptView setTitle:Title];
		[Title autorelease];
	}
	
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex 
{
	if(timer==nil)
		return;
	
	[alert dismissWithClickedButtonIndex:0 animated:TRUE];	
	
	[timer invalidate];
	timer = nil;
	[alert release];
	
	if (buttonIndex == 0)//yes
	{
		[self performSelector:@selector(tradeAgain:) withObject:nil afterDelay:0.3];
	}
}
-(void) tradeAgain: (id) sender
{	
	if(lastRequestSent==0)
	{
		TradeRecord *tr = [trade retain];
		[self SendOrder:tr];
		[tr release];
	}
	else
	if(lastRequestSent==1)
	{
		TradeRecord *tr = [trade retain];
		[self SendCloseOrder:tr AtPrice:lostClosePrice forVolume:close_volume];
		[tr release];
	}
	else
	if(lastRequestSent==2)
	{
		TradeRecord *tr = [trade retain];
		[self SendOrderUpdateRequest:tr];
		[tr release];
	}
		
}

- (void)countdownReprice
{
	reprice_countdown_i++;
	if(reprice_countdown_i>=5)
	{
		[alert dismissWithClickedButtonIndex:0 animated:TRUE];
		[timer invalidate];
		timer = nil;
		[alert release];
	}
	else
	{
		NSString *Title  = [[NSString alloc] initWithFormat:[NSLocalizedString(@"TRADE_REQUOTE", nil) stringByAppendingString:@" %d"], (5 - reprice_countdown_i)];
		[alert setTitle:Title];
		[Title release];
	}
}
- (void)SendOrder:(TradeRecord*)_trade
{
	lastRequestSent = 0;
	if(tradeConn!=nil)
	{
		ServerConnection *sc = (ServerConnection*)tradeConn;
		[sc Disconnect];
		[tradeConn release];
		tradeConn = nil;
	}
	tradeConn = [[ServerConnection alloc] init];

	ParamsStorage *ps = (ParamsStorage*)storage;
	ServerConnection *sc = (ServerConnection*)tradeConn;
	sc.sendConnected = NO;
	sc.sendErrors = NO;
	[sc.codec initWith:[ps.serverConn.codec getKey]];
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)mainwnd;
	sc.delegate = wnd;
	
	
	[sc ConnectHost:wnd.serverHost AndPort:wnd.serverPort];
	
	if(trade!=nil)
	{
		[trade autorelease];
		trade = nil;
	}
	trade =_trade;
	[trade retain];
	[self showPromptView:NSLocalizedString(@"TRADE_SENDING_ORDER", nil)];	
	//ServerConnection * s = (ServerConnection *)serverConn;
	[sc SendCred:ps.login AndPAss:ps.password];
	[sc SendTradeRequest:trade];
}
- (void)SendCloseOrder:(TradeRecord*)_trade AtPrice:(double)price forVolume:(double)vol
{
	lostClosePrice = price;
	close_volume = vol;
	lastRequestSent = 1;
	if(tradeConn!=nil)
	{
		ServerConnection *sc = (ServerConnection*)tradeConn;
		[sc Disconnect];
		[tradeConn release];
		tradeConn = nil;
	}
	tradeConn = [[ServerConnection alloc] init];
	
	ParamsStorage *ps = (ParamsStorage*)storage;
	ServerConnection *sc = (ServerConnection*)tradeConn;
	sc.sendConnected = NO;
	sc.sendErrors = NO;
	[sc.codec initWith:[ps.serverConn.codec getKey]];
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)mainwnd;
	sc.delegate = wnd;
	
	
	[sc ConnectHost:wnd.serverHost AndPort:wnd.serverPort];
	
	if(trade!=nil)
	{
		[trade autorelease];
		trade = nil;
	}
	trade =_trade;
	[trade retain];
	[self showPromptView:NSLocalizedString(@"TRADE_SENDING_ORDER", nil)];	
	//ServerConnection * s = (ServerConnection *)serverConn;
	[sc SendCred:ps.login AndPAss:ps.password];
	[sc SendTradeCloseRequest:trade AtPrice:price forVolume:vol];
}

- (void)SendOrderUpdateRequest:(TradeRecord*)_trade
{
	lastRequestSent = 2;
	if(tradeConn!=nil)
	{
		ServerConnection *sc = (ServerConnection*)tradeConn;
		[sc Disconnect];
		[tradeConn release];
		tradeConn = nil;
	}
	tradeConn = [[ServerConnection alloc] init];
	
	ParamsStorage *ps = (ParamsStorage*)storage;
	ServerConnection *sc = (ServerConnection*)tradeConn;
	sc.sendConnected = NO;
	sc.sendErrors = NO;
	[sc.codec initWith:[ps.serverConn.codec getKey]];
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)mainwnd;
	sc.delegate = wnd;
	
	
	[sc ConnectHost:wnd.serverHost AndPort:wnd.serverPort];
	
	if(trade!=nil)
	{
		[trade autorelease];
		trade = nil;
	}
	trade =_trade;
	[trade retain];
	[self showPromptView:NSLocalizedString(@"TRADE_SENDING_ORDER", nil)];	
	//ServerConnection * s = (ServerConnection *)serverConn;
	[sc SendCred:ps.login AndPAss:ps.password];
	[sc SendTradeUpdateRequest:trade];
}
- (void)SendOrderDeleteRequest:(TradeRecord*)_trade
{
   self.trade = _trade;

	[self showPromptView:NSLocalizedString(@"TRADE_SENDING_ORDER", nil)];
}
@end














