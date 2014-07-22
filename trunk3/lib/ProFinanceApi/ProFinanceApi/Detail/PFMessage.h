#import "../PFTypes.h"

#import "PFFieldOwner.h"

#import <Foundation/Foundation.h>

enum
{
   PFMessageLevel1Quote = 1
   , PFMessageInstrument = 2
   , PFMessageXml = 3
   , PFMessageAccountStatus = 14
   , PFMessageOpenPosition = 17
   , PFMessageClosePosition = 18
   , PFMessageOpenOrder = 27
   , PFMessageInstrumentGroup = 31
   , PFMEssageUserGroup = 41
   , PFMessageLogon = 42
   , PFMessageRefuseOrderAction = 43
   , PFMessageCancelOrder = 46
   , PFMessageReplaceOrder = 47
   , PFMessageBusinessReject = 49
   , PFMessageTrade = 50
   , PFMessageChat = 51
   , PFMessageNews = 52
   , PFMessageNewsRequest = 53
   , PFMessageLogout = 56
   , PFMessagePing = 57
   , PFMessageChangePassword = 64
   , PFMessageProperty = 68
   , PFMessageReportRequest = 69
   , PFMessageSubscribe = 71
   , PFMessageNewOrder = 73
   , PFMessagePammAccountStatus = 74
   , PFMessageHello = 75
   , PFMessageAccountOperation = 76
   , PFMessageTradeSession = 85
   , PFMessageOvernightMarginNotification = 86
   , PFMessageCrossRatesMessage = 87
   , PFMessageLevel2Quote = 102
   , PFMessageLevel3Quote = 103
   , PFMessageLevel4Quote = 104
   , PFMessageRoute = 105
   , PFMessageLevel2QuoteAggregated = 111
   , PFMessageSoapMessageRequest = 401
   , PFMessageHistoryFilesRequest = 403
   , PFMessageHistoryFilesResponse = 404
   , PFMessageHistoryFileRequest = 405
   , PFMessageHistoryFileResponse = 406
   , PFMessageCommisionPlan = 409
   , PFMessageCheckMarginRequest = 410
   , PFMessageCheckMarginResp = 411
   , PFMessageRouteMessege = 412
   , PFMessageSpreadPlan = 413
   , PFMessageAssetType = 414
};

@interface PFMessage : PFFieldOwner

@property ( nonatomic, assign, readonly ) PFShort type;

+(id)messageWithType:( PFShort )type_;

-(NSData*)data;

@end


@interface NSArray (PFMessage)

+(id)arrayOfMessagesWithData:( NSData* )data_
                        tail:( NSData** )tail_;

@end
