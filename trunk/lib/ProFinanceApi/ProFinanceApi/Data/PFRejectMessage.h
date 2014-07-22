#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

@protocol PFRejectMessage <NSObject>

-(PFLong)messageId;
-(NSString*)comment;

@end

@interface PFRejectMessage : PFObject

@property ( nonatomic, assign ) PFLong messageId;
@property ( nonatomic, strong ) NSString* comment;

@end
