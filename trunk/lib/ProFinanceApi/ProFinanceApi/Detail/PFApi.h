#import "../PFTypes.h"

#import "PFCommander.h"
#import "PFRequestDoneBlock.h"

#import <Foundation/Foundation.h>

@class PFMessage;
@class PFMessageBuilder;
@class PFServerInfo;

@protocol PFApiDelegate;

@interface PFApi : NSObject< PFCommander >

@property ( nonatomic, strong, readonly ) PFServerInfo* serverInfo;

@property ( nonatomic, strong, readonly ) NSString* login;
@property ( nonatomic, strong, readonly ) NSString* password;

@property ( nonatomic, assign, readonly ) BOOL transferFinished;
@property ( nonatomic, strong, readonly ) PFMessageBuilder* messageBuilder;

@property ( nonatomic, weak ) id< PFApiDelegate > delegate;

@property ( nonatomic, assign, readonly ) int verificationId;

+(id)apiWithDelegate:( id< PFApiDelegate > )delegate_;

-(BOOL)connectToServerWithInfo:( PFServerInfo* )server_info_;

-(void)sendMessage:( PFMessage* )message_ doneBlock:( PFRequestDoneBlock )done_block_;

@end

