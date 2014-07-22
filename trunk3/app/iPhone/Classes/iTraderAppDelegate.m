#import "iTraderAppDelegate.h"
#import "MarketWatch.h"
#import "FavoritesCtl.h"
#import "LoginViewController.h"
#import "LoginProgressController.h"

#import "PFTabBarControllerManager.h"

#import "../Code/ServerConnection.h"
#import "GetServer.h"
#import "GetSettings.h"
#import "OpenPosWatch.h"
#import "HistoryViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "CustomAlert.h"
#import <XiPFramework/XSoundPlayer.h>

#import <ProFinanceApi/ProFinanceApi.h>

@interface iTraderAppDelegate ()< PFSessionDelegate >

@property ( nonatomic, strong ) PFSession* session;

@property ( nonatomic, strong ) ServerConnection* serverConnection;
@property ( nonatomic, strong ) PFTabBarControllerManager* tabBarManager;
//@property ( nonatomic, strong ) ServerConnection* tradeConnection;

@end

@implementation iTraderAppDelegate

@synthesize window;
@synthesize loginView, loginProgress, mailList, logoutView;
@synthesize serverHost, serverPort, storage, isOnBackupServer, chartInterval, chartScale, notificationsRegistered;

@synthesize tabBarManager = _tabBarManager;
@synthesize session = _session;

@synthesize serverConnection = _serverConnection;
//@synthesize tradeConnection = _tradeConnection;

-(void)dealloc
{	
	[serverHost release];
	[loginView release];
	[loginProgress release];
	[storage release];
   
   [ _tabBarManager release ];
   [ _serverConnection release ];
   [ _session release ];

	[super dealloc];
}

-(ServerConnection*)serverConnection
{
   if ( !_serverConnection )
   {
      _serverConnection = [ ServerConnection new ];
      _serverConnection.delegate = self;
   }
   return _serverConnection;
}

-(PFSession*)session
{
   if ( !_session )
   {
      _session = [ PFSession new ];
      [ _session addDelegate: self ];
   }
   return _session;
}

-(void)RegisterNotifications
{
	notificationsRegistered = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(LoginCanceled:)
												 name:@"LoginCanceled" object:nil];	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverResolved:)
												 name:@"serverResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverDidntResolve:)
												 name:@"serverDidntResolve" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tokenResolved:)
												 name:@"tokenResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tokenDidntResolve:)
												 name:@"tokenDidntResolve" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsResolved:)
												 name:@"settingsResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsDidntResolve:)
												 name:@"settingsDidntResolve" object:nil];	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverConnected:)
												 name:@"serverConnected" object:nil];		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverDisconnected:)
												 name:@"DisconnectWithError" object:nil];		
	/*[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(dataReceived:)
												 name:@"dataReceived" object:nil];	*/
	
}

-(void) UnRegisterNotification
{
	notificationsRegistered = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:@"LoginCanceled" object:nil];	
	
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"serverResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"serverDidntResolve" object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"tokenResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"tokenDidntResolve" object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"settingsResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"settingsDidntResolve" object:nil];	
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"serverConnected" object:nil];		
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"DisconnectWithError" object:nil];	
}

- (void)applicationWillTerminate:(UIApplication *)application 
{	
}
- (void)applicationDidEnterBackground:(UIApplication *)application 
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[loginView shakeButton];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
//	timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(priceUpdate) userInfo:nil repeats:YES];
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (kAudioSessionProperty_AudioCategory,sizeof (sessionCategory),&sessionCategory); 
    
    // Override point for customization after app launch    
    [XSoundPlayer Init];
	//[self RegisterNotifications];
	notificationsRegistered = NO;
	storage = [[ParamsStorage alloc] init];

	//serverConn = [[ServerConnection alloc] init];
	//serverConn.delegate = self;
	serverHost = nil;
	gsServer = nil;
	gsToken = nil;
	gsSettings = nil;
	userDisconnect = FALSE;
	wasConnected = FALSE;

	storage.trade_progress.mainwnd = self;

	//globalChartInterval = @"1";
	[[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"chartInterval"];
	
	//[window addSubview:[self.loginProgress view]];
   loginProgress.stepsCount = 7;
	loginView.storage = storage;
	[loginView initialize];

	window.rootViewController = self.loginView;

	//[window addSubview:[self.mainView view]];

	
	//loginProgress.view.hidden = YES;
	//mainView.view.hidden = YES;
	
	chartInterval = @"1";
	chartScale = 0.05;
	
    [window makeKeyAndVisible];
}

-(BOOL)shouldStopConnecting
{
	return loginProgress.isCanceled;
}

-(void) any2login: (id) sender
{
   self.tabBarManager = nil;

	loginView.storage = storage;
	[loginView initialize];

	window.rootViewController = self.loginView;

	loginProgress.isCanceled = NO;	

   [ _session disconnect ];
   self.session = nil;

   [ PFSession setSharedSession: nil ];

	wasConnected = NO;
}

- (void) any2progress: (id) sender
{
	if([self shouldStopConnecting])
	{
		[self any2login:self];	
		return;
	}

	[loginProgress stepCompletedWithDescription:NSLocalizedString(@"PROGRESS_SEARCH_SERVER", nil)];

	[ self.loginProgress reset ];

	window.rootViewController = self.loginProgress;
   
	[[NSNotificationCenter defaultCenter] postNotificationName:@"hideChart" object:nil];
	
	[self StartConnection];
}


-(void) progress2done: (id) sender
{
	loginProgress.isCanceled = NO;

   self.tabBarManager = [ PFTabBarControllerManager manager ];

   self.tabBarManager.ratesController.storage = self.storage;
   [ self.tabBarManager.ratesController rebind ];

   self.tabBarManager.tradesController.storage = self.storage;
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];

   self.tabBarManager.favoritesController.storage = self.storage;
   [ self.tabBarManager.favoritesController rebind ];

   self.tabBarManager.historyController.storage = self.storage;

	window.rootViewController = self.tabBarManager.tabBarController;
}

- (void)StartConnection
{
	if (!notificationsRegistered) 
	{
		[self RegisterNotifications];	
	}
	
	[loginProgress stepCompletedWithDescription:NSLocalizedString(@"PROGRESS_SEARCH_SERVER", nil)];

	if(storage!=nil)
	{
		[storage SaveSettings];
		[storage release];
		storage = nil;
	}
	
	if(currency!=nil)
	{
		[currency release];
		currency = nil;
	}
	 	
	if(gsServer!=nil)
	{
		[gsServer dealloc];
		gsServer = nil;
	}	
	
	if(gsToken!=nil)
	{
		[gsToken dealloc];
		gsToken = nil;
	}	
	if(gsSettings!=nil)
	{
		[gsSettings dealloc];
		gsSettings = nil;
	} 
	isConnecting = YES;
	storage = [[ParamsStorage alloc] init];
	
	storage.charts.serverConn = self.serverConnection;
	storage.trade_progress.serverConn = self.serverConnection;
	storage.trade_progress.mainwnd = self;
	storage.trade_progress.storage = storage;
	storage.serverConn = self.serverConnection;

	[mailList rebind];
	
	gsServer = [GetServer alloc];
	
	NSString *serverUrl = [storage getServerURL:storage.selected_server];
	if ([serverUrl isEqualToString:@""])
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Attention" message:@"Please reselect server." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self any2login:nil];
		return;
	}
	
	
	NSLog(@"server: %@", [storage getServerURL:[storage selected_server]]);
	//[storage clearServerResults];
    NSString *serverResult = [storage getServerResult];
    if (serverResult != nil && [serverResult length] > 0 && ![serverResult isEqualToString:@"none"])
    {
        storage.isUsingCachedPath = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"serverResolved" object:serverResult];
    }
    else
    {
        storage.isUsingCachedPath = NO;
        [gsServer initConnection:self withUrl:[storage getServerURL:[storage selected_server]]]; //storage.selected_server]];
    }
	 //performSelector:@selector(initConnection:) withObject:self afterDelay:0.0];
}


- (void)LoginCanceled:(NSNotification *)notification
{
	[self any2login:self];	
	return;	
}

- (void)serverDidntResolve:(NSNotification *)notification
{
	[gsServer release];
	gsServer = nil;
	
	if([self shouldStopConnecting])
	{
		[self any2login:self];	
		return;
	}
	
	if ([storage getBackupServerURL:storage.selected_server] != nil && !storage.isOnBackupServer)
	{
		NSLog(@"trying the backup server...............");
		//storage.isOnBackupServer = YES;
		isOnBackupServer = YES;
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0];
	}
	else if(!wasConnected)
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
														message:@"Failed to connect the server."  delegate:self cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		isOnBackupServer = NO;
		
		[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
	}
	else
	{
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:2.0];
		isOnBackupServer = NO;
	}
}
	
- (void)serverResolved:(NSNotification *)notification
{

	[gsServer release];
	gsServer = nil; 
	if([self shouldStopConnecting])
	{
		[self LoginCanceled:nil];	
		return;
	}
	
	if(serverHost!=nil)
	{
		[serverHost release];  
		serverHost = nil;
	}
    //TODO: you will need to handle the serverInfo if you have implemented the GetServer.m
	NSString *serverInfo = [notification object];
	NSLog(@"notification object:%@", serverInfo);
    
    //save server result
    storage.serverResult = serverInfo;
    [storage SaveSettings];
    
	if([serverInfo isEqualToString:@"none"])
	{
		if (storage.isUsingCachedPath) 
		{
			[storage clearServerResults];
			[self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0]; 
		}
		else
		{
			CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
															message:@"Failed to resolve the server."  delegate:self cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
			return;	
		}		
	}
	
	NSString *serverAddress = serverInfo;	

	NSArray *serverArgs = [serverAddress componentsSeparatedByString:@":"];
	if(serverArgs.count!=2)
	{	
		return;
	}
	
	serverHost = [[NSString alloc] initWithFormat:@"%@", [serverArgs objectAtIndex:0]];
	serverPort = [[serverArgs objectAtIndex:1] integerValue];
		
	[loginProgress stepCompletedWithDescription: NSLocalizedString(@"PROGRESS_SECURING_SESSION", nil)];
	
	gsToken = [GetToken alloc];
	
    NSString *tokkenResult = [storage getTokkenrResult];
    if (tokkenResult != nil && [tokkenResult length] > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tokenResolved" object:tokkenResult];
    }
    else
    {
        [gsToken initConnection:self withUrl:[storage getServerURL:storage.selected_server]];
    }
}

- (void)tokenDidntResolve:(NSNotification *)notification
{
	[gsToken release];
	gsToken = nil;
	if ([storage getBackupServerURL:storage.selected_server] != nil && !storage.isOnBackupServer)
	{
		NSLog(@"trying the backup server...............");
		//storage.isOnBackupServer = YES;
		isOnBackupServer = YES;
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0];
	}
	else if(!wasConnected)
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
														message:@"Failed to initilize encryption."  delegate:self cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		isOnBackupServer = NO;
		
		[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
	}
	else
	{
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:2.0];
		isOnBackupServer = NO;
	}
}

- (void)tokenResolved:(NSNotification *)notification
{
	[gsToken release];
	gsToken = nil;
	if([self shouldStopConnecting])
	{
		[self LoginCanceled:nil];
		return;
	}
	//TODO: you need to handle the token if have implemented the GetToken.m
	NSString *token = [notification object];
	NSLog(@"Token: %@", token);
    //save server result
    storage.tokkenResult = token;
    [storage SaveSettings];
    
	char binChars[32];
	
	const char *tokenChars = [token UTF8String];

	const char *nextTokenChar = tokenChars;
	char *nextChar = binChars;
	for (NSUInteger i = 0; i < 32; i++)
	{
		unsigned int v;
		sscanf(nextTokenChar, "%2x", &v); 
        //NSLog(@"%2X", v);
		*nextChar = (char)v;
		nextTokenChar += 2;
		nextChar++;
	}
	//[self.serverConnection.codec initWith:binChars];

	[loginProgress stepCompletedWithDescription:NSLocalizedString(@"PROGRESS_CONNECT_SERVER", nil)];

	gsSettings = [GetSettings alloc];


	[gsSettings initConnection:self withUrl:[storage getServerURL:storage.selected_server]];
}


- (void)settingsDidntResolve:(NSNotification *)notification
{
	[gsSettings release];
	gsSettings = nil;
	if ([storage getBackupServerURL:storage.selected_server] != nil && !storage.isOnBackupServer)
	{
		NSLog(@"trying the backup server...............");
		//storage.isOnBackupServer = YES;
		isOnBackupServer = YES;
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0];
	}
	else if(!wasConnected)
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
														message:@"Failed to read settings."  delegate:self cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
		isOnBackupServer = NO;
		
		[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
	}
	else
	{
		[self performSelector:@selector(any2progress:) withObject:nil afterDelay:2.0];
		isOnBackupServer = NO;
	}
}

- (void)settingsResolved:(NSNotification *)notification
{
	[gsSettings release];
	gsSettings = nil;
	
	if([self shouldStopConnecting])
	{
      //!TODO why it is released??
		//[[notification object] release];
		[self LoginCanceled:nil];
		return;
	}
	
	BOOL res = [self.session connectToServerWithHost:serverHost port:(UInt16)serverPort];
	if(!res)
	{
		[self any2login:self];	
	}

}

-(void)applicationWillResignActive:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"hideChart" object:nil];
}

- (void)didConnectSession:( PFSession* )session_
{
	if([self shouldStopConnecting])
	{	
		[self LoginCanceled:nil];
		return;
	}

	[loginProgress stepCompletedWithDescription:NSLocalizedString(@"PROGRESS_AUTHENTICATING", nil)];
	storage.login = [loginView login];
	storage.password = [loginView password];

   [ session_ logonWithLogin: [loginView login]
                    password: [loginView password] ];
}

-(void)session:( PFSession* )session_ didFailConnectWithError:( NSError* )error_
{
	if([self shouldStopConnecting])
	{
		[self any2login:self];	
		return;
	}
    if (storage.isUsingCachedPath) 
    {
        [storage clearServerResults];
        [self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0]; 
    }
    else
    {
        if(!wasConnected)
        {
            CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
                                                            message:@"Failed to connect the server."  delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            
            [self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	   
        }
        else
        {
            [self performSelector:@selector(any2progress:) withObject:nil afterDelay:0.0]; 
        }
    }
}

-(void)didLogonSession:( PFSession* )session_
{
   [ PFSession setSharedSession: session_ ];
}

-(void)session:( PFSession* )session_ didLogoutWithReason:( NSString* )reason_
{
   [ session_ disconnect ];

   CustomAlert *alert = [[CustomAlert alloc] initWithTitle: @"Error"
                                                   message: reason_
                                                  delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];

   [ alert show ];
   [ alert release ];

   [self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
}

-(void)session:( PFSession* )session_ didLoadInstruments:( id< PFInstruments > )instruments_
{
   [ self.storage addInstruments: instruments_ ];

   [ loginProgress stepCompletedWithDescription: NSLocalizedString(@"PROGRESS_SYMBOLS", nil) ];
}

-(void)didFinishBlockTransferSession:( PFSession* )session_
{
   [ self progress2done: nil ];
}

-(void)session:( PFSession* )session_
        symbol:( id< PFSymbol > )symbol_
  didLoadQuote:( id< PFQuote > )quote_
{
   [ self.storage addQuote: quote_ ];
}

-(void)session:( PFSession* )session_
didLoadPositions:( id< PFPositions > )positions_
{
   [ self.storage addPositions: positions_ ];
}

-(void)session:( PFSession* )session_
didUpdatePosition:( id< PFPosition > )position_
{
   [ self.storage updatePosition: position_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
didRemovePosition:( id< PFPosition > )position_
{
   [ self.storage removePosition: position_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
didAddPosition:( id< PFPosition > )position_
{
   [ self.storage addPosition: position_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
 didLoadOrders:( id< PFOrders > )orders_
{
   [ self.storage addOrders: orders_ ];
}

-(void)session:( PFSession* )session_
didLoadAccounts:( id< PFAccounts > )accounts_
{
   [ self.storage addAccounts: accounts_ ];
}

-(void)session:( PFSession* )session_
 didAddAccount:( id< PFAccount > )account_
{
}

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   if ( self.storage.account.accountId == account_.accountId )
   {
      [ self.tabBarManager.tradesController UpdateProfits: YES ];
   }
}

-(void)session:( PFSession* )session_
didReceiveErrorMessage:( NSString* )message_
{
   CustomAlert *alert = [[CustomAlert alloc] initWithTitle: @"Error"
                                                   message: message_
                                                  delegate: self
                                         cancelButtonTitle: @"OK"
                                         otherButtonTitles: nil];
   
   [ alert show ];
   [ alert release ];
}

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_
{
   [ self.storage addOrder: order_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   [ self.storage removeOrder: order_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
didUpdateOrder:( id< PFOrder > )order_
{
   [ self.storage updateOrder: order_ ];
   [ self.tabBarManager.tradesController addPositions: self.storage.trades ];
}

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories_
{
   [ self.tabBarManager.newsController addStories: stories_ ];
}

//TODO: Change to your server responses
- (void)dataReceived:(NSArray *)cmdArgs
{
    //TODO: changeMe should be change with cmdArgs, changeMe is not the same everywhere in the code
    int changeMe = 0;
	NSString *cmd = [cmdArgs objectAtIndex:changeMe];
	if([cmd compare:@"login"]==0 && isConnecting)
	{
		NSString* arg = [cmdArgs objectAtIndex:changeMe];
		if([arg compare:@"success"]==0)//auth successful
		{
			currency = [[cmdArgs objectAtIndex:changeMe] copy];
			//[loginProgress setStep:5];
			[self.serverConnection SendSymbolsRequest];
			if ([cmdArgs count] > 5)
				storage.Margin_Mode = [[cmdArgs objectAtIndex:changeMe] intValue]; 
			else 
				storage.Margin_Mode = MARGIN_USE_ALL;
			
			[storage saveAccount];
		} 
		else
		if([arg compare:@"error"]==0)
		{
			[self.serverConnection Disconnect];
			NSString *msg = NSLocalizedString(@"PROGRESS_AUTH_PWD", nil);
			if([cmdArgs count]>3)
				msg = [cmdArgs objectAtIndex:changeMe];
			CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
															message:msg delegate:self cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
		}
		else
		{
			[self.serverConnection Disconnect];
			CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Error"
															message:@"Wrong login/password. Access denied"  delegate:self cancelButtonTitle:@"OK"
												  otherButtonTitles: nil];
			[alert show];
			[alert release];
			
			[self performSelector:@selector(any2login:) withObject:nil afterDelay:2.0];	
		}
	}
	else
	if([cmd compare:@"info"]==0)
	{
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:@"Information"
											message:[cmdArgs objectAtIndex:changeMe]  delegate:self cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		
	}
	else
	if([cmd compare:@"symbols"]==0)
	{
		[storage PutSymbols:cmdArgs AndUserCurency:currency];
		//[loginProgress setStep:6];
		[self.serverConnection SendSymGroupsRequest];
	}
	
	else
	if([cmd compare:@"symbols_groups"]==0)
	{
		[storage PutSymbolGroups:cmdArgs];
		//[loginProgress setStep:7];
		//[ticker rebind];
		[self.serverConnection SendGetOpenTradesList];
	}		
	else
	if(	[cmd compare:@"trades"]==0)
	{		
		//[openView UpdateTradesList:cmdArgs];
	}	
	else
	if([cmd isEqualToString:@"margin"]) 
	{
		
		[storage ProcessMargin:cmdArgs];
		if(isConnecting)
		{
			isConnecting = NO;
			[self.serverConnection SendReady];
		}
	}
	else
	if([cmd compare:@"finish"]==0)
	{
		wasConnected  = YES;
	}
	else
	if([cmd compare:@"quote"]==0)
	{		
		BOOL isFirst = NO;
		if([storage.Prices count]==0)
			isFirst = YES;
		[storage PutPrices:cmdArgs];
		if(isFirst)
			[self performSelector:@selector(progress2done:) withObject:nil afterDelay:0.0];	
	}	
	else
	if(	[cmd compare:@"add_trade"]==0 ||
		[cmd compare:@"delete_trade"]==0 ||
		[cmd compare:@"act_trade"]==0
		)
	{		
		//[openView UpdateTrades:cmdArgs];
	}	
	else
	if([cmd compare:@"chart_data"]==0)
	{			
		NSString *symbol= [cmdArgs objectAtIndex:changeMe];
		
		[storage.charts OnChartReceived:symbol data:cmdArgs];
			
	}
	else
	if([cmd compare:@"do_trade"]==0 || [cmd compare:@"cancel_trade"]==0 || [cmd compare:@"close_trade"]==0 || [cmd compare:@"delete_trade"]==0)
	{
		[storage.trade_progress SetNotification:cmdArgs];
	}
	else
	if([cmd compare:@"news"]==0)
	{			
		//[newsList ProcessNews:cmdArgs];
	}
	else
	if([cmd compare:@"news_body"]==0)
	{			
		/*NSLog(@"news came");
		
		if([cmdArgs count]>2)
			[newsList ShowNews:[cmdArgs objectAtIndex:changeMe]];
		else
			[newsList ShowNews:@""];*/
			
	}
	else
	if([cmd compare:@"mail"]==0)
	{		
		if([cmdArgs count]>6)	
			[mailList ProcessMail:cmdArgs];
			
	}
}

- (void) logout
{
	//notificationsRegistered = NO; is performed in the unregister method
   [ self.session logout ];
   self.session = nil;

    [self UnRegisterNotification];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self performSelector:@selector(any2login:) withObject:nil afterDelay:0.0];
}

@end
