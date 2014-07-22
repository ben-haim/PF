#import "PFReportTable+XMLParser.h"

#import "NSBundle+PFResources.h"
#import "NSError+ProFinanceApi.h"
#import "CXMLDocument+PFConstructors.h"

#import <TouchXML.h>

@implementation PFReportTable (XMLParser)

+(id)tableWithXMLString:( NSString* )xml_
                  error:( NSError** )error_
{
   NSError* parse_error_ = nil;
   
   CXMLDocument* document_ = [ CXMLDocument documentWithXMLString: xml_ error: &parse_error_ ];
   
   if ( parse_error_ )
   {
      if ( error_ )
      {
         *error_ = [ NSError PFErrorWithDescription: PFLocalizedString( @"PARSE_REPORT_ERROR", nil ) ];
      }
      return nil;
   }

   NSCharacterSet* whitespaces_ = [ NSCharacterSet whitespaceAndNewlineCharacterSet ];

   PFReportTable* table_ = [ self new ];

   CXMLElement* root_element_ = [ document_ rootElement ];
   CXMLElement* report_element_ = ( CXMLElement* )[ root_element_ nodeForXPath: @"report" error: nil ];

   table_.name = [ [ report_element_ attributeForName: @"name" ] stringValue ];
   table_.dialog = [ [ report_element_ attributeForName: @"dialog" ] stringValue ];

   for ( CXMLNode* row_element_ in report_element_.children )
   {
      if ( row_element_.kind != CXMLElementKind )
         continue;

      NSArray* cell_elements_ = row_element_.children;
      NSMutableArray* values_ = [ NSMutableArray arrayWithCapacity: [ cell_elements_ count ] ];

      for ( CXMLNode* cell_element_ in cell_elements_  )
      {
         if ( cell_element_.kind == CXMLElementKind )
         {
            [ values_ addObject: [ [ cell_element_ stringValue ] stringByTrimmingCharactersInSet: whitespaces_ ] ];
         }
      }
      [ table_ addRow: values_ ];
   }
   
   table_.date = [ NSDate date ];
   
   return table_.rows.count == 1 ? [ table_ transformedTable ] : table_;
}

@end
