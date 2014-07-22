#import "PFPammInvestor.h"

#import "PFMessage.h"
#import "PFMetaObject.h"
#import "PFField.h"

@interface PFPammInvestor ()

@end

@implementation PFPammInvestor

@synthesize investId;
@synthesize capital;
@synthesize currCapital;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldAccountId name:@"investId" ],
            [ PFMetaObjectField fieldWithId:PFFieldAmount name:@"capital" ],
            [ PFMetaObjectField fieldWithId:PFFieldFilledAmount name:@"currCapital" ]] ];
}

-(id)init
{
   self = [ super init ];
   
   if (self)
   {
      capital = 0;
      currCapital = 0;
   }
   
   return self;
}

@end
