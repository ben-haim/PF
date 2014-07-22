#import "PFOrder.h"

#import "PFSymbol.h"
#import "PFPosition.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFOrder

@synthesize clientOrderId;
@synthesize boundToOrderId;
@synthesize filledAmount;
@synthesize validity;
@synthesize stopPrice;
@synthesize comment = _comment;
@synthesize expireAtDate;
@synthesize optionType;
@synthesize createdByBroker;
@synthesize status;
@synthesize openOrder;

@dynamic isFilled;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldOrderId name: @"orderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldClientOrderId name: @"clientOrderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldBoundToOrderId name: @"boundToOrderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldFilledAmount name: @"filledAmount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldValidity name: @"validity" ]
            , [ PFMetaObjectField fieldWithId: PFFieldStopPrice name: @"stopPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldComment name: @"comment" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOptionType name: @"optionType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsByBroker name: @"createdByBroker" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOrderStatus name: @"status" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCreatedAt name: @"createdAt" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsOpen name: @"openOrder" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExpireAt name: @"expireAtDate" ]
            , nil ] ];
}

-(id<PFMutableOrder>)mutableOrder
{
   return [ self copy ];
}

-(PFBool)isBase
{
   return self.openOrder;// self.boundToOrderId == -1;
}

-(PFBool)isFilled
{
   return self.filledAmount == self.amount;
}

-(PFInteger)operationId
{
   return self.orderId;
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.validity = PFOrderValidityGtc;
      //Not bounded
      self.boundToOrderId = -1;
      self.optionType = -1;
      self.openOrder = YES;
      self.routeId = -1;
   }
   return self;
}

+(id)orderWithMarketOperation:( id< PFMarketOperation > )market_operation_
                        price:( PFDouble )price_
                         type:( PFOrderType )type_
{
   PFOrder* order_ = [ self new ];

   order_.instrumentId = market_operation_.instrumentId;
   order_.accountId = market_operation_.accountId;
   order_.routeId = market_operation_.routeId;
   order_.operationType = market_operation_.operationType;
   order_.price = price_;
   order_.amount = market_operation_.amount;
   order_.orderType = type_;
   order_.openOrder = NO;
   
   NSArray* allowed_validities_ = [ market_operation_.symbol allowedValiditiesForOrderType: order_.orderType ];
   
   if ( ![ allowed_validities_ containsObject: @(order_.validity) ] )
   {
      order_.validity = [ allowed_validities_ containsObject: @(PFOrderValidityDay) ] ? PFOrderValidityDay : PFOrderValidityIoc;
   }

   return order_;
}

+(id)closeOrderWithPosition:( id< PFPosition > )position_
{
   PFOrder* order_ = [ self orderWithMarketOperation: position_
                                               price: position_.openPrice
                                                type: PFOrderMarket ];

   order_.operationType = PFMarketOperationReverse( position_.operationType );

   return order_;
}

+(id)stopOrderForMarketOperation:( id< PFMarketOperation > )market_operation_
                           price:( PFDouble )price_
                  stopLossOffset:( PFDouble )stop_loss_offset_
{
   PFOrder* order_ = [ self orderWithMarketOperation: market_operation_
                                               price: price_
                                                type: price_ == 0.0 ? PFOrderTrailingStop : PFOrderStop ];

   order_.trailingOffset = stop_loss_offset_;
   order_.boundToOrderId = market_operation_.operationId;
   order_.operationType = PFMarketOperationReverse( market_operation_.operationType );

   return order_;
}

+(id)limitOrderMarketOperation:( id< PFMarketOperation > )market_operation_
                         price:( PFDouble )price_
{
   PFOrder* order_ = [ self orderWithMarketOperation: market_operation_
                                               price: price_
                                                type: PFOrderLimit ];

   order_.boundToOrderId = market_operation_.operationId;
   order_.operationType = PFMarketOperationReverse( market_operation_.operationType );

   return order_;
}

+(id)stopOrderWithPosition:( id< PFPosition > )position_
{
   if ( position_.stopLossOrderId == -1  )
      return nil;

   PFOrder* order_ = [ self stopOrderForMarketOperation: position_
                                                  price: position_.stopLossPrice
                                         stopLossOffset: position_.slTrailingOffset ];

   order_.orderId = position_.stopLossOrderId;

   return order_;
}

+(id)limitOrderWithPosition:( id< PFPosition > )position_
{
   if ( position_.takeProfitOrderId == -1  )
      return nil;

   PFOrder* order_ = [ self limitOrderMarketOperation: position_
                                                price: position_.takeProfitPrice ];

   order_.orderId = position_.takeProfitOrderId;

   return order_;
}

-(BOOL)isEqual:( id )other_
{
   if ( ![ other_ isMemberOfClass: [ self class ] ] )
      return NO;
   
   PFOrder* order_ = ( PFOrder* )other_;
   return [ self isEqualToOrder: order_ ];
}

-(BOOL)isEqualToOrder:( PFOrder* )order_
{
   return self.orderId == order_.orderId;
}

#pragma mark PFQuoteDependence

-(NSString*)dependenceIdentifier
{
   return [ NSString stringWithFormat: @"order_%d", self.orderId ];
}

@end
