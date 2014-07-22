#import "PFStoryHTMLFormatter.h"

#import "NSDateFormatter+PFTrader.h"
#import "NSString+HTMLTemplate.h"

#import <ProFinanceApi/ProFinanceApi.h>

#include <CDT.hpp>

@implementation PFStoryHTMLFormatter

-(NSString*)toHTMLStory:( id< PFStory > )story_
{
   CTPP::CDT template_;
   
   HTMLTemplateAssign( template_[ "RESOURCE_PATH" ], [ [ NSBundle mainBundle ] resourcePath ] );

   HTMLTemplateAssign( template_[ "HEADER" ], story_.header );
   HTMLTemplateAssign( template_[ "DATE" ], [ [ NSDateFormatter newsDateFormatter ] stringFromDate: story_.date ] );

   for ( NSString* line_ in story_.details.contentLines )
   {
      CTPP::CDT line_row_;
      HTMLTemplateAssign( line_row_[ "LINE" ], line_ );
      template_[ "LINES" ].PushBack( line_row_ );
   }

   NSString* html_ = [ NSString stringWithHTMLTemplate: template_
                                        templateAtPath: [ [ NSBundle mainBundle ] pathForResource: @"PFStory"
                                                                                           ofType: @"ct2" ] ];

   return html_;
}

@end
