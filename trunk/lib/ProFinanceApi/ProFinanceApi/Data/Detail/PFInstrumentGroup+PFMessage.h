#import "../PFInstrumentGroup.h"

#import <Foundation/Foundation.h>

@class PFMessage;

@interface PFInstrumentGroup (PFMessage)

+(id)groupWithMessage:( PFMessage* )message_;

-(void)synchronizeWithMessage:( PFMessage* )message_;

@end
