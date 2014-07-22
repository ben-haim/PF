#import "PFRejectMessage.h"

#import "PFMetaObject.h"
#import "PFField.h"

@implementation PFRejectMessage

@synthesize messageId;
@synthesize comment;
@synthesize errorCode;
@synthesize requestId;
@synthesize sequenceId;

-(NSString*)nameErrorCode
{
    static NSDictionary* names_error_code_ = nil;

    if ( !names_error_code_ )
    {
        names_error_code_ = @{
            @(28): @"BUSINESS_REJECT_MESSAGE_28",
            @(31): @"BUSINESS_REJECT_MESSAGE_31",
            @(201): @"BUSINESS_REJECT_MESSAGE_201",
            @(202): @"BUSINESS_REJECT_MESSAGE_202",
            @(203): @"BUSINESS_REJECT_MESSAGE_203",
            @(221): @"BUSINESS_REJECT_MESSAGE_221",
            @(222): @"BUSINESS_REJECT_MESSAGE_222",
            @(223): @"BUSINESS_REJECT_MESSAGE_223"
       };
    }
    return NSLocalizedString( names_error_code_[@( errorCode )], nil );
}

-(BOOL)IsErrorCodeName
{
    return self.nameErrorCode.length > 0;
}

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldId name: @"messageId" ],
                [ PFMetaObjectField fieldWithId: PFFieldErrorCode name: @"errorCode" ],
                [ PFMetaObjectField fieldWithId: PFFieldComment name: @"comment" ],
                [ PFMetaObjectField fieldWithId: PFFieldSequenceId name: @"sequenceId" ],
                [ PFMetaObjectField fieldWithId: PFFieldRequestId name: @"requestId" ]] ];
}

@end
