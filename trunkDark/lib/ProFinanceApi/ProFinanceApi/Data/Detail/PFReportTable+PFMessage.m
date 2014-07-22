#import "PFReportTable+PFMessage.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFReportTable+XMLParser.h"

@implementation PFReportTable (PFMessage)

+(id)tableWithReportMessage:( PFMessage* )message_ error:( NSError** )error_
{
   NSMutableString* xml_ = [ NSMutableString new ];
   
   for ( PFGroupField* report_group_ in [ message_ groupFieldsWithId: PFGroupLine ] )
   {
      [ xml_ appendString: [ [ report_group_ fieldWithId: PFFieldText ] stringValue ] ];
   }
    
   return [ self tableWithXMLString: xml_ error: error_ ];
}

+(id)tableWithReportXmlMessage:( PFMessage* )message_ error:( NSError** )error_
{
   NSString* xml_ = [ [ message_ fieldWithId: PFFieldXmlBody ] stringValue ];
   
   return [ self tableWithXMLString: xml_ error: error_ ];
}

@end
