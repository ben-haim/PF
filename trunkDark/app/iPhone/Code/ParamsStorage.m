#import "ParamsStorage.h"
#import "Conversion.h"
#import "SymbolInfo.h"
#import "SymbolGroup.h"
#import "TickData.h"
#import "iTraderAppDelegate.h"
#import "AccountInfo.h"
#import <XiPFramework/PropertiesStore.h>

#import <ProFinanceApi/ProFinanceApi.h>

@interface ParamsStorage ()

@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation ParamsStorage
@synthesize Servers, serverConn, ContactsURL;
@synthesize ExtSymbols, Symbols, SymGroups, mailItems, Prices, SumSwap, SumSwapOrig, SumProfit, Margin, Credit, Margin_Mode,
	history_start, history_finish, login, password, selected_server, chartInterval, SumProfits, SumLosses;
@synthesize FavSymbols;
@synthesize profitFormatter, volumeFormatter, priceFormatter;
@synthesize charts, trade_progress;
@synthesize clientSettings, isOnBackupServer, currentChartInterval, accounts, userCurrency, userDecimals;
@synthesize serverResult, tokkenResult, isUsingCachedPath;
@synthesize chartDefSettings, chartSettings;

@synthesize account = _account;

@synthesize trades;

-(id) init
{	
	self = [super init];
   self.trades = [ NSMutableArray array ];
	ExtSymbols = [[NSMutableSet alloc] init];
	Symbols = [[NSMutableDictionary alloc] init];
	Prices = [[NSMutableDictionary alloc] init];	
	FavSymbols = [[NSMutableArray alloc] init];
	mailItems = [[NSMutableArray alloc] init];
	charts = [[ChartStorage alloc] init];
	charts.serverConn = self;
	currentChartInterval = @"1";
	
	trade_progress = [[TradeProgress alloc] init];
	
	chartInterval = @"1";
	SumSwap = 0.0;
	SumSwapOrig = 0.0;
	SumProfit = 0.0;
	//load settings
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	self.login = [prefs objectForKey:@"login"];
	
	NSString *remember_pass = [prefs stringForKey:@"remember_password"];
	if (remember_pass == nil)
	{
		[prefs setObject:@"1" forKey:@"remember_password"];
		self.password = [prefs objectForKey:@"password"];
	}
	else if ([remember_pass isEqualToString:@"1"]) 
	{
		self.password = [prefs objectForKey:@"password"];
	}
	else 
		[prefs setObject:@"" forKey:@"password"];
	
	self.selected_server = [prefs objectForKey:@"server_alias"];
	
	history_start = [[NSDate date] retain];
	
	history_finish = [[NSDate date] retain];
	
	clientSettings = [[ClientSettings alloc]init];
	
    [self loadFavorites];
    
    //load saved connection strings
    self.serverResult = [self getServerResult];
    self.tokkenResult = [self getTokkenrResult];

    //TODO: Here you need to supply server information.
	//CocaCola info
	ContactsURL = @"http://www.cocacola.com";
	Servers = [[NSMutableArray alloc] init];
	//ServerInfo *si = nil;
	//si = [[ServerInfo alloc] init];
	//si.alias = @"CocaCola - Real";
	//si.base_url = @"192.168.1.1:8080";
	//si.backup_url = @"192.168.1.1:8080";
	[Servers addObject: [ ServerInfo infoWithAlias: @"CocaCola - Real"
                                         baseURL: @"192.168.1.1:8080"
                                       backupURL: @"192.168.1.1:8080"
                                          isDemo: NO ] ];

   [Servers addObject: [ ServerInfo infoWithAlias: @"CocaCola - Demo"
                                          baseURL: @"192.168.1.1:8080"
                                        backupURL: @"192.168.1.1:8080"
                                           isDemo: YES ] ];
   
   [Servers addObject: [ ServerInfo infoWithAlias: @"PFSoft - Demo"
                                          baseURL: @"176.9.146.243:8090"
                                        backupURL: @"176.9.146.243:8090"
                                           isDemo: YES ] ];
   
	//si = [[ServerInfo alloc] init];
	//si.alias = @"CocaCola - Demo";
	//si.base_url = @"192.168.1.1:8080";
	//si.backup_url = @"192.168.1.1:8080";
	//si.demo = YES;
	//[Servers addObject:si];
	//[si autorelease];

   
   
	
    //moved under the server so we can filter the accounts with the active servers
	accounts = [self getSavedAccounts];
    
	if (![self isServerValid:selected_server])
    {
        self.selected_server = nil;
    }
    
	[mailItems release];
	NSData *data = [prefs objectForKey:@"mail"];	
	NSArray *_mailItems = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	mailItems = [[NSMutableArray alloc] initWithArray:_mailItems];
	
	profitFormatter = [[NSNumberFormatter alloc] init];
	[profitFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[profitFormatter setPositiveFormat:@"#,###"];
	[profitFormatter setNegativeFormat:@"-#,###"];
	
	[profitFormatter setDecimalSeparator:@"."];
	[profitFormatter setGeneratesDecimalNumbers:TRUE];
	[profitFormatter setMinimumFractionDigits:2];
	[profitFormatter setMinimumIntegerDigits:1];
	[profitFormatter setMaximumFractionDigits:2];
	[profitFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	
	volumeFormatter = [[NSNumberFormatter alloc] init];
	[volumeFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[volumeFormatter setDecimalSeparator:@"."];
	[volumeFormatter setGeneratesDecimalNumbers:TRUE];
	[volumeFormatter setMinimumFractionDigits:2];
	[volumeFormatter setMinimumIntegerDigits:1];
	[volumeFormatter setMaximumFractionDigits:2];
	
	priceFormatter = [[NSNumberFormatter alloc] init];
	[priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[priceFormatter setDecimalSeparator:@"."];
	[priceFormatter setGeneratesDecimalNumbers:TRUE];
	[priceFormatter setMinimumIntegerDigits:1];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(priceUpdate) userInfo:nil repeats:YES];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chart_def_settings" ofType:@"json"];
    chartDefSettings = [NSString stringWithContentsOfFile:filePath
                                                 encoding: NSUTF8StringEncoding
                                                    error: NULL];
    [chartDefSettings retain];
    
    PropertiesStore *ps = [[PropertiesStore alloc] initWithString:chartDefSettings];
    uint version = [[ps getParam:@"version"] intValue];
    
    chartSettings = [prefs stringForKey:@"chartSettings"];
    if (chartSettings==nil || [chartSettings isEqualToString:@""]) 
    {
        chartSettings = [[NSString alloc] initWithFormat:@"%@",chartDefSettings];
    }
    else
    {
        PropertiesStore *storedPS = [[PropertiesStore alloc] initWithString:chartSettings];
        uint storedVersion = [[storedPS getParam:@"version"] intValue];
        if(version > storedVersion)
        {
            chartSettings = [[NSString alloc] initWithFormat:@"%@",chartDefSettings];
        }
        else
        {
            [chartSettings retain];   
        }
        [storedPS release];
    }
    [ps release];

    //we start the application with normal deposit currency view
    openTradesView = OPEN_TRADE_VIEW_DEPOSIT_CUR;
    
	return self;
}

- (BOOL)isServerValid:(NSString*)server
{
	BOOL serverValid = NO;
	for (int i = 0; i < [Servers count] && !serverValid; ++i)
	{
		ServerInfo *serverInfo = [Servers objectAtIndex:i];
		NSString * serverAlias = serverInfo.alias;
		if ([serverAlias isEqualToString:server])
		{
			serverValid = YES;
		}
	}
	return serverValid;
}

-(NSMutableArray*)getSavedAccounts
{
	NSMutableArray * savedAccounts = nil;

	savedAccounts = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"AccountsTest8"]];
    
	if (accounts == nil)
	{
		accounts = [[NSMutableArray alloc] init];
	}
	[accounts removeAllObjects];
	for (int i = 0; i < [savedAccounts count]; ++i)
	{
		NSString *accountInfo = [savedAccounts objectAtIndex:i];
        NSArray *accInfo = [accountInfo componentsSeparatedByString:@"\0"];
		NSString * serverAlias = [NSString stringWithFormat:@"%@", [accInfo objectAtIndex:2]];
		if([self isServerValid:serverAlias])
		{
			[accounts addObject:accountInfo];
		}
	}
	[savedAccounts release];
	return accounts;
}

-(void)saveAccounts:(NSMutableArray*)mutArray
{
	[[NSUserDefaults standardUserDefaults] setObject:mutArray forKey:@"AccountsTest8"];

	[[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getServerURL:(NSString*)alias
{	
	NSEnumerator *enumerator = [Servers objectEnumerator];
	ServerInfo *value;	
	while ((value = [enumerator nextObject])) 
	{
		//NSLog(@"%@", value.base_url);
		//NSLog(@"%@", value.alias);
		//NSLog(@"%@", alias);
		if([value.alias isEqualToString:alias])
		{
			iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
			isOnBackupServer = [appDelegate isOnBackupServer];

			NSLog(@"isOnBackupServer: %d", isOnBackupServer);
			if (isOnBackupServer == YES)
				return value.backup_url;
			else
				return value.base_url;
		}
	}
	return @"";
}

-(NSString*)getBackupServerURL:(NSString*)alias
{	
	NSEnumerator *enumerator = [Servers objectEnumerator];
	ServerInfo *value;	
	while ((value = [enumerator nextObject])) 
	{
		//NSLog(@"%@", value.base_url);
		//NSLog(@"%@", value.alias);
		//NSLog(@"%@", alias);
		if([value.alias isEqualToString:alias])
			return value.backup_url;
	}
	return @"";
}	

-(void) ReleasePrices
{	
	//NSEnumerator *enumerator = [Prices objectEnumerator];
	//id value;
	
	/*while ((value = [enumerator nextObject])) 
	{
		[value release];
	}*/
	//[Prices removeAllObjects];
	[Prices release];
	[FavSymbols release];
}
-(void) ReleaseExtSymbols
{	 
	//NSEnumerator *enumerator = [Prices objectEnumerator];
	//id value;
	
	/*while ((value = [enumerator nextObject])) 
	 {
	 [value release];
	 }*/
	//[Prices removeAllObjects];
	[ExtSymbols release];
}

-(void) ReleaseMailItems
{	
	//NSEnumerator *enumerator = [mailItems objectEnumerator];
	//id value;	
	//while ((value = [enumerator nextObject])) 
	//{
	//	[value release];
	//}
	//[SymGroups removeAllObjects];
	[mailItems release];
}

-(void)saveAccount
{
	AccountInfo *acinfo = [[AccountInfo alloc] init];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[acinfo setAccount:self.login];
	
	NSString *remember_pass = [prefs stringForKey:@"remember_password"];
	if ([remember_pass isEqualToString:@"1"]) 
	{
		[acinfo setPassword:self.password];
	}
	else
	{ 
		[acinfo setPassword:@""];
	}
	
	[acinfo setServerAlias:self.selected_server];	
	[acinfo saveAccount];
	[acinfo release];
	
}

-(void)SaveSettings
{
	//save settings
	//AccountInfo *acinfo = [[AccountInfo alloc] init];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:self.login forKey:@"login"];
	//[acinfo setAccount:self.login];
	
	NSString *remember_pass = [prefs stringForKey:@"remember_password"];
	if ([remember_pass isEqualToString:@"1"]) 
	{
		[prefs setObject:self.password forKey:@"password"];
				//[acinfo setPassword:self.password];
	}
	else
	{ 
		[prefs setObject:@"" forKey:@"password"];
				//[acinfo setPassword:@""];
	}
	
	
	[prefs setObject:self.selected_server forKey:@"server_alias"];
			
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:mailItems];	
	[prefs setObject:data forKey:@"mail"];
    
    if (serverResult != nil)
    {
		NSString *serverResultKey = [NSString stringWithFormat:@"server_result:%@", self.selected_server];
        [prefs setObject:serverResult forKey:serverResultKey];
    }
    if (tokkenResult != nil)
    {
		NSString *tokkenResultKey = [NSString stringWithFormat:@"tokken_result:%@", self.selected_server];
        [prefs setObject:tokkenResult forKey:tokkenResultKey];
    }
    
    [prefs setObject:chartSettings forKey:@"chartSettings"];
	
	[prefs synchronize];
	
	//[acinfo release];
}

- (void)clearServerResults
{
    isUsingCachedPath = NO;
    serverResult = @"";
    tokkenResult = @"";
    [self SaveSettings];
}

- (NSString*)getServerResult
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *serverResultKey = [NSString stringWithFormat:@"server_result:%@", self.selected_server];
    self.serverResult = [prefs objectForKey:serverResultKey];
	return serverResult;
}

- (NSString*)getTokkenrResult
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *tokkenResultKey = [NSString stringWithFormat:@"tokken_result:%@", self.selected_server];
    self.tokkenResult = [prefs objectForKey:tokkenResultKey];	
	return tokkenResult;
}

- (void)saveFavorites
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* favs = [self.FavSymbols componentsJoinedByString:@"|"];
    NSString *favoritesKey = [NSString stringWithFormat:@"favs:%@:%@", self.selected_server, self.login];
    [prefs setObject:favs forKey:favoritesKey];
    [prefs synchronize];
}

- (void)loadFavorites
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *favoritesKey = [NSString stringWithFormat:@"favs:%@:%@", self.selected_server, self.login];
    NSString *favs = [prefs objectForKey:favoritesKey];
    
    [FavSymbols removeAllObjects];
    
	if (favs == nil)
	{
        for (SymbolGroup *group in SymGroups)
        {
            if ([[group symbols] count] > 0)
            {
                for (SymbolInfo *si in [group symbols])
                {
                    [FavSymbols addObject:[si Symbol]];
                    if ([FavSymbols count] >= 5)
                    {
                        // don't add by default more thn 5 symbols to favorites
                        break;
                    }
                }
                break;
            }
        }
	}
    else if (![favs isEqualToString:@""])
    {
        [FavSymbols addObjectsFromArray:[favs componentsSeparatedByString:@"|"]];
    }
}

- (void)dealloc 
{
	[ExtSymbols release];
	[SymGroups release];
	[Symbols release]; 
	[Prices release];
	[FavSymbols release];
	[mailItems release];
	[Servers release];
	[timer invalidate];
	[profitFormatter release];
	[volumeFormatter release];
	[priceFormatter release];
	[charts release];
	[history_start release];
	[history_finish release]; 
	[trade_progress release];
	[chartInterval release];	
	[accounts dealloc];
    if (serverResult != nil)
    {
        [serverResult release];
    }
    if (tokkenResult != nil)
    {
        [tokkenResult release];
    }
    
    [chartDefSettings release];
    [chartSettings release];
   [ _account release ];

	[super dealloc];
}

NSInteger groupSort(SymbolGroup* group1, SymbolGroup* group2, void *reverse)
{
    int idx1 = [group1 MinSymbolIndex];
    int idx2 = [group2 MinSymbolIndex];
	
   if(idx1<idx2)
	   return NSOrderedAscending;
	else
	if(idx1>idx2)
		return NSOrderedDescending;
	else		
		return NSOrderedSame;
}


NSInteger symbolSort(SymbolInfo* sym1, SymbolInfo* sym2, void *reverse)
{
    int idx1 = [sym1 OrderBy];
    int idx2 = [sym2 OrderBy];
	
	if(idx1<idx2)
		return NSOrderedAscending;
	else
		if(idx1>idx2)
			return NSOrderedDescending;
		else		
			return NSOrderedSame;
}

- (void)setUserCurrency:(NSString *)currency
{
    userCurrency = currency;
    if (![currency isEqualToString:@"JPY"])
    {
        [self setUserDecimals:2];
    }
    else
    {
        [self setUserDecimals:0];
    }
}

/*
 This function is used to collect the symbol data from the server
 As you can see in the dummy implementation, the function creates only one SymbolInfo entry
 and stores it in the Symbols
 Most probably you will need to pass more than one SymbolInfo entry in the args 
 and store them using a loop
 */
- (void) PutSymbols:(NSArray *)symbol_args AndUserCurency:(NSString*)cur
{
    [self setUserCurrency:cur];
	
		NSString * symbol_name = @"EURUSD";
		
		SymbolInfo *symbol = [[SymbolInfo alloc] init];
		symbol.OrderBy = 0;
        symbol.Symbol = symbol_name;
		symbol.Desc =  @"Euro vs US Dollar";
        symbol.GroupId = 0;
        symbol.Digits = 3;
        symbol.TradeMode = 0;
		symbol.ProfitMode = 0;
		symbol.StopsLevel = 1;
		symbol.ContractSize = 0.1;
		symbol.TickValue = 0.1;   
		symbol.TickSize = 0.1;
		symbol.DepositCurrency = @"EUR";
		symbol.ExecMode = 0;
		symbol.Lot_Min = 1/100; 
		symbol.Lot_Max = 10/100; 
		symbol.Lot_Step = 1/100; 
		symbol.isExt = ([ExtSymbols containsObject:symbol.Symbol]);
		[symbol autorelease];
		[Symbols setObject:symbol forKey:symbol.Symbol];

    
	NSEnumerator *enumerator = [Symbols objectEnumerator];
	SymbolInfo *sym;		
	while ((sym = [enumerator nextObject])) 
	{		
		if ([sym.Symbol isEqualToString:@"USDRUR"])
		{
			NSLog(@"USDRUR");
		}
		
		if(sym.ProfitMode!=0)
		{
			if([cur isEqualToString:sym.DepositCurrency])
			{
				sym.Conv1 = [ [Conversion new] autorelease ];
				sym.Conv1.Constant = YES;
				continue;
			}
			sym.Conv1 = [self GetConversion:sym.DepositCurrency AndC2:cur]; 
			if ([sym.Conv1 IsEmpty])
			{
				sym.Conv1 = [self GetConversion:sym.DepositCurrency AndC2:@"USD"];
				sym.Conv2 = [self GetConversion:@"USD" AndC2:cur];
			}
		}
		else
		{ 
			//sym.Conv1 = [self Pair2Cur:sym.Symbol ForCur:cur]; 
			sym.Conv1 = [self Pair2Cur:sym.Symbol ForCur:cur isFirstConversion:YES]; // in the first conversion we do not reverse the symbol
			if(![sym.Conv1 IsEmpty])
				continue;
		
			sym.Conv1 = [self Pair2Cur:sym.Symbol ForCur:@"USD"  isFirstConversion:NO];
			if(![sym.Conv1 IsEmpty])
			{
				//sym.Conv2 = [self Pair2Cur:sym.Conv1.Pair ForCur:cur];	
				sym.Conv2 = [self GetConversion:[sym.Conv1 ProfitCurrency] AndC2:cur];
			}
			else
			{
				sym.Conv1 = [self Pair2Cur:sym.Symbol ForCur:cur SymbolNameLength:6 isFirstConversion:YES];
				
				if (![sym.Conv1 IsEmpty])
					continue;
				
				sym.Conv1 = [self Pair2Cur:sym.Symbol ForCur:@"USD" SymbolNameLength:6 isFirstConversion:NO];
				if (![sym.Conv1 IsEmpty])
				{
					//sym.Conv2 = [self Pair2Cur:sym.Conv1.Pair ForCur:cur SymbolNameLength:6];
					sym.Conv2 = [self GetConversion:[sym.Conv1 ProfitCurrency] AndC2:cur];
					int i = 0;
					i++;
				}
			}
			
		}//USD CHF   ->>EUR*/ 
	}
}

-(Conversion*)Pair2Cur:(NSString *)pair ForCur:(NSString *)cur SymbolNameLength:(int)len isFirstConversion:(BOOL)firstConv
{
	Conversion *Conv;
	NSString *p1, *p2;
	if ([pair length]<3)
	{
		Conv = [[Conversion alloc] init];
		Conv.Constant = true;
		Conv.Pair = pair;
		return [Conv autorelease];
	}
	p1 = [pair substringToIndex:3];
	//p2 = [pair substringFromIndex:3];
	if ([pair length]>5)
		p2 = [pair substringWithRange:NSMakeRange(3, 3)];
	else 
		p2 = [pair substringFromIndex:3];
	
	if([p2 isEqualToString:cur])
	{
		Conv = [[Conversion alloc] init];
		Conv.Constant = true;
		Conv.Pair = [NSString stringWithFormat:@"%@%@", cur, cur];//<-- fix
		return [Conv autorelease];
	} 
	Conv = [self GetConversion:p2 AndC2:cur SymbolNameLength:len];
	if(![Conv IsEmpty] || firstConv)
	{
		return Conv;
	}
	Conv = [self GetConversion:p1 AndC2:cur SymbolNameLength:len]; 
	if(![Conv IsEmpty])
	{
		Conv.ReversePrevious = true;
		return Conv;
	}
	return Conv;
}

-(Conversion*)Pair2Cur:(NSString*)pair ForCur:(NSString*)cur isFirstConversion:(BOOL)firstConversion
{
	return [self Pair2Cur:pair ForCur:cur SymbolNameLength:0 isFirstConversion:firstConversion];	
}

-(Conversion*)GetConversion:(NSString*)cur1 AndC2:(NSString*)cur2
{
	Conversion *Conv;
	Conv = [self GetConversion:cur1 AndC2:cur2 SymbolNameLength:0];
	return Conv;
}

-(Conversion*)GetConversion:(NSString*)cur1 AndC2:(NSString*)cur2 SymbolNameLength:(int)len
{
	Conversion *Conv;
	Conv = [self GetConversionInternal:cur1 AndC2:cur2 SymbolNameLength:len]; 	
	return Conv;
}

-(Conversion*)GetConversionInternal:(NSString*)cur1 AndC2:(NSString*)cur2 SymbolNameLength:(int)len
{
	Conversion *Conv;
	Conv = [[Conversion alloc] init];
	NSString *forward = [[NSString alloc] initWithFormat:@"%@%@", cur1, cur2];
	NSString *reverse = [[NSString alloc] initWithFormat:@"%@%@", cur2, cur1];
	
	SymbolInfo *si;
	
	si = [Symbols objectForKey:forward];
	if (si==nil)
		si = [self getContainedSymbol:forward];
		
	
	if (si!=nil)
	{
		Conv.Pair = forward;
		
			Conv.Pair = [si Symbol];
		Conv.Divide = false; 
	}
	else
	{
		
		si = [Symbols objectForKey:reverse];
		if (si==nil)
			si = [self getContainedSymbol:reverse];
		
		
		if (si!=nil)
		{
			Conv.Pair = reverse;
			
				Conv.Pair = [si Symbol];
			Conv.Divide = true;
		}
	}
	[forward release];
	[reverse release]; 
	return [Conv autorelease];
}

-(SymbolInfo*) getSymbolIgnorePrefix:(NSString *)symbolName prefixLength:(int)len
{
	NSArray *keys = [Symbols allKeys];
	for (int i=0; i<[keys count]; i++)
	{
		SymbolInfo *si = [Symbols objectForKey:[keys objectAtIndex:i]];
		if ([[si Symbol] length]<len || [symbolName length]<len)
			continue;
		
		if ([[[si Symbol] substringToIndex:len-1] isEqualToString:[symbolName substringToIndex:len-1]])
		{
			return [Symbols objectForKey:[keys objectAtIndex:i]]; 
		}
	}
	return nil;
}

-(SymbolInfo*) getContainedSymbol:(NSString *)symbolName
{
	NSRange symbolRange;
	
	NSArray *keys = [Symbols allKeys];
	for (int i=0; i<[keys count]; i++)
	{
		SymbolInfo *si = [Symbols objectForKey:[keys objectAtIndex:i]];
		if ([[si Symbol] length]<6 || [symbolName length]<6)
			continue;
		
		symbolRange =[[si Symbol] rangeOfString:symbolName];
		
		if(symbolRange.location != NSNotFound)
		{
			//substring found
			return [Symbols objectForKey:[keys objectAtIndex:i]];
		}		
	}	
	return nil;
}

/*
 This function is used to collect the price data from the server
 As you can see in the dummy implementation, the function creates only one TickData entry
 and stores it in the Prices
 Most probably you will need to pass more than one TickData entry in the args 
 and store them using a loop
 */
- (void) addTickData:(TickData *)tick_data_
{
		int time_temp = 0;
		int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
		tick_data_.lastUpdate = [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] addTimeInterval:(NSTimeInterval)-gmt_delta];

   //!TODO check nil symbol
		[ self.Prices setObject:tick_data_ forKey:tick_data_.Symbol ];

		[charts priceUpdated:tick_data_];
}

- (void)priceUpdate 
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"priceChanged" object:nil];
}

/*- (void) ProcessMargin:(NSArray *)margin
{
    //TODO: normally the balance, margin and credit is in the margin array
	Balance = 0;
	Margin = 0;
	if ([margin count] > 3)
		Credit = 0;
}*/

-(NSString*) formatPrice:(double)value forSymbol:(NSString*)symbol
{
	SymbolInfo *s = [Symbols objectForKey:symbol];
	int digits=5;
	if(s!=nil)
		digits = s.Digits;
	else 
		digits = 2;

	
	[priceFormatter setMinimumFractionDigits:digits];
	[priceFormatter setMaximumFractionDigits:digits];
	//NSNumber *c = [NSNumber numberWithFloat:value];
	NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", value]];
	NSString * st = [priceFormatter stringFromNumber:c];

	return st;
}
-(NSString*) formatVolume:(double)value 
{
	NSNumber *c = [NSNumber numberWithFloat:value];
	NSString * st = [volumeFormatter stringFromNumber:c];
	return st;
	
}


-(NSString*) formatProfit:(double)value 
{
    NSString *st = nil;
    if (userDecimals > 0 || openTradesView == OPEN_TRADE_VIEW_POINTS)
    {
        [profitFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", value]];
        st = [profitFormatter stringFromNumber:c]; 
    }
    else
    {	
        double valueBeforeRound = 0;
        if (value < 0)
        {
            valueBeforeRound = value - 0.5;
        }
        else
        {
            valueBeforeRound = value + 0.5;
        }
        int integerNumber = (int)valueBeforeRound;
        st = [NSString stringWithFormat:@"%d", integerNumber]; 
    }
	return st;
}

-(NSString*)formatPercentage:(double)value 
{
    NSString *st = nil;
    [profitFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSDecimalNumber *c = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f", value]];
    st = [profitFormatter stringFromNumber:c]; 
    return st;
}

-(BOOL)validateFloat:(NSString *)val
{
	NSString *regex = @"[0-9]+|[0-9]+.[0-9]+";
	
	NSPredicate *regextest = [NSPredicate
							  predicateWithFormat:@"SELF MATCHES %@", regex];
	
	//NSLog(@"val: %@, number: %@", val, [number stringValue]);
	
	if ([regextest evaluateWithObject:val] == NO) // if it does not qualify with the regex
	{
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		NSNumber *number = [formatter numberFromString:val]; //NSLog(@"%@", [formatter numberFromString:val]);
		[formatter release];
		
		if ([regextest evaluateWithObject:[number stringValue]] == NO)  // convert it to non formatted string and evaluate again
		{
			//regex = @"[\u0660-\u0669]+|[\u0660-\u0669]+.[\u0660-\u0669]+"; 
			//return [regextest evaluateWithObject:val];
			if ([val doubleValue] == 0)
			{
				return NO;
			}
			else {
				return YES;
			}

		}
	}
	else 
	{
		return YES;
	}
	return YES;
}

-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3 forSymbol:(NSString*)symbol
{	
	SymbolInfo* sym = [[self Symbols] objectForKey:symbol];
	
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

- (void)setOpenTradesView:(OpenTradesViewType)viewType
{
    if (viewType == OPEN_TRADE_VIEW_DEPOSIT_CUR || viewType == OPEN_TRADE_VIEW_POINTS)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"resetTradeProfits" object:nil];
    }
    openTradesView = viewType;
}

- (OpenTradesViewType)openTradesView
{
    return openTradesView;
}

-(double)Balance
{
   return self.account.balance;
}

@end

@implementation ParamsStorage (PF)

-(void)addInstrument:( id< PFInstrument > )instrument_
{
   for ( id< PFSymbol > pf_symbol_ in instrument_.symbols )
   {
      [ self addSymbolInfo: [ SymbolInfo symbolInfoWithSymbol: pf_symbol_ ] ];
   }
}

-(void)addGroups:( NSArray* )groups_
{
   NSMutableArray* sym_groups_ = [ NSMutableArray arrayWithCapacity: [ groups_ count ] ];
   
   for ( id< PFInstrumentGroup > group_ in groups_ )
   {
      [ sym_groups_ addObject: [ SymbolGroup groupWithInstrumentGroup: group_ ] ];
   }

   self.SymGroups = sym_groups_;
}

-(void)addInstruments:( id< PFInstruments > )instruments_
{
   for ( id< PFInstrument > instrument_ in instruments_.instruments )
   {
      [ self addInstrument: instrument_ ];
   }

   [ self addGroups: instruments_.groups ];
}

-(void)addSymbolInfo:( SymbolInfo* )info_
{
   [ self.Symbols setObject: info_ forKey: info_.Symbol ];
}

-(void)addQuote:( id< PFQuote > )quote_
{
   [ self addTickData: [ TickData tickDataWithQuote: quote_ ] ];
}

-(void)addPositions:( id< PFPositions > )positions_
{
   NSArray* positions_array_ = positions_.positions;
   for ( id< PFPosition > position_ in positions_array_ )
   {
      [ self.trades addObject: [ TradeRecord tradeRecordWithPosition: position_ ] ];
   }
}

-(void)addOrders:( id< PFOrders > )orders_
{
   NSArray* orders_array_ = orders_.orders;
   for ( id< PFOrder > order_ in orders_array_ )
   {
      [ self addOrder: order_ ];
   }
}

-(void)addAccounts:( id< PFAccounts > )accounts_
{
   self.account = [ accounts_.accounts objectAtIndex: 0 ];
}

-(void)addOrder:( id< PFOrder > )order_
{
   TradeRecord* trade_record_ = [ TradeRecord tradeRecordWithOrder: order_ ];
   if ( trade_record_ )
   {
      [ self.trades addObject: trade_record_ ];
   }
}

-(void)removeOrder:( id< PFOrder > )order_
{
   NSUInteger trade_record_index_ = [ self.trades indexOfObjectPassingTest: ^BOOL(id obj_, NSUInteger idx_, BOOL *stop_)
                                     {
                                        TradeRecord* trade_record_ = ( TradeRecord* )obj_;
                                        if ( trade_record_.isOrder && trade_record_.order == order_.orderId )
                                        {
                                           *stop_ = YES;
                                           return YES;
                                        }
                                        return NO;
                                     }];

   if ( trade_record_index_ != NSNotFound )
   {
      [ self.trades removeObjectAtIndex: trade_record_index_ ];
   }
}

-(void)updateOrder:( id< PFOrder > )order_
{
   [ self removeOrder: order_ ];
   [ self addOrder: order_ ];
}

-(void)addPosition:( id< PFPosition > )position_
{
   [ self.trades addObject: [ TradeRecord tradeRecordWithPosition: position_ ] ];
}

-(void)removePosition:( id< PFPosition > )position_
{
   NSUInteger trade_record_index_ = [ self.trades indexOfObjectPassingTest: ^BOOL(id obj_, NSUInteger idx_, BOOL *stop_)
                                     {
                                        TradeRecord* trade_record_ = ( TradeRecord* )obj_;
                                        if ( !trade_record_.isOrder && trade_record_.positionId == position_.positionId )
                                        {
                                           *stop_ = YES;
                                           return YES;
                                        }
                                        return NO;
                                     }];

   if ( trade_record_index_ != NSNotFound )
   {
      [ self.trades removeObjectAtIndex: trade_record_index_ ];
   }
}

-(void)updatePosition:( id< PFPosition > )position_
{
   [ self removePosition: position_ ];
   [ self addPosition: position_ ];
}

@end
