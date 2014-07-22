#import "PFQuoteFile.h"

@class PFMessage;

@interface PFQuoteFile (PFMessage)

+(NSArray*)arrayWithFilesFromMessage:( PFMessage* )message_;
+(id)lastBarWithMessage:( PFMessage* )message_;

@end
