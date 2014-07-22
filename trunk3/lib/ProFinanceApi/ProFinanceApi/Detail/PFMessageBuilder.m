#import "PFMessageBuilder.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFSymbol.h"
#import "PFSymbolId.h"

#import "PFOrder.h"
#import "PFPosition.h"
#import "PFChatMessage.h"
#import "PFSearchCriteria.h"

#import "PFMessage+PFOrder.h"
#import "NSDictionary+PFDemoAccount.h"
#import "NSDateFormatter+PFMessage.h"

#import "PFPasswordEncryptor.h"

static NSString* compileDateString()
{
   static NSString* compile_date_string_ = nil;
   
   if ( !compile_date_string_ )
   {
      NSDateFormatter* date_formatter_ = [ NSDateFormatter compileDateFormatter ];
      [ date_formatter_ setDateFormat: @"MMM d yyyy" ];
      compile_date_string_ = [ [ NSDateFormatter compileDateFormatter ] stringFromDate: [ date_formatter_ dateFromString: [ NSString stringWithUTF8String: __DATE__ ] ] ];
   }
   
   return compile_date_string_;
}

@implementation PFMessageBuilder

-(PFMessage*)messageForSoapRequest:( NSString* )request_name_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageSoapMessageRequest ];
   
   [ [ message_ writeFieldWithId: PFFieldName ] setStringValue: @"ProTrader.jws" ];
   
   PFGroupField* method_group_ = [ message_ writeGroupFieldWithId: PFGroupKeyValueBean ];
   [ [ method_group_ writeFieldWithId: PFFieldKey ] setStringValue: @"method" ];
   [ [ method_group_ writeFieldWithId: PFFieldValue ] setStringValue: request_name_ ];
   
   return message_;
}

-(PFMessage*)messageForClusterCheck
{
   return [ self messageForSoapRequest: @"isCluster" ];
}

-(PFMessage*)messageForLogonWithLogin:( NSString* )login_
                             password:( NSString* )password_
                 verificationPassword:( NSString* )verification_password_
                                 mode:( PFInteger )mode_
                       encryptionMode:( PFLong )encryption_mode_
                        encryptionKey:( NSString* ) encryption_key_
                            ipAddress:( NSString* )ip_address_
{
   static const NSInteger PFMobileClientType = 6;

   PFMessage* message_ = [ PFMessage messageWithType: PFMessageLogon ];

   [ [ message_ writeFieldWithId: PFFieldSequenceId ] setLongValue: 153 ];
   [ [ message_ writeFieldWithId: PFFieldId ] setLongValue: encryption_mode_ ];
   [ [ message_ writeFieldWithId: PFFieldLogin ] setStringValue: login_ ];
   [ [ message_ writeFieldWithId: PFFieldPassword ] setStringValue: [ PFPasswordEncryptor encryptPassword: password_
                                                                                                 whithKey: encryption_key_
                                                                                                  andMode: encryption_mode_ ] ];
   [ [ message_ writeFieldWithId: PFFieldConnectionMode ] setIntegerValue: mode_ ];
   [ [ message_ writeFieldWithId: PFFieldClientType ] setIntegerValue: PFMobileClientType ];
   
   if ( verification_password_ )
   {
      [ [ message_ writeFieldWithId: PFFieldVerificationPassword ] setStringValue: verification_password_ ];
   }
   
   [ [ message_ writeFieldWithId: PFFieldProtocolId ] setStringValue: @"1.6" ];
   [ [ message_ writeFieldWithId: PFFieldMaxFieldIndex ] setIntegerValue: PFFieldNotSupportedIndex - 1 ];
   [ [ message_ writeFieldWithId: PFFieldDateOfBuild ] setStringValue: compileDateString() ];
   
   if ( [ ip_address_ length ] > 0 )
   {
      [ [ message_ writeFieldWithId: PFFieldSource ] setStringValue: ip_address_ ];
   }

   return message_;
}

-(PFMessage*)messageForHello
{
   static NSString* hello_string_ = @"hello";
   
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageHello ];
   [ [ message_ writeFieldWithId: PFFieldPassword ] setStringValue: hello_string_ ];
   
   return message_;
}

-(PFMessage*)messageForDemoAccount:( id< PFDemoAccount > )demo_account_
{
   PFMessage* message_ = [ self messageForSoapRequest: @"registerDemo" ];
   NSDictionary* dictionary_ = [ NSDictionary dictionaryWithDemoAccount: demo_account_ ];

   for ( NSString* key_ in dictionary_ )
   {
      PFGroupField* group_ = [ message_ writeGroupFieldWithId: PFGroupKeyValueBean ];
      [ [ group_ writeFieldWithId: PFFieldKey ] setStringValue: key_ ];
      [ [ group_ writeFieldWithId: PFFieldValue ] setStringValue: [ dictionary_ objectForKey: key_ ] ];
   }

   return message_;
}

-(PFMessage*)messageForBrandingWithKey:( NSString* )branding_key_
{
   PFMessage* message_ = [ self messageForSoapRequest: @"getBrandingRules" ];

   PFGroupField* group_ = [ message_ writeGroupFieldWithId: PFGroupKeyValueBean ];
   [ [ group_ writeFieldWithId: PFFieldKey ] setStringValue: @"key" ];
   [ [ group_ writeFieldWithId: PFFieldValue ] setStringValue: branding_key_ ];
   
   return message_;
}

-(PFMessage*)messageForNewPassword:( NSString* )new_password_
                       oldPassword:( NSString* )old_password_
              verificationPassword:( NSString* )verification_password_
                            userId:( int )user_id_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageChangePassword ];
   
   [ [ message_ writeFieldWithId: PFFieldUserId ] setIntegerValue: user_id_ ];
   
   [ [ message_ writeFieldWithId: PFFieldPassword ] setStringValue: old_password_ ];
   [ [ message_ writeFieldWithId: PFFieldNewPassword ] setStringValue: new_password_ ];
   
   if ( verification_password_ )
      [ [ message_ writeFieldWithId: PFFieldVerificationPassword ] setStringValue: verification_password_ ];
   
   return message_;
}

-(PFMessage*)messageForSubscribe:( PFByte )subscribe_
                            type:( PFSubscriptionType )subscription_type_
                         symbols:( NSArray* )symbols_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageSubscribe ];
   
   [ [ message_ writeFieldWithId: PFFieldSubscriptionAction ] setByteValue: subscribe_ ];
   
   for ( id< PFSymbolId > symbol_id_ in symbols_ )
   {
      PFGroupField* subscribe_group_ = [ message_ writeGroupFieldWithId: PFGroupFieldSubscribe ];
      
      [ PFSymbolId writeToFieldOwner: subscribe_group_.fieldOwner object: symbol_id_ ];
      [ [ subscribe_group_ writeFieldWithId: PFFieldSubscriptionType ] setIntegerValue: subscription_type_ ];
      [ [ subscribe_group_ writeFieldWithId: PFFieldLightSubs ] setBoolValue: NO ];
      
   }
   
   return message_;
}

-(PFMessage*)messageForReportTableWithCriteria:( id< PFSearchCriteria > )criteria_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageReportRequest ];

   [ [ message_ writeFieldWithId: PFFieldTemplate ] setStringValue: criteria_.reportName ];

   NSDictionary* keys_and_values_ = criteria_.keysAndValues;

   for ( NSString* key_ in keys_and_values_ )
   {
      PFGroupField* criteria_group_ = [ message_ writeGroupFieldWithId: PFGroupKeyValueBean ];

      NSString* value_ = [ keys_and_values_ objectForKey: key_ ];

      [ [ criteria_group_ writeFieldWithId: PFFieldKey ] setStringValue: key_ ];
      [ [ criteria_group_ writeFieldWithId: PFFieldValue ] setStringValue: value_ ];
   }

   return message_;
}

-(PFMessage*)messageForPing
{
   return [ PFMessage messageWithType: PFMessagePing ];
}

-(PFMessage*)messageForLogout
{
   static NSString* const logout_reason_ = @"logout";

   PFMessage* logout_message_ = [ PFMessage messageWithType: PFMessageLogout ];

   [ [ logout_message_ writeFieldWithId: PFFieldText ] setStringValue: logout_reason_ ];

   return logout_message_;
}

-(PFMessage*)messageForMarketOrder:( id< PFOrder > )order_
{
   return [ PFMessage messageWithCreateOrder: order_ ];
}

-(PFMessage*)messageForCancelOrder:( id< PFOrder > )order_
{
   return [ PFMessage messageWithCancelOrder: order_ ];
}

-(PFMessage*)messageForReplaceOrder:( id< PFOrder > )order_
{
   return [ PFMessage messageWithReplaceOrder: order_ ];
}

-(PFMessage*)messageForOrder:( id< PFOrder > )order_
      boundToOperationWithId:( PFInteger )operation_id_
            operationGroupId:( PFInteger )group_id_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageNewOrder ];
   
   PFGroupField* order_group_ = [ message_ writeGroupFieldWithId: PFGroupOrder ];

   [ PFOrder writeToFieldOwner: order_group_.fieldOwner object: order_ ];

   PFGroupField* bound_group_ = [ order_group_ writeGroupFieldWithId: group_id_ ];
   [ [ bound_group_ writeFieldWithId: PFFieldOrderId ] setIntegerValue: operation_id_ ];

   return message_;
}

-(PFMessage*)messageForClosePosition:( id< PFPosition > )position_
{
   return [ self messageForOrder: [ PFOrder closeOrderWithPosition: position_ ]
          boundToOperationWithId: position_.positionId
                operationGroupId: PFGroupOrderId ];
}

-(PFMessage*)messageForUpdateMarketOperation:( id< PFMarketOperation > )market_operation_
                               stopLossPrice:( PFDouble )stop_loss_price_
                              stopLossOffset:( PFDouble )stop_loss_offset_
{
   return [ self messageForOrder: [ PFOrder stopOrderForMarketOperation: market_operation_ price: stop_loss_price_ stopLossOffset: stop_loss_offset_ ]
          boundToOperationWithId: market_operation_.operationId
                operationGroupId: PFGroupOrderId ];
}

-(PFMessage*)messageForUpdateMarketOperation:( id< PFMarketOperation > )market_operation_
                             takeProfitPrice:( PFDouble )take_profit_price_
{
   return [ self messageForOrder: [ PFOrder limitOrderMarketOperation: market_operation_ price: take_profit_price_ ]
          boundToOperationWithId: market_operation_.operationId
                operationGroupId: PFGroupOrderId ];
}

-(PFMessage*)messageForStoriesFromDate:( NSDate* )from_date_
                                toDate:( NSDate* )to_date_
                              priority:( PFInteger )priority_
{
   static int news_limit_ = 80;
   
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageNewsRequest ];

   [ [ message_ writeFieldWithId: PFFieldPriority ] setIntegerValue: priority_ ];
   [ [ message_ writeFieldWithId: PFFieldIsUpperCaseSearch ] setBoolValue: YES ];
   [ [ message_ writeFieldWithId: PFFieldIsContentSearch ] setBoolValue: NO ];
   [ [ message_ writeFieldWithId: PFFieldIsEventSearch ] setBoolValue: NO ];

   [ [ message_ writeFieldWithId: PFFieldSymbol ] setStringValue: nil ];
   [ [ message_ writeFieldWithId: PFFieldSource ] setStringValue: nil ];
   [ [ message_ writeFieldWithId: PFFieldNewsCategory ] setStringValue: nil ];
   [ [ message_ writeFieldWithId: PFFieldTheme ] setStringValue: nil ];

   [ [ message_ writeFieldWithId: PFFieldStartTime ] setDateValue: from_date_ ];
   [ [ message_ writeFieldWithId: PFFieldEndDayDate ] setDateValue: to_date_ ];
   
   [ [ message_ writeFieldWithId: PFFieldNumber ] setIntegerValue: news_limit_ ];

   return message_;
}

-(PFMessage*)messageForHistoryFilesWithSymbol:( id< PFSymbol > )symbol_
                                    accountId:( PFInteger )account_id_
                                       period:( PFChartPeriodType )period_
                                     fromDate:( NSDate* )from_date_
                                       toDate:( NSDate* )to_date_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageHistoryFilesRequest ];

   [ [ message_ writeFieldWithId: PFFieldStartTime ] setDateValue: from_date_ ];
   [ [ message_ writeFieldWithId: PFFieldEndTime ] setDateValue: to_date_ ];

   [ PFSymbolId writeToFieldOwner: message_ object: [ PFSymbolIdKey quotesKeyWithSymbol: symbol_ ] ];

   [ [ message_ writeFieldWithId: PFFieldAccountId ] setIntegerValue: account_id_ ];
   [ [ message_ writeFieldWithId: PFFieldBarsType ] setByteValue: symbol_.barType ];
   [ [ message_ writeFieldWithId: PFFieldHistoryPeriodType ] setShortValue: period_ ];

   return message_;
}

-(PFMessage*)messageForChatMessage:( id< PFChatMessage > )chat_message_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageChat ];

   [ PFChatMessage writeToFieldOwner: message_ object: chat_message_ ];

   return message_;
}

-(PFMessage*)messageAccountOperation:( PFByte )operation_code_
                           accountId:( PFInteger )account_id_
                           counterId:( PFInteger )counter_id_
                              amount:( PFDouble )amount_
                             comment:( NSString* )comment_
{
   PFMessage* message_ = [ PFMessage messageWithType: PFMessageAccountOperation ];
   
   [ [ message_ writeFieldWithId: PFFieldOperationType ] setByteValue: operation_code_ ];
   [ [ message_ writeFieldWithId: PFFieldAccountId ] setIntegerValue: account_id_ ];
   [ [ message_ writeFieldWithId: PFFieldCounterId ] setIntegerValue: counter_id_ ];
   [ [ message_ writeFieldWithId: PFFieldAmount ] setDoubleValue: amount_ ];
   [ [ message_ writeFieldWithId: PFFieldComment ] setStringValue: comment_ ];
   
   return message_;
}

@end
