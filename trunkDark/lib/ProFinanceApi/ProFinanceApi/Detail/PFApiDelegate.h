#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@class PFUser;
@class PFInstrument;
@class PFInstrumentGroup;
@class PFMessage;
@class PFRejectMessage;
@class PFReportTable;
@class PFChatMessage;
@class PFLevel2Quote;
@class PFLevel2QuotePackage;
@class PFLevel4Quote;
@class PFRule;
@class PFCommissionPlan;
@class PFSpreadPlan;
@class PFAssetType;
@class PFTradeSessionContainer;

@class PFApi;

@protocol PFApiDelegate <NSObject>

-(void)api:( PFApi* )api_ didFailConnectWithError:( NSError* )error_;
-(void)api:( PFApi* )api_ didFailParseWithError:( NSError* )error_;

-(void)didConnectApi:( PFApi* )api_;

@optional

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_;

-(void)api:( PFApi* )api_ needVerificationWithId:( int )verification_id_;

-(void)api:( PFApi* )api_ changePasswordForUser:( int )user_id_;

-(void)api:( PFApi* )api_ didLogoutWithReason:( NSString* )reason_;

-(void)didFinishTransferApi:( PFApi* )api_;

-(void)api:( PFApi* )api_ didLoadQuoteMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadTradeQuoteMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadLevel2Quote:( PFLevel2Quote* )quote_;

-(void)api:( PFApi* )api_ didLoadLevel2QuotePackage:( PFLevel2QuotePackage* )package_;

-(void)api:( PFApi* )api_ didLoadLevel4Quote:( PFLevel4Quote* )quote_;

-(void)api:( PFApi* )api_ didLoadInstrument:( PFInstrument* )instrument_;

-(void)api:( PFApi* )api_ didLoadInstrumentGroup:( PFInstrumentGroup* )group_;

-(void)api:( PFApi* )api_ didLoadPositionMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didClosePositionWithId:( PFInteger )position_id_;

-(void)api:( PFApi* )api_ didLoadOrderMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadTradeMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadRouteMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadAccountMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadPammAccountStatusMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didLoadStories:( NSArray* )stories_;

-(void)api:( PFApi* )api_ didReceiveErrorMessage:( NSString* )error_message_;

-(void)api:( PFApi* )api_ didReceiveRejectMessage:( PFRejectMessage* )reject_message_;

-(void)api:( PFApi* )api_ didLoadReport:( PFReportTable* )report_;

-(void)api:( PFApi* )api_ didLoadChatMessage:( PFChatMessage* )message_;

-(void)api:( PFApi* )api_ didLoadChangePasswordStatus:( int )change_password_status_ andReason:( NSString* )reason_;

-(void)api:( PFApi* )api_ didLoadRule:( PFRule* )rule_;

-(void)api:( PFApi* )api_ didAllowReportWithName:( NSString* )report_name_;

-(void)api:( PFApi* )api_ didLoadCommissionPlan:( PFCommissionPlan* )commission_plan_;

-(void)api:( PFApi* )api_ didLoadSpreadPlan:( PFSpreadPlan* )spread_plan_;

-(void)api:( PFApi* )api_ didLoadAssetType:( PFAssetType* )asset_type_;

-(void)api:( PFApi* )api_ didLoadTradeSessionContainer:( PFTradeSessionContainer* )trade_session_container_;

-(void)api:( PFApi* )api_ didLoadCrossRatesMessage:( PFMessage* )message_;

-(void)api:( PFApi* )api_ didProcessedMessage:( NSString* )message_;

-(void)api:( PFApi* )api_ overnightNotificationForAccountId:( PFInteger )account_id_ maintanceMargin:( PFDouble )maintance_margin_ availableMargin:( PFDouble )available_margin_ date:( NSDate* )date_;

@end
