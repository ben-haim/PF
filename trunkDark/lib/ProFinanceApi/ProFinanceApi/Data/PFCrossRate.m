#import "PFCrossRate.h"

#import "PFField.h"
#import "PFMetaObject.h"

@interface PFCrossRate ()

@property ( nonatomic, assign ) PFDouble price;
@property ( nonatomic, strong ) NSString* exp1Name;
@property ( nonatomic, strong ) NSString* exp2Name;

@end

@implementation PFCrossRate

@synthesize price;
@synthesize exp1Name;
@synthesize exp2Name;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldPrice name: @"price" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNameExp1 name: @"exp1Name" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNameExp2 name: @"exp2Name" ]] ];
}

@end
