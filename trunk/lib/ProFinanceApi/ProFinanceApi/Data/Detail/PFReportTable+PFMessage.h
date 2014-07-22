#import "../PFReportTable.h"

@class PFMessage;

@interface PFReportTable (PFMessage)

+(id)tableWithReportMessage:( PFMessage* )message_ error:( NSError** )error_;

+(id)tableWithReportXmlMessage:( PFMessage* )message_ error:( NSError** )error_;

@end
