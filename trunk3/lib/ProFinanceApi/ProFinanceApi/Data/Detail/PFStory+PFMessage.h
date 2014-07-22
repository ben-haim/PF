#import "../PFStory.h"

#import <Foundation/Foundation.h>

@class PFMessage;

@interface PFStory (PFMessage)

+(NSArray*)storiesWithMessage:( PFMessage* )message_;

@end
