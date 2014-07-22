#import "PFMessage+PFOrder.h"

#import "PFField.h"

#import "PFOrder.h"

static NSUInteger PFCurrentOrderIndex = 0;

@implementation PFMessage (PFOrder)

+(id)messageWithCancelOrder:( id< PFOrder > )order_
{
   PFMessage* message_ = [ self messageWithType: PFMessageCancelOrder ];

   [ PFOrder writeToFieldOwner: message_
                        object: order_
                        fields: @[@(PFFieldOrderId)
                                 , @(PFFieldInstrumentId)
                                 , @(PFFieldAccountId)] ];

   return message_;
}

+(id)messageWithCreateOrder:( id< PFOrder > )order_
{
   PFMessage* message_ = [ self messageWithType: PFMessageNewOrder ];
   
   if ( order_.orderType == PFOrderOCO )
   {
      id< PFMutableOrder > limit_order_ = [ order_ mutableOrder ];
      limit_order_.clientOrderId = (PFInteger)++PFCurrentOrderIndex;
      limit_order_.orderType = PFOrderLimit;
      limit_order_.stopPrice = 0.0;

      id< PFMutableOrder > stop_order_ = [ order_ mutableOrder ];
      stop_order_.clientOrderId = (PFInteger)++PFCurrentOrderIndex;
      stop_order_.orderType = PFOrderStop;
      stop_order_.price = stop_order_.stopPrice;
      stop_order_.stopPrice = 0.0;
      
      if ( limit_order_.stopLossPrice > 0.0 )
      {
         double sl_offset_ = fabsf( limit_order_.price - limit_order_.stopLossPrice );
         stop_order_.stopLossPrice = stop_order_.operationType == PFMarketOperationBuy ? stop_order_.price - sl_offset_ : stop_order_.price + sl_offset_;
      }
      
      if ( limit_order_.takeProfitPrice > 0.0 )
      {
         double tp_offset_ = fabsf( limit_order_.price - limit_order_.takeProfitPrice );
         stop_order_.takeProfitPrice = stop_order_.operationType == PFMarketOperationBuy ? stop_order_.price + tp_offset_ : stop_order_.price - tp_offset_;
      }

      PFGroupField* limit_order_group_ = [ message_ writeGroupFieldWithId: PFGroupOrder ];
      [ [ limit_order_group_ writeFieldWithId: PFFieldClientOrderIdToLink ] setIntegerValue: stop_order_.clientOrderId ];
      [ [ limit_order_group_ writeFieldWithId: PFFieldOrderLinkType ] setIntegerValue: PFOrderLinkCancel ];
      
      PFGroupField* stop_order_group_ = [ message_ writeGroupFieldWithId: PFGroupOrder ];
      [ [ stop_order_group_ writeFieldWithId: PFFieldClientOrderIdToLink ] setIntegerValue: limit_order_.clientOrderId ];
      [ [ stop_order_group_ writeFieldWithId: PFFieldOrderLinkType ] setIntegerValue: PFOrderLinkCancel ];
      
      [ PFOrder writeToFieldOwner: limit_order_group_.fieldOwner object: limit_order_ ];
      [ PFOrder writeToFieldOwner: stop_order_group_.fieldOwner object: stop_order_ ];
   }
   else
   {
      id< PFMutableOrder > mutable_order_ = [ order_ mutableOrder ];
      mutable_order_.clientOrderId = (PFInteger)++PFCurrentOrderIndex;
      
      PFGroupField* order_group_ = [ message_ writeGroupFieldWithId: PFGroupOrder ];
      [ PFOrder writeToFieldOwner: order_group_.fieldOwner object: mutable_order_ ];
   }
   
   return message_;
}

+(id)messageWithReplaceOrder:( id< PFOrder > )order_
{
   PFMessage* message_ = [ self messageWithType: PFMessageReplaceOrder ];
   [ PFOrder writeToFieldOwner: message_ object: order_ ];
   return message_;
}

@end