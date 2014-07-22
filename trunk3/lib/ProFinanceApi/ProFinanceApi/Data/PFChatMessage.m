#import "PFChatMessage.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFMetaObject.h"

#import "PFUser.h"

@implementation PFChatMessage

@synthesize type;
@synthesize messageId;
@synthesize senderId;
@synthesize targetId;
@synthesize text;
@synthesize date;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldTextMessageType name: @"type" ]
            , [ PFMetaObjectField fieldWithId: PFFieldId name: @"messageId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSenderId name: @"senderId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTargetId name: @"targetId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldText name: @"text" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , nil ] ];
}

+(id)messageWithText:( NSString* )text_
            fromUser:( id< PFUser > )user_
{
   PFChatMessage* message_ = [ self new ];

   message_.type = PFChatMessageUsual;
   message_.senderId = user_.userId;
   message_.targetId = PFChatMessageTargetBroker;
   message_.text = text_;
   message_.date = [ NSDate date ];

   return message_;
}

-(id)messageForReceiveConfirmation
{
   PFChatMessage* message_ = [ [ self class ] new ];
   
   message_.type = PFChatMessageConfirmation;
   message_.senderId = self.targetId;
   message_.targetId = PFChatMessageTargetNobody;

   message_.text = [ NSString stringWithFormat: @"<status refobj='message' refid='%lld'><field name='reacted' value='true'/></status>"
                    , self.messageId ];

   message_.date = [ NSDate date ];

   return message_;
}

@end
