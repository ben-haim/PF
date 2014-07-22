#import "../PFTypes.h"
#import "Detail/PFObject.h"
#import <Foundation/Foundation.h>

@protocol PFRejectMessage <NSObject>

-(PFLong)messageId;
-(NSString*)comment;
-(PFShort)errorCode;
-(PFLong)sequenceId;
-(PFInteger)requestId;

-(NSString*)nameErrorCode;
-(BOOL)IsErrorCodeName;

@end

@interface PFRejectMessage : PFObject

@property ( nonatomic, assign ) PFLong messageId;
@property ( nonatomic, strong ) NSString* comment;
@property ( nonatomic, assign ) PFShort errorCode;
@property ( nonatomic, assign ) PFLong sequenceId;
@property ( nonatomic, assign ) PFInteger requestId;

-(NSString*)nameErrorCode;
-(BOOL)IsErrorCodeName;

@end
