#import <Foundation/Foundation.h>

#import "TradeRecord.h"
#import "Codec.h"
#import "Base64.h"

@class AsyncSocket;
@protocol PFServerConnectionDelegate;

#define CLIENT_VERSION 502
@interface ServerConnection : NSObject 
{
	AsyncSocket *socket;
	NSString *Host;
    Codec *codec;
	int port;
	BOOL sendConnected;
	BOOL sendErrors;
}
@property ( nonatomic, assign ) id< PFServerConnectionDelegate > delegate;

@property(nonatomic, assign) BOOL sendConnected;
@property(nonatomic, assign) BOOL sendErrors;
@property(nonatomic, retain) Codec* codec;

-(BOOL)ConnectHost:(NSString*)host AndPort:(UInt16)Port;
-(void)SendLogin:(NSString*)aLogin AndPAss:(NSString*)aPass;
-(void)Disconnect;
-(void)onSocketDidDisconnect:(AsyncSocket *)sock;
-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag;
-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;

-(BOOL)ConnectHost:(NSString*)host AndPort:(UInt16)Port;
-(void)SendCommand:(NSString *)cmd;
-(void)SendLogin:(NSString*)aLogin AndPAss:(NSString*)aPass;
-(void)SendLoginNoPump:(NSString*)aLogin AndPAss:(NSString*)aPass;
-(void)SendCred:(NSString*)aLogin AndPAss:(NSString*)aPass;
-(void)SendSymGroupsRequest;
-(void)SendSymbolsRequest;
-(void)SendReady;
-(void)SendGetOpenTradesList;
-(void)SendGetOpenTrades;
-(void)SendChartRequest:(NSString*)symbol AndRange:(NSString*)RangeType;
-(void)SendTradeCancel;
-(void)SendTradeRequest:(TradeRecord*)trade;
-(void)SendTradeCloseRequest:(TradeRecord*)trade AtPrice:(double)price forVolume:(double)vol;
-(void)SendTradeUpdateRequest:(TradeRecord*)trade;
-(void)SendTradeDeleteRequest:(TradeRecord*)trade;
-(void)SendHistoryRequestForStart:(NSDate*)start AndFinish:(NSDate*)end;
-(void)SendNewsRequest:(int)news_id;
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
						  withDeposit:(NSString *)deposit;


@end
