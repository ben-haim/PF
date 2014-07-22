#import "PFQuoteFile.h"

@class PFMessage;
@class PFGroupField;
@class PFQuoteInfo;

@interface PFQuoteFile (PFMessage)

+(NSArray*)arrayWithFilesFromMessage:( PFMessage* )message_;
+(id)lastBarWithMessage:( PFMessage* )message_;
+(PFQuoteInfo*)quoteInfoWithGroupField:( PFGroupField* )bar_group_;

@end
