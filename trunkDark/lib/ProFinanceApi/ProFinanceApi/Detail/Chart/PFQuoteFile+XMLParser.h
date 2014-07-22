#import "PFQuoteFile.h"

@class CXMLElement;

@interface PFQuoteFile (XMLParser)

+(id)quoteFileWithElement:( CXMLElement* )element_;

@end
