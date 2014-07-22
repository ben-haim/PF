#import "CXMLDocument+PFConstructors.h"

#import "NSError+ProFinanceApi.h"

#include <libxml/xmlerror.h>

@implementation CXMLDocument (PFConstructors)

+(id)documentWithData:( NSData* )data_
                error:( NSError** )error_
{
   NSError* parse_error_ = nil;

   xmlResetLastError();

   CXMLDocument* document_ = [ [ CXMLDocument alloc ] initWithData: data_ options: 0 error: &parse_error_ ];

   xmlErrorPtr xml_error_ = xmlGetLastError();
   
   if ( !parse_error_ && xml_error_ )
   {
      parse_error_ = [ NSError PFErrorWithDescription: @(xml_error_->message) ];
   }

   if ( parse_error_ )
   {
      if ( error_ )
      {
         *error_ = parse_error_;
      }
      return nil;
   }

   return document_;
}

+(id)documentWithXMLString:( NSString* )xml_string_
                     error:( NSError** )error_
{
   NSError* parse_error_ = nil;

   xmlResetLastError();

   CXMLDocument* document_ = [ [ CXMLDocument alloc ] initWithXMLString: xml_string_ options: 0 error: &parse_error_ ];

   xmlErrorPtr xml_error_ = xmlGetLastError();
   
   if ( !parse_error_ && xml_error_ )
   {
      parse_error_ = [ NSError PFErrorWithDescription: @(xml_error_->message) ];
   }

   if ( parse_error_ )
   {
      if ( error_ )
      {
         *error_ = parse_error_;
      }
      return nil;
   }

   return document_;
}

@end
