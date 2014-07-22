#import "PFInstrumentGroup+PFMessage.h"

#import "PFMessage.h"
#import "PFField.h"

@implementation PFInstrumentGroup (PFMessage)

+(id)groupWithMessage:( PFMessage* )message_
{
   PFInstrumentGroup* group_ = [ self groupWithId: [ (PFIntegerField*)[ message_ fieldWithId: PFFieldInstrumentTypeId ] integerValue ] ];

   group_.superId = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldSuperId ] integerValue ];
   
   [ group_ synchronizeWithMessage: message_ ];

   return group_;
}

-(void)synchronizeWithMessage:( PFMessage* )message_
{
   self.name = [ [ message_ fieldWithId: PFFieldName ] stringValue ];
}

@end
