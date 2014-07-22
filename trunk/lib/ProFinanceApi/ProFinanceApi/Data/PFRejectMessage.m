#import "PFRejectMessage.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFRejectMessage

@synthesize messageId;
@synthesize comment;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldId name: @"messageId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldComment name: @"comment" ]
            , nil ] ];
}

@end
