#import "PFInternalStory.h"

#import "PFField.h"
#import "PFMetaObject.h"
#import "PFFieldOwner.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@implementation PFInternalStory

@synthesize contentLines;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields: @[ [ PFMetaObjectField fieldWithName: @"contentLines" ] ] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* line_groups_ = [ field_owner_ groupFieldsWithId: PFGroupLine ];

   self.contentLines = [ line_groups_ map: ^id( id line_group_ )
                        {
                           return [ [ line_group_ fieldWithId: PFFieldText ] stringValue ];
                        }];
}

-(void)detailsWithDoneBlock:( PFStoryDetailsDoneBlock )done_block_
{
   done_block_( self.details, nil );
}

-(id< PFStoryDetails >)details
{
   return self;
}

@end
