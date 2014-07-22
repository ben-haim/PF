#import "PFTradingSession.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFTradingSession

@synthesize overview;
@synthesize type;
@synthesize beginTime;
@synthesize endTime;

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer time_transformer_ = ^id(id object_, PFFieldOwner* field_owner_, id value_)
   {
      return @( [ (NSDate*)value_ timeIntervalSince1970 ] );
   };
   
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldSessionDescr name: @"overview" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionType name: @"type" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionBegin name: @"beginTime" transformer: time_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionEnd name: @"endTime" transformer: time_transformer_ ]
            , nil ] ];
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"description=%@ type=%d begin=%f end=%f"
           , self.overview
           , self.type
           , self.beginTime
           , self.endTime ];
}

@end
