#import "../../PFTypes.h"

#import <Foundation/Foundation.h>

@interface NSDate (PFTimeStamp)

+(id)dateWithMsecondsTimeStamp:( PFLong )mseconds_;

-(PFLong)msecondsTimeStamp;

@end
