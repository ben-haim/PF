#import <CXMLDocument.h>

#import <Foundation/Foundation.h>

@interface CXMLDocument (PFConstructors)

+(id)documentWithData:( NSData* )data_
                error:( NSError** )error_;

+(id)documentWithXMLString:( NSString* )xml_string_
                     error:( NSError** )error_;

@end
