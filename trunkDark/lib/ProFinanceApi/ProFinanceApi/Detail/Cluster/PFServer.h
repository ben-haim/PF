#import "../../PFTypes.h"

#import "../PFTradeCommander.h"
#import "../PFQuoteCommander.h"

#import <Foundation/Foundation.h>

@protocol PFServerDelegate;

@class PFApi;
@class PFTradeApi;
@class PFServerInfo;

@interface PFServer : NSObject< PFTradeCommander, PFQuoteCommander >

@property ( nonatomic, strong ) PFTradeApi* primaryApi;
@property ( nonatomic, strong, readonly ) PFServerInfo* serverInfo;

@property ( nonatomic, strong, readonly ) NSString* login;
@property ( nonatomic, strong, readonly ) NSString* password;
@property ( nonatomic, strong, readonly ) NSString* verificationPassword;

@property ( nonatomic, assign, readonly ) BOOL transferFinished;
@property ( nonatomic, assign, readonly ) BOOL tradesTransferFinished;
@property ( nonatomic, assign, readonly ) BOOL quotesTransferFinished;

@property ( nonatomic, unsafe_unretained ) id< PFServerDelegate > delegate;

+(id)serverWithPrimaryApi:( PFTradeApi* )api_;

-(void)disconnect;
-(void)clean;

-(BOOL)logonNodeApi:( PFApi* )api_
             server:( NSString* )server_
              error:( NSError** )error_;

-(BOOL)logonNodeApi:( PFApi* )api_
         serverInfo:( PFServerInfo* )server_info_
              error:( NSError** )error_;

-(void)logonServerWithLogin:( NSString* )login_
                   password:( NSString* )password_
       verificationPassword:( NSString* )verification_password_
             verificationId:( int )verification_id_
                  ipAddress:( NSString* )ip_address_;

@end

@class PFUser;

@protocol PFConcreteServer <NSObject>

-(id< PFTradeCommander >)commanderForAccountWithId:( PFInteger )account_id_;
-(id< PFQuoteCommander >)commanderForRouteWithId:( PFInteger )route_id_;
-(id< PFCommander >)commanderForVerificationId:( PFInteger )verification_id_;

-(NSArray*)allApis;

-(BOOL)tradesTransferFinished;
-(BOOL)quotesTransferFinished;

-(NSArray*)routersForSymbols:( NSArray* )symbols_;

-(void)api:( PFApi* )api_ didLogonUser:( PFUser* )user_;
-(void)didFinishTransferApi:( PFApi* )api_;

@end

@class PFUser;
@class PFMessage;
@class PFInstrument;
@class PFInstrumentGroup;
@class PFRejectMessage;
@class PFChatMessage;
@class PFReportTable;
@class PFLevel2Quote;
@class PFLevel2QuotePackage;
@class PFLevel4Quote;
@class PFRule;
@class PFCommissionPlan;
@class PFSpreadPlan;
@class PFAssetType;
@class PFTradeSessionContainer;

@protocol PFServerDelegate <NSObject>

-(void)server:( PFServer* )server_ didFailWithFatalError:( NSError* )error_;

-(void)server:( PFServer* )server_ didLogonUser:( PFUser* )user_;

-(void)server:( PFServer* )server_ needVerificationWithId:( int )verification_id_;

-(void)server:( PFServer* )server_ changePasswordForUser:( int )user_id_;

-(void)server:( PFServer* )server_ didLogoutWithReason:( NSString* )reason_;

-(void)didFinishTradeTransferServer:( PFServer* )server_;
-(void)didFinishQuoteTransferServer:( PFServer* )server_;

-(void)didFinishTransferServer:( PFServer* )server_;

-(void)server:( PFServer* )server_ didLoadQuoteMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadTradeQuoteMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadLevel2Quote:( PFLevel2Quote* )quote_;

-(void)server:( PFServer* )server_ didLoadLevel2QuotePackage:( PFLevel2QuotePackage* )package_;

-(void)server:( PFServer* )server_ didLoadLevel4Quote:( PFLevel4Quote* )quote_;

-(void)server:( PFServer* )server_ didLoadInstrument:( PFInstrument* )instrument_;

-(void)server:( PFServer* )server_ didLoadInstrumentGroup:( PFInstrumentGroup* )group_;

-(void)server:( PFServer* )server_ didLoadPositionMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didClosePositionWithId:( PFInteger )position_id_;

-(void)server:( PFServer* )server_ didLoadOrderMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadTradeMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadRouteMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadAccountMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadPammAccountStatusMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didLoadStories:( NSArray* )stories_;

-(void)server:( PFServer* )server_ didReceiveErrorMessage:( NSString* )error_message_;

-(void)server:( PFServer* )server_ didReceiveRejectMessage:( PFRejectMessage* )reject_message_;

-(void)server:( PFServer* )server_ didLoadReport:( PFReportTable* )report_;

-(void)server:( PFServer* )server_ didLoadChatMessage:( PFChatMessage* )message_;

-(void)server:( PFServer* )server_ didLoadChangePasswordStatus:( int )change_password_status_ andReason:( NSString* )reason_;

-(void)server:( PFServer* )server_ didLoadRule:( PFRule* )rule_;

-(void)server:( PFServer* )server_ didAllowReportWithName:( NSString* )report_name_;

-(void)server:( PFServer* )server_ didLoadCommissionPlan:( PFCommissionPlan* )commission_plan_;

-(void)server:( PFServer* )server_ didLoadSpreadPlan:( PFSpreadPlan* )spread_plan_;

-(void)server:( PFServer* )server_ didLoadAssetType:( PFAssetType* )asset_type_;

-(void)server:( PFServer* )server_ didLoadTradeSessionContainer:( PFTradeSessionContainer* )trade_session_container_;

-(void)server:( PFServer* )server_ didLoadCrossRatesMessage:( PFMessage* )message_;

-(void)server:( PFServer* )server_ didProcessMessage:( NSString* )message_;

-(void)server:( PFServer* )server_ overnightNotificationForAccountId:( PFInteger )account_id_ maintanceMargin:( PFDouble )maintance_margin_ availableMargin:( PFDouble )available_margin_ date:( NSDate* )date_;

@end
