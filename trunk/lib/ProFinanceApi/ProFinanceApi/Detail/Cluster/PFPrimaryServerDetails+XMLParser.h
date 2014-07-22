#import "PFPrimaryServerDetails.h"

#import <Foundation/Foundation.h>

@interface PFPrimaryServerDetails (XMLParse)

+(id)detailsWithXMLString:( NSString* )xml_
                    error:( NSError** )error_;

@end
