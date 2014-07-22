#import "PFStory+PFMessage.h"

#import "PFInternalStory.h"

#import "PFMessage.h"
#import "PFField.h"
#import "PFFieldOwner.h"

@implementation PFStory (PFMessage)

+(NSArray*)storiesWithMessage:( PFMessage* )message_
{
   NSArray* strory_groups_ = [ message_ groupFieldsWithId: PFGroupNews ];
   NSMutableArray* stories_ = [ NSMutableArray arrayWithCapacity: [ strory_groups_ count ] ];

   for ( PFGroupField* story_group_ in strory_groups_ )
   {
      PFFieldOwner* field_owner_ = story_group_.fieldOwner;
      [ stories_ addObject: [ PFInternalStory objectWithFieldOwner: field_owner_ ] ];
   }
   return stories_;
}

@end
