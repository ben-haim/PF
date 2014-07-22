#import "PFEventHTMLFormatter.h"

#import "NSDateFormatter+PFTrader.h"
#import "NSString+HTMLTemplate.h"

#import <ProFinanceApi/ProFinanceApi.h>

#include <CDT.hpp>

@implementation PFEventHTMLFormatter

-(NSString*)toHTMLReport:( id< PFReportTable > )report_
{
   CTPP::CDT template_;
   
   HTMLTemplateAssign( template_[ "RESOURCE_PATH" ], [ [ NSBundle mainBundle ] resourcePath ] );
   HTMLTemplateAssign( template_[ "HEADER" ], report_.name );
   HTMLTemplateAssign( template_[ "DATE" ], [ [ NSDateFormatter newsDateFormatter ] stringFromDate: report_.date ] );
   
   for ( NSDictionary* row_ in report_.rows )
   {
      CTPP::CDT line_row_;
      for ( NSInteger i_ = 0; i_ < report_.header.count ; ++i_ )
         HTMLTemplateAssign( line_row_[ ( i_ == 0 ? "LINE0" : "LINE1" ) ], [ row_ objectForKey: [ report_.header objectAtIndex: i_ ] ] );
      
      template_[ "LINES" ].PushBack( line_row_ );
   }
   
   NSString* html_ = [ NSString stringWithHTMLTemplate: template_
                                        templateAtPath: UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ?
                      [ [ NSBundle mainBundle ] pathForResource: @"PFEvent_iPad" ofType: @"ct2" ] :
                      [ [ NSBundle mainBundle ] pathForResource: @"PFEvent" ofType: @"ct2" ] ];
   return html_;
}

@end
