#import "PFPrimaryServerDetails+XMLParser.h"

#import "NSBundle+PFResources.h"
#import "NSError+ProFinanceApi.h"
#import "CXMLDocument+PFConstructors.h"

#import <TouchXML.h>

@implementation PFPrimaryServerDetails (XMLParse)

+(id)detailsWithXMLString:( NSString* )xml_
                    error:( NSError** )error_
{
   NSError* parse_error_ = nil;

   CXMLDocument* document_ = [ CXMLDocument documentWithXMLString: xml_ error: &parse_error_ ];

   if ( parse_error_ )
   {
      if ( error_ )
      {
         *error_ = [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_RESPONSE_ERROR", nil ) ];
      }
      return nil;
   }

   CXMLElement* root_element_ = [ document_ rootElement ];
   CXMLNode* cluster_info_element_ = [ root_element_ nodeForXPath: @"//isClusterReturn" error: nil ];

   PFPrimaryServerDetails* details_ = [ self new ];
   details_.cluster = [ [ cluster_info_element_ stringValue ] boolValue ];
   return details_;
}

@end
