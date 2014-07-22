#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

typedef enum
{
   PFChatMessageUsual = 1
   , PFChatMessageConfirmation = 3
   , PFChatMessageBrockerUrgent = 8
   , PFChatMessageBrockerWelcome = 9
   , PFChatMessageBrockerPeriodic = 10
} PFChatMessageType;

typedef enum
{
   PFChatMessageTargetNobody = 0
   , PFChatMessageTargetBroker = 3
} PFChatMessageTargetType;

@protocol PFChatMessage < NSObject >

-(PFInteger)type;
-(PFLong)messageId;
-(PFInteger)senderId;
-(PFInteger)targetId;
-(NSString*)text;
-(NSDate*)date;

@end

@protocol PFUser;

@interface PFChatMessage : PFObject< PFChatMessage >

@property ( nonatomic, assign ) PFInteger type;
@property ( nonatomic, assign ) PFLong messageId;
@property ( nonatomic, assign ) PFInteger senderId;
@property ( nonatomic, assign ) PFInteger targetId;
@property ( nonatomic, strong ) NSString* text;
@property ( nonatomic, strong ) NSDate* date;

+(id)messageWithText:( NSString* )text_
            fromUser:( id< PFUser > )user_;

-(PFChatMessage*)messageForReceiveConfirmation;

@end
