#import "ServerConnection.h"

#import "PFServerConnectionDelegate.h"

#import <AsyncSocket/AsyncSocket.h>

#import <CommonCrypto/CommonDigest.h>

#import <ProFinanceApi/ProFinanceApi.h>

#define CONNECTION_TIMEOUT 7

@interface ServerConnection ()

@property ( nonatomic, strong ) NSData* tail;

@end

@implementation ServerConnection

@synthesize delegate;
@synthesize sendConnected;
@synthesize sendErrors;
@synthesize codec;
@synthesize tail = _tail;

 -(void)dealloc 
{
   [socket release];
   [Host release];
   [codec release];
   [_tail release];
   [super dealloc];
}

-(id) init
{
	self = [super init];
	sendConnected = YES;
	sendErrors = YES;
	socket = [[AsyncSocket alloc] initWithDelegate:self];
	codec = [Codec alloc];
	return self;
}
NSString* md5( NSString *str )
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString  stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4],
			result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12],
			result[13], result[14], result[15]
			];
}

-(BOOL)ConnectHost:(NSString*)host AndPort:(UInt16)Port
{	
	NSLog(@"IP: %@, %d", host, Port);
	NSError *err;
	BOOL res = [socket connectToHost:host onPort:Port withTimeout:CONNECTION_TIMEOUT error:&err];
	
	return res;
}

-(void)Disconnect
{
	[socket disconnect];
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	if(sendErrors)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DisconnectWithError" object:nil];
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	if(sendConnected)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"serverConnected" object:nil];
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data_ withTag:(long)tag
{
   /*NSData* response_data_ = data_;

   if ( self.tail )
   {
      NSMutableData* joined_data_ = [ NSMutableData dataWithData: self.tail ];
      [ joined_data_ appendData: data_ ];
      response_data_ = joined_data_;
   }

   NSData* tail_ = nil;
   NSArray* messages_ = [ NSArray arrayOfMessagesWithData: response_data_ tail: &tail_ ];
   self.tail = tail_;

   for ( PFMessage* message_ in messages_ )
   {
      [ self.delegate serverConnection: self didReceiveMessage: message_ ];
   }

	[sock readDataWithTimeout:-1 tag:10];*/
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	[sock readDataWithTimeout:-1 tag:10];
}

-(void)sendData:( NSData* )data_
{
	[ socket writeData: data_ withTimeout:-1 tag: 0];
}

-(void)SendCommand:(NSString *)cmd
{
    //TODO: add your End Of Line here
	NSString *EOL = @"";
	NSString *strToSend = [[NSString alloc] initWithFormat:@"%@%@", cmd, EOL];
	[cmd autorelease];
	
	NSData* dat = [strToSend dataUsingEncoding: NSASCIIStringEncoding];
	[strToSend release];
	
	
	int len = [dat length];
	unsigned char *rawData = (unsigned char*)malloc(len);
	[dat getBytes:rawData];
	[codec EncryptData:rawData OfLength:len];
	
	NSData *dat2send = [NSData dataWithBytes:rawData length:len];
	free(rawData);
	
	[socket writeData:dat2send withTimeout:-1 tag:0];
}

/*
 Used to send credentials to the server
 */
-(void)SendLogin:(NSString*)aLogin AndPAss:(NSString*)aPass
{
   /*PFPackageBuilder* builder_ = [ PFPackageBuilder new ];
   
	NSData* package_data_ = [ builder_ logonPackageWithLogin: aLogin password: aPass mode: PFLoginModeQuote | PFLoginModeHistory ];

   [ builder_ release ];

	[ self sendData: package_data_ ];*/
}

-(void)SendTradeLogin:(NSString*)aLogin AndPAss:(NSString*)aPass
{
   /*PFPackageBuilder* builder_ = [ PFPackageBuilder new ];

	NSData* package_data_ = [ builder_ logonPackageWithLogin: aLogin password: aPass mode: PFLoginModeTrade ];

   [ builder_ release ];

	[ self sendData: package_data_ ];*/
}


/*
 Used to send credentials to the server when requesting history
 */
-(void)SendLoginNoPump:(NSString*)aLogin AndPAss:(NSString*)aPass
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to send credentials to the server when trading
 */
-(void)SendCred:(NSString*)aLogin AndPAss:(NSString*)aPass
{
	NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request symbol groups from the server during connection
 */
-(void)SendSymGroupsRequest
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request symbols from the server during connection
 */
-(void)SendSymbolsRequest
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to signal the server that the client is ready to start receiving prices
 */
-(void)SendReady
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request the list of open trades
 */
-(void)SendGetOpenTrades
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request the list of open trades
 */
-(void)SendGetOpenTradesList
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request chart data of the symbol at the specified range
 RangeType is an id for 1 minute, 5 minutes, ..., 1 hour, ..., 1 day
 */
-(void)SendChartRequest:(NSString*)symbol AndRange:(NSString*)RangeType
{	
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to cancel an ongoing trade request
 */
-(void)SendTradeCancel
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to do a trade request, instant or market
 trade: the trade object to be used for the trade request
 */
-(void)SendTradeRequest:(TradeRecord*)trade
{
	int exp_time = 0;
	if(trade.close_time!=nil)
	{
		exp_time = [trade.close_time timeIntervalSince1970];
	}
	
	NSString *tradeCmd;
	if (trade.execCommand == 2) 
		tradeCmd = @"";
	else
		tradeCmd = @"";
	
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to send a trade close request
 trade: the trade object to close
 price: the price at which this trade to close
 vol: the volume at which this trade to close
 */
-(void)SendTradeCloseRequest:(TradeRecord*)trade AtPrice:(double)price forVolume:(double)vol
{	
	NSString *tradeCmd;
	if (trade.execCommand == 2)
		tradeCmd = @"";
	else 
		tradeCmd = @"";
	
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to send a trade update request
 trade: the trade object to be used for the update trade request
 */
-(void)SendTradeUpdateRequest:(TradeRecord*)trade
{
	
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to send a trade delete request
 trade: the trade object to be used for the delete trade request
 */
-(void)SendTradeDeleteRequest:(TradeRecord*)trade
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request the history
 start: start timestamp of the history period
 end: end timestamp of the history period
 */
-(void)SendHistoryRequestForStart:(NSDate*)start AndFinish:(NSDate*)end
{ 		
	NSDate *dtStart = [[start copy] autorelease];
	NSDate *dtEnd = [[end copy] autorelease];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSDateComponents *comps = [gregorian components:  (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate: start];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	dtStart = [gregorian dateFromComponents:comps];
	//[comps release];
	[gregorian release];
    
    int dateDaylightSaving = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:dtStart];
	int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];// - dateDaylightSaving;
    if (dateDaylightSaving == 0) 
    {
        gmt_delta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
    }
    
    dtStart = [dtStart addTimeInterval:(NSTimeInterval)gmt_delta];
    
	NSCalendar *gregorian1 = [[NSCalendar alloc]
							  initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps1 = [gregorian1 components:  (NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit) fromDate: end];
	[comps1 setHour:0];
	[comps1 setMinute:0];
	[comps1 setSecond:0];
	dtEnd = [gregorian1 dateFromComponents:comps1];
	//[comps1 release];
	[gregorian1 release];
    
    dateDaylightSaving= 0;
    gmt_delta = 0;
	dateDaylightSaving = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:dtStart];
	gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];// - dateDaylightSaving;
    if (dateDaylightSaving == 0) 
    {
        gmt_delta -= [[NSTimeZone localTimeZone] daylightSavingTimeOffset];
    }
    
    NSTimeInterval secondsPerDay = (24 * 60 * 60);
    dtEnd = [dtEnd addTimeInterval:(NSTimeInterval)(gmt_delta+secondsPerDay)];
	
    //the following will round to integer days
	//int iStart = secondsPerDay*(int)([dtStart timeIntervalSince1970]/secondsPerDay);
	//int iEnd = secondsPerDay*(int)([dtEnd timeIntervalSince1970]/secondsPerDay);
    
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to request the news body based on the news id
 news_id: the id of the news to fetch the body
 */
-(void)SendNewsRequest:(int)news_id
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
/*
 Used to create a demo account on the server
 group: is one of the values in ClientSettings.m - (NSArray *)groups
 leverage: is one of the values in ClientSettings.m - (NSArray *)leverage
 deposit: is one of the values in ClientSettings.m - (NSArray *)deposit
 */
-(void)SendDemoAccountRequestWithName:(NSString *)name 
							withGroup:(NSString *)group 
						  withCountry:(NSString *)country 
							withState:(NSString *)state
							 withCity:(NSString *)city 
						  withZipcode:(NSString *)zip 
						  withAddress:(NSString *)address 
 							withPhone:(NSString *)phone 
							withEmail:(NSString *)email 
						 withLeverage:(NSString *)leverage 
						  withDeposit:(NSString *)deposit
{
    NSString *aCmd = @"";
	[self SendCommand:aCmd];
}
@end
















