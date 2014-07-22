#import "PFStory.h"

#import "PFField.h"
#import "PFMetaObject.h"

#import "NSURL+SafeInit.h"

@implementation PFStory

@synthesize storyId;
@synthesize routeId;
@synthesize source;
@synthesize header;
@synthesize url;
@synthesize date;

+(PFMetaObject*)metaObject
{
   PFMetaObjectFieldTransformer url_transformer_ = ^id(id object_, PFFieldOwner* field_owner_, id value_)
   {
      return [ NSURL safeURLWithString: ( NSString* )value_ ];
   };

   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldNewsId name: @"storyId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSource name: @"source" ]
            , [ PFMetaObjectField fieldWithId: PFFieldRouteId name: @"routeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTheme name: @"header" ]
            , [ PFMetaObjectField fieldWithId: PFFieldText
                                         name: @"url"
                                  transformer: url_transformer_ ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]] ];
}

-(void)detailsWithDoneBlock:( PFStoryDetailsDoneBlock )done_block_
{
   done_block_( self.details, nil );
}

-(id< PFStoryDetails >)details
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

@end
