#import "PFMarketOperation.h"

#import "PFSymbol.h"
#import "PFAccount.h"
#import "PFOrder.h"

#import "PFSymbolOptionType.h"

#import "PFMetaObject.h"
#import "PFField.h"


static id PFMarketOperationAsProtocol( id< PFMarketOperation > operation_, Protocol* protocol_ )
{
   return [ ( NSObject* )operation_ conformsToProtocol: protocol_ ]
   ? operation_
   : nil;
}

id< PFTrade > PFMarketOperationAsTrade( id< PFMarketOperation > operation_ )
{
   return PFMarketOperationAsProtocol( operation_, @protocol( PFTrade ) );
}

id< PFOrder > PFMarketOperationAsOrder( id< PFMarketOperation > operation_ )
{
   return PFMarketOperationAsProtocol( operation_, @protocol( PFOrder ) );
}

id< PFPosition > PFMarketOperationAsPosition( id< PFMarketOperation > operation_ )
{
   return PFMarketOperationAsProtocol( operation_, @protocol( PFPosition ) );
}


@interface PFMarketOperation ()

@property ( nonatomic, strong ) id<PFOrder> stopLossOrder;
@property ( nonatomic, strong ) id<PFOrder> takeProfitOrder;

@property ( nonatomic, strong ) id<PFSymbol> symbol;
@property ( nonatomic, weak ) id<PFAccount> account;

@end

@implementation PFMarketOperation

@synthesize accountId;
@synthesize orderId;
@synthesize orderType;
@synthesize operationType;
@synthesize amount;
@synthesize price;
@synthesize stopLossPrice;
@synthesize takeProfitPrice;
@synthesize createdAt;
@synthesize stopLossOrder = _stopLossOrder;
@synthesize takeProfitOrder = _takeProfitOrder;
@synthesize symbol;
@synthesize account;

@synthesize slTrailingOffset;
@synthesize trailingOffset;

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer price_transformer_ = ^id(id object_, PFFieldOwner* field_owner_, id value_)
   {
      return [ value_ doubleValue ] < 0.0 ? nil : value_;
   };

   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldAccountId name: @"accountId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOperationType name: @"operationType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAmount name: @"amount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPrice name: @"price" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOrderType name: @"orderType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSlPrice
                                         name: @"stopLossPrice"
                                       filter: ^BOOL( id self_ ){ return [ self_ stopLossPrice ] > 0.0; }
                                  transformer: price_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldTpPrice
                                         name: @"takeProfitPrice"
                                       filter: ^BOOL( id self_ ){ return [ self_ takeProfitPrice ] > 0.0; }
                                  transformer: price_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldSlTrOffset name: @"slTrailingOffset" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTrOffset name: @"trailingOffset" ]
            , nil ] ];
}

-(PFInteger)operationId
{
   [ self doesNotRecognizeSelector: _cmd ];
   return -1;
}

-(void)setStopLossOrder:( PFOrder* )stop_loss_order_
{
   self.stopLossPrice = stop_loss_order_.price;
   self.slTrailingOffset = stop_loss_order_.trailingOffset;
   _stopLossOrder = stop_loss_order_;
}

-(void)setTakeProfitOrder:( PFOrder* )take_profit_order_
{
   self.takeProfitPrice = take_profit_order_.price;
   _takeProfitOrder = take_profit_order_;
}

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   NSAssert( symbol_.instrumentId == self.instrumentId, @"incorrect instrumentId" );
   NSAssert( symbol_.routeId == self.routeId, @"incorrect routeId" );

   self.symbol = symbol_;
}

-(id)copyWithZone:( NSZone* )zone_
{
   PFMarketOperation* copy_ = [ super copyWithZone: zone_ ];

   copy_.symbol = self.symbol;
   copy_.account = self.account;
   //base class copies it
   //copy_.createdAt = self.createdAt;

   return copy_;
}

-(void)connectToAccount:( id< PFAccount > )account_
{
   NSAssert( self.accountId == account_.accountId, @"incorrect account" );
   self.account = account_;
}

-(void)disconnectFromAccount
{
   self.account = nil;
}

-(void)boundOrder:( id< PFOrder > )order_
{
   if ( order_.orderType == PFOrderStop || order_.orderType == PFOrderTrailingStop )
   {
      self.stopLossOrder = order_;
   }
   else if ( order_.orderType == PFOrderLimit )
   {
      self.takeProfitOrder = order_;
   }
}

-(void)unboundOrder:( id< PFOrder > )order_
{
   if ( order_.orderType == PFOrderStop || order_.orderType == PFOrderTrailingStop )
   {
      self.stopLossOrder = nil;
   }
   else if ( order_.orderType == PFOrderLimit )
   {
      self.takeProfitOrder = nil;
   }
}

-(void)bound:( BOOL )bound_
       order:( id< PFOrder > )order_;
{
   if ( bound_ )
   {
      [ self boundOrder: order_ ];
   }
   else
   {
      [ self unboundOrder: order_ ];
   }
}

-(NSDate*)expirationDate
{
   NSDateComponents* date_components_ = [ NSDateComponents new ];
   date_components_.day = self.expDay;
   date_components_.month = self.expMonth;
   date_components_.year = self.expYear;
   NSCalendar* calendar_ = [ [ NSCalendar alloc ] initWithCalendarIdentifier: NSGregorianCalendar ];
   NSDate* expiration_date_ = [ calendar_ dateFromComponents: date_components_ ];
   
   return expiration_date_;
}

@end
