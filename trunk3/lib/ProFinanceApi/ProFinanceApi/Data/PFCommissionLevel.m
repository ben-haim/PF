#import "PFCommissionLevel.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

@implementation PFCommissionLevel

@synthesize commissionLevelId;
@synthesize instrumentTypeId;
@synthesize instrumentId;
@synthesize comment;
@synthesize specifiedCurrency;
@synthesize perOrderPrice;
@synthesize closePrice;
@synthesize openPrice;
@synthesize freeAmount;
@synthesize dealerCommission;
@synthesize type;
@synthesize minPerOrder;
@synthesize maxPerOrder;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldId name: @"commissionLevelId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentTypeId name: @"instrumentTypeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldComment name: @"comment" ]
            , [ PFMetaObjectField fieldWithId: PFFieldPerOrderPrice name: @"perOrderPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldClosePrice name: @"closePrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldOpenPrice name: @"openPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldFreeCommisionAmount name: @"freeAmount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDealerCommisoin name: @"dealerCommission" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSpreadMeasure name: @"type" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMinPerOrder name: @"minPerOrder" ]
            , [ PFMetaObjectField fieldWithId: PFFieldMaxPerOrder name: @"maxPerOrder" ]
            , nil ] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommissionLevel: commissionLevelId=%lld instrumentTypeId=%d instrumentId=%d type=%d"
           , self.commissionLevelId
           , self.instrumentTypeId
           , self.instrumentId
           , self.type ];
}

@end
