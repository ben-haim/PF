#import "PFQuoteFile+XMLParser.h"

#import <CXMLElement.h>

static NSString* const PFNilSignature = @"null";

@implementation PFQuoteFile (XMLParser)

+(id)quoteFileWithElement:( CXMLElement* )element_
{
   PFQuoteFile* quote_file_ = [ self new ];

   quote_file_.name = [ [ element_ attributeForName: @"name" ] stringValue ];
   NSString* signature_ =  [ [ element_ attributeForName: @"md5hash" ] stringValue ];

   if ( ![ signature_ isEqual: PFNilSignature ] )
   {
      quote_file_.signature = signature_;
   }

   quote_file_.compressed =  [ [ [ element_ attributeForName: @"compressed" ] stringValue ] boolValue ];

   return quote_file_;
}

@end
