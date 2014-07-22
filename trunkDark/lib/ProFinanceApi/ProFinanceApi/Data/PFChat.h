#import <Foundation/Foundation.h>

@protocol PFChat <NSObject>

-(NSArray*)messages;

@end

@class PFChatMessage;

@interface PFChat : NSObject< PFChat >

@property ( nonatomic, strong, readonly ) NSArray* messages;

-(void)addMessage:( PFChatMessage* )message_;

@end
