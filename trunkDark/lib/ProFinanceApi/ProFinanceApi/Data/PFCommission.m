#import "PFCommission.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFMetaObject.h"

@implementation PFCommission

@synthesize operationType;
@synthesize fromAmount;
@synthesize toAmount;
@synthesize value;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldOperationType name: @"operationType" ]
            , [ PFMetaObjectField fieldWithId: PFFieldFromAmount name: @"fromAmount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldToAmount name: @"toAmount" ]
            , [ PFMetaObjectField fieldWithId: PFFieldCommissionValue name: @"value" ]] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"PFCommission: operationType=%d fromAmount=%d toAmount=%d value=%f",
           self.operationType,
           self.fromAmount,
           self.toAmount,
           self.value ];
}

@end
