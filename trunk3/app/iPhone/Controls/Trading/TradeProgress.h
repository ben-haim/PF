
#import <Foundation/Foundation.h>
#import "../../Code/TradeRecord.h"

enum ReturnValues
{
		RET_OK=0,             // all OK
		RET_OK_NONE=1,                     // all OK-no operation
		RET_ERROR=2,                       // general error
		RET_INVALID_DATA=3,                // invalid data
		RET_TECH_PROBLEM=4,                // server technical problem
		RET_OLD_VERSION=5,                 // old client terminal
		RET_NO_CONNECT=6,                  // no connection
		RET_NOT_ENOUGH_RIGHTS=7,           // no enough rights
		RET_TOO_FREQUENT=8,                // too frequently access to server
		RET_MALFUNCTION=9,                 // mulfunctional operation
		RET_GENERATE_KEY=10,                // need to send public key
		RET_SECURITY_SESSION=11,            // security session start
		//---- account status
		RET_ACCOUNT_DISABLED=64,         // account blocked
		RET_BAD_ACCOUNT_INFO=65,            // bad account info
		RET_PUBLIC_KEY_MISSING=66,          //                 
		//---- trade
		RET_TRADE_TIMEOUT=128,        // trade transatcion timeou expired
		RET_TRADE_BAD_PRICES=129,            // order has wrong prices
		RET_TRADE_BAD_STOPS=130,             // wrong stops level
		RET_TRADE_BAD_VOLUME=131,            // wrong lot size
		RET_TRADE_MARKET_CLOSED=132,         // market closed
		RET_TRADE_DISABLE=133,               // trade disabled
		RET_TRADE_NO_MONEY=134,              // no enough money for order execution
		RET_TRADE_PRICE_CHANGED=135,         // price changed
		RET_TRADE_OFFQUOTES=136,             // no quotes
		RET_TRADE_BROKER_BUSY=137,           // broker is busy
		RET_TRADE_REQUOTE=138,               // requote
		RET_TRADE_ORDER_LOCKED=139,          // order is proceed by dealer and cannot be changed
		RET_TRADE_LONG_ONLY=140,             // allowed only BUY orders
		RET_TRADE_TOO_MANY_REQ=141,          // too many requests from one client
		//---- order status notification
		RET_TRADE_ACCEPTED=142,              // trade request accepted by server and placed in request queue
		RET_TRADE_PROCESS=143,               // trade request accepted by dealerd
		RET_TRADE_USER_CANCEL=144,           // trade request canceled by client
		//---- additional return codes
		RET_TRADE_MODIFY_DENIED=145,         // trade modification denied
		RET_TRADE_EXPIRATION_DENIED=146,     // using expiration date denied
		RET_TRADE_TOO_MANY_ORDERS=147        // too many orders
};

@interface TradeProgress : NSObject <UIActionSheetDelegate, UIAlertViewDelegate>
{
    UIActionSheet    *_promptView;
	id tradeConn;
	id serverConn;
	id storage;
	id mainwnd;
	NSTimer *timer;
	int reprice_countdown_i;
	double requote_price;
	UIAlertView *alert;
	TradeRecord *trade;
	bool lastRequestSent;
	double lostClosePrice;
	bool isCanceling;
	double close_volume;
}
@property (nonatomic, assign) id serverConn;
@property (nonatomic, assign) id tradeConn;
@property (nonatomic, assign) id storage;
@property (nonatomic, assign) id mainwnd;
@property (nonatomic, retain) TradeRecord *trade;
//+ (TradeProgress *)sharedPromptView;
- (void)showPromptView:(NSString *)promptText;
- (void)dismissPromptView;
- (void)SetNotification:(NSArray*)args;
- (void)SendOrder:(TradeRecord*)_trade;
- (void)SendCloseOrder:(TradeRecord*)_trade AtPrice:(double)price forVolume:(double)vol;
- (void)SendOrderUpdateRequest:(TradeRecord*)_trade;
- (void)SendOrderDeleteRequest:(TradeRecord*)_trade;
@end

