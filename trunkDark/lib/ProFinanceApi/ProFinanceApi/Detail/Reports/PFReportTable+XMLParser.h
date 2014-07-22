#import "PFReportTable.h"

@interface PFReportTable (XMLParser)

+(id)tableWithXMLString:( NSString* )xml_
                  error:( NSError** )error_;

@end
