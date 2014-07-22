#import <Foundation/Foundation.h>

#import <string>

namespace CTPP
{
   class CDT;
}

@interface NSString (HTMLTemplate)

+(NSString*)stringWithHTMLTemplate:( CTPP::CDT& )template_
                    templateAtPath:( NSString* )path_;

@end

const char* HTMLTemplatePath( NSString* file_name_, NSString* extension_ );
void HTMLTemplateAssign( CTPP::CDT& template_, NSString* string_ );
