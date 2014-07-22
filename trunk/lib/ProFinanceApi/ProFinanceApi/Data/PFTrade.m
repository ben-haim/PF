#import "PFTrade.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFTrade

@synthesize tradeId;
@synthesize commission;
@synthesize grossPl;
@synthesize extId;
@synthesize login;
@synthesize externalPrice;
@synthesize exchange;

@dynamic isBuy;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldTradeId name: @"tradeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOrderId name: @"orderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCommission name: @"commission" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPnl name: @"grossPl" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsBuy name: @"isBuy" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"createdAt" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExtId name: @"extId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCreatorName name: @"login" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExternalPrice name: @"externalPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldExchange name: @"exchange" ]
            , nil ] ];
}

-(PFInteger)operationId
{
   return self.tradeId;
}

-(void)setIsBuy:( PFBool )is_buy_
{
   self.operationType = is_buy_ ? PFMarketOperationBuy : PFMarketOperationSell;
}

-(PFBool)isBuy
{
   return self.operationType == PFMarketOperationBuy;
}

-(PFDouble)netPl
{
   return self.grossPl - self.commission;
}

@end
