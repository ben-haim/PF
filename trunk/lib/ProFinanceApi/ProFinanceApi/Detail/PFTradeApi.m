#import "PFTradeApi.h"

#import "PFApiDelegate.h"

#import "PFMessageBuilder.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFChatMessage.h"
#import "PFSpreadPlan.h"
#import "PFRejectMessage.h"
#import "PFOrder.h"

#import "PFPrimaryServerDetails+XMLParser.h"

#import "PFInstrumentGroup+PFMessage.h"
#import "PFStory+PFMessage.h"
#import "PFReportTable+PFMessage.h"

@interface PFTradeApi ()

@property ( nonatomic, strong ) NSMutableDictionary* replaceOrderHandlers;

@end

@implementation PFTradeApi

@synthesize replaceOrderHandlers = _replaceOrderHandlers;

-(NSMutableDictionary*)replaceOrderHandlers
{
   if ( !_replaceOrderHandlers )
   {
      _replaceOrderHandlers = [ NSMutableDictionary dictionary ];
   }
   
   return _replaceOrderHandlers;
}

-(void)disconnect
{
   self.replaceOrderHandlers = nil;
   
   [ super disconnect ];
}

-(PFInteger)logonMode
{
   return PFLoginModeTrade;
}

-(void)processMessage:( PFMessage* )message_
{
   PFShort message_type_ = [ [ message_ fieldWithId: PFFieldMessageType ] shortValue ];
   //NSLog( @"Trade Message: %@", message_ );

   if ( message_type_ == PFMessageAccountStatus )
   {
      [ self.delegate api: self didLoadAccountMessage: message_ ];
   }
   else if ( message_type_ == PFMessageOpenPosition )
   {
      [ self.delegate api: self didLoadPositionMessage: message_ ];
   }
   else if ( message_type_ == PFMessageInstrumentGroup )
   {
      PFInstrumentGroup* group_ = [ PFInstrumentGroup groupWithMessage: message_ ];
      [ self.delegate api: self didLoadInstrumentGroup: group_ ];
   }
   else if ( message_type_ == PFMEssageUserGroup )
   {
   }
   else if ( message_type_ == PFMessagePammAccountStatus )
   {
      [ self.delegate api: self didLoadPammAccountStatusMessage: message_ ];
   }
   else if ( message_type_ == PFMessageRefuseOrderAction )
   {
      NSString* text_ = [ [ message_ fieldWithId: PFFieldComment ] stringValue ];
      [ self.delegate api: self didReceiveErrorMessage: text_ ];
   }
   else if ( message_type_ == PFMessageOpenOrder )
   {
      if ( [ (PFIntegerField*)[ message_ fieldWithId: PFFieldOrderStatus ] integerValue ] == PFOrderStatusReplaced )
      {
         PFInteger order_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldOrderId ] integerValue ];
         PFReplaceOrderDoneBlock done_block_ = [ self.replaceOrderHandlers objectForKey: @(order_id_) ];
         
         if ( done_block_ )
         {
            done_block_();
            [ self.replaceOrderHandlers removeObjectForKey: @(order_id_) ];
         }
      }
      
      if ( [ (PFIntegerField*)[ message_ fieldWithId: PFFieldOrderStatus ] integerValue ] == PFOrderStatusRefused )
      {
         [ self.delegate api: self didReceiveErrorMessage: [ [ message_ fieldWithId: PFFieldComment ] stringValue ] ];
      }
      
      [ self.delegate api: self didLoadOrderMessage: message_ ];
   }
   else if ( message_type_ == PFMessageNews )
   {
      NSArray* stories_ = [ PFStory storiesWithMessage: message_ ];
      [ self.delegate api: self didLoadStories: stories_ ];
   }
   else if ( message_type_ == PFMessageClosePosition )
   {
      PFInteger position_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldOpenOrderId ] integerValue ];
      [ self.delegate api: self didClosePositionWithId: position_id_ ];
   }
   else if ( message_type_ == PFMessageTrade )
   {
      [ self.delegate api: self didLoadTradeMessage: message_ ];
   }
   else if ( message_type_ == PFMessageXml )
   {
      NSError* error_ = nil;
      PFReportTable* table_ = [ PFReportTable tableWithReportXmlMessage: message_ error: &error_ ];
      if ( !error_ )
      {
         [ self.delegate api: self didLoadReport: table_ ];
      }
   }
   else if ( message_type_ == PFMessageChat )
   {
      PFChatMessage* chat_message_ = [ PFChatMessage objectWithFieldOwner: message_ ];
      
      if ( chat_message_.type != PFChatMessageConfirmation )
      {
         PFChatMessage* confirmation_message_ = [ chat_message_ messageForReceiveConfirmation ];
         [ self sendMessage: [ self.messageBuilder messageForChatMessage: confirmation_message_ ]
                  doneBlock: nil ];

         [ self.delegate api: self didLoadChatMessage: chat_message_ ];
      }
   }
   else if ( message_type_ == PFMessageCommisionPlan )
   {
      [ self.delegate api: self didLoadSpreadPlan: [ PFSpreadPlan objectWithFieldOwner: message_ ] ];
   }
   else if ( message_type_ == PFMessageChangePassword )
   {
      PFInteger change_password_status_ = [ [ message_ fieldWithId: PFFieldChangePasswordStatus ] byteValue ];
      [ self. delegate api: self didLoadChangePasswordStatus: change_password_status_ andReason: nil ];
   }
   else
   {
      //NSLog( @"Undefined trade message with type: %d", message_type_ );
   }
}

-(void)reportTableForAccountWithId:( PFInteger )account_id_
                          criteria:( id< PFSearchCriteria > )criteria_
                         doneBlock:( PFReportDoneBlock )done_block_
{
   PFMessage* message_ = [ self.messageBuilder messageForReportTableWithCriteria: criteria_ ];

   [ self sendMessage: message_ doneBlock: ^( PFMessage* message_ )
    {
       NSError* error_ = nil;
       PFReportTable* table_ = [ PFReportTable tableWithReportMessage: message_ error: &error_ ];
       if ( done_block_ )
       {
          done_block_( table_, error_ );
       }
    }];
}

-(void)createOrder:( id< PFOrder > )order_
{
   [ self sendMessage: [ self.messageBuilder messageForMarketOrder: order_ ]
            doneBlock: nil ];
}

-(void)cancelOrder:( id< PFOrder > )order_
{
   [ self sendMessage: [ self.messageBuilder messageForCancelOrder: order_ ]
            doneBlock: nil ];
}

-(void)replaceOrder:( id< PFOrder > )order_
      withDoneBlock:( PFReplaceOrderDoneBlock )done_block_
{
   if ( done_block_ )
   {
      [ self.replaceOrderHandlers setObject: done_block_ forKey: @(order_.orderId) ];
   }
   
   [ self sendMessage: [ self.messageBuilder messageForReplaceOrder: order_ ]
            doneBlock: nil ];
}

-(void)closePosition:( id< PFPosition > )position_
{
   [ self sendMessage: [ self.messageBuilder messageForClosePosition: position_ ]
            doneBlock: nil ];
}

-(void)withdrawalForAccountId:( PFInteger )account_id_
                    andAmount:( PFDouble )amount_
{
   static PFByte withdrawal_operation_code_ = 3;
   
   [ self sendMessage: [ self.messageBuilder messageAccountOperation: withdrawal_operation_code_
                                                           accountId: account_id_
                                                           counterId: -1
                                                              amount: amount_
                                                             comment: @"" ]
            doneBlock: nil ];
}

-(void)transferFromAccountId:( PFInteger )from_account_id_
                 toAccountId:( PFInteger )to_account_id_
                      amount:( PFDouble )amount_
{
   static PFByte transfer_operation_code_ = 17;
   
   [ self sendMessage: [ self.messageBuilder messageAccountOperation: transfer_operation_code_
                                                           accountId: from_account_id_
                                                           counterId: to_account_id_
                                                              amount: amount_
                                                             comment: @"" ]
            doneBlock: nil ];
}

-(void)storiesForAccountWithId:( PFInteger )account_id_
                      fromDate:( NSDate* )from_date_
                        toDate:( NSDate* )to_date_
{
   [ self sendMessage: [ self.messageBuilder messageForStoriesFromDate: from_date_
                                                                toDate: to_date_
                                                              priority: PFNewsPriorityAll ]
            doneBlock: nil ];
}

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
               stopLossPrice:( PFDouble )stop_loss_price_
              stopLossOffset:( PFDouble )stop_loss_offset_
{
   [ self sendMessage: [ self.messageBuilder messageForUpdateMarketOperation: market_operation_
                                                               stopLossPrice: stop_loss_price_
                                                              stopLossOffset: stop_loss_offset_ ]
            doneBlock: nil ];
}

-(void)updateMarketOperation:( id< PFMarketOperation > )market_operation_
             takeProfitPrice:( PFDouble )take_profit_price_
{
   [ self sendMessage: [ self.messageBuilder messageForUpdateMarketOperation: market_operation_
                                                             takeProfitPrice: take_profit_price_ ]
            doneBlock: nil ];
}

-(void)sendChatMessage:( id< PFChatMessage > )message_
      forAccountWithId:( PFInteger )account_id_
{
   [ self sendMessage: [ self.messageBuilder messageForChatMessage: message_ ]
            doneBlock: nil ];
}

-(void)serverDetailsWithDoneBlock:( PFPrimaryServerDetailsDoneBlock )done_block_
{
   [ self sendMessage: [ self.messageBuilder messageForClusterCheck ]
            doneBlock: ^( PFMessage* message_ )
    {
       PFGroupField* group_ = [ message_ groupFieldWithId: PFGroupLine ];

       NSString* xml_ = [ [ group_ fieldWithId: PFFieldText ] stringValue ];
       NSError* error_ = nil;
       PFPrimaryServerDetails* details_ = [ PFPrimaryServerDetails detailsWithXMLString: xml_
                                                                                  error: &error_ ];

       done_block_( details_, error_ );
    }];
}

@end
