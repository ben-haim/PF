#import "../PFTypes.h"

#import "../Data/PFChartPeriodType.h"
#import "../Data/PFSubscriptionType.h"

#import <Foundation/Foundation.h>

enum
{
   PFLoginModeQuote = 1
   , PFLoginModeTrade = 2
   , PFLoginModeHistory = 4
   , PFLoginModeNews = 8
};

enum
{
   PFSubsribeAction = 0
   , PFUnsubsribeAction = 1
};

enum
{
   PFNewsPriorityAll = 0
   , PFNewsPriorityLow = 1
   , PFNewsPriorityMiddle = 5
   , PFNewsPriorityHigh = 10
};

@class PFMessage;

@protocol PFSearchCriteria;
@protocol PFOrder;
@protocol PFPosition;
@protocol PFMarketOperation;
@protocol PFSymbol;
@protocol PFChatMessage;
@protocol PFDemoAccount;

@protocol PFMessageBuilder <NSObject>

-(PFMessage*)messageForClusterCheck;

-(PFMessage*)messageForHello;

-(PFMessage*)messageForLogonWithLogin:( NSString* )login_
                             password:( NSString* )password_
                 verificationPassword:( NSString* )verification_password_
                                 mode:( PFInteger )mode_
                       encryptionMode:( PFLong )encryption_mode_
                        encryptionKey:( NSString* ) encryption_key_
                            ipAddress:( NSString* )ip_address_;

-(PFMessage*)messageForDemoAccount:( id< PFDemoAccount > )demo_account_;
-(PFMessage*)messageForBrandingWithKey:( NSString* )branding_key_;

-(PFMessage*)messageForNewPassword:( NSString* )new_password_
                       oldPassword:( NSString* )old_password_
              verificationPassword:( NSString* )verification_password_
                            userId:( int )user_id_;

//!method for remove
//-(PFMessage*)messageForSubscribe:( PFByte )subscribe_
//                   instrumentIds:( NSArray* )instruments_;

-(PFMessage*)messageForSubscribe:( PFByte )subscribe_
                            type:( PFSubscriptionType )subscription_type_
                         symbols:( NSArray* )symbols_;

-(PFMessage*)messageForReportTableWithCriteria:( id< PFSearchCriteria > )criteria_;

-(PFMessage*)messageForPing;

-(PFMessage*)messageForLogout;

-(PFMessage*)messageForMarketOrder:( id< PFOrder > )order_;
-(PFMessage*)messageForCancelOrder:( id< PFOrder > )order_;
-(PFMessage*)messageForReplaceOrder:( id< PFOrder > )order_;

-(PFMessage*)messageForClosePosition:( id< PFPosition > )position_;

-(PFMessage*)messageForUpdateMarketOperation:( id< PFMarketOperation > )market_operation_
                               stopLossPrice:( PFDouble )stop_loss_price_
                              stopLossOffset:( PFDouble )stop_loss_offset_;

-(PFMessage*)messageForUpdateMarketOperation:( id< PFMarketOperation > )market_operation_
                             takeProfitPrice:( PFDouble )stop_loss_price_;

-(PFMessage*)messageForStoriesFromDate:( NSDate* )from_date_
                                toDate:( NSDate* )to_date_
                              priority:( PFInteger )priority_;

-(PFMessage*)messageForHistoryFilesWithSymbol:( id< PFSymbol > )symbol_
                                    accountId:( PFInteger )account_id_
                                       period:( PFChartPeriodType )period_
                                     fromDate:( NSDate* )from_date_
                                       toDate:( NSDate* )to_date_;

-(PFMessage*)messageForChatMessage:( id< PFChatMessage > )chat_message_;

-(PFMessage*)messageAccountOperation:( PFByte )operation_code_
                           accountId:( PFInteger )account_id_
                           counterId:( PFInteger )counter_id_
                              amount:( PFDouble )amount_
                             comment:( NSString* )comment_;

@end

@interface PFMessageBuilder : NSObject< PFMessageBuilder >

@end
