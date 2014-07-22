#import "PFCommissionLevelGroup.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

#import "PFCommissionGroup.h"

@class PFCommissionGroup;

@implementation PFCommissionLevelGroup

@synthesize instrumentTypeId;
@synthesize instrumentId;
@synthesize specifiedCurrency;
@synthesize type;

@synthesize commissionGroup;

-(NSMutableArray*)commissionGroup
{
   if ( !commissionGroup )
      commissionGroup = [ NSMutableArray new ];
   
   return commissionGroup;
}

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldInstrumentTypeId name: @"instrumentTypeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldInstrumentId name: @"instrumentId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCurrency name: @"specifiedCurrency" ]
            , [ PFMetaObjectField fieldWithId: PFFieldType name: @"type" ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* commission_groups_ = [ field_owner_ groupFieldsWithId: PFGroupCommission ];
   
   for ( PFGroupField* commission_group_ in commission_groups_ )
   {
      PFCommissionGroup* commission_ = [ PFCommissionGroup objectWithFieldOwner: commission_group_.fieldOwner ];
      [ self.commissionGroup addObject: commission_ ];
   }
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommissionLevelGroup: type=%d instrumentTypeId=%d instrumentId=%d specifiedCurrency=%@"
           , self.type
           , self.instrumentTypeId
           , self.instrumentId
           , self.specifiedCurrency ];
}

@end
