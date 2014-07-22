#import "PFDowJonesStory+XMLParser.h"

#import "CXMLElement+Parser.h"

#import "NSDateFormatter+PFMessage.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@implementation PFDowJonesStory (XMLParser)

+(id)storyWithElement:( CXMLElement* )element_
{
   PFDowJonesStory* story_ = [ self new ];

   story_.storyId = (PFInteger)[ [ [ element_ elementForName: @"ArticleId" ] stringValue ] integerValue ];
   story_.source = [ [ element_ elementForName: @"SourceName" ] stringValue ];
   story_.header = [ [ element_ elementForName: @"Headline" ] stringValue ];

   NSString* publish_date_string_ = [ [ element_ elementForName: @"PubDateTime" ] stringValue ];

   NSDate* date_ = [ [ NSDateFormatter dowJonesDateFormatter ] dateFromString: publish_date_string_ ];

   story_.date = date_ ?: [ [ NSDateFormatter dowJonesDetailedDateFormatter ] dateFromString: publish_date_string_ ];
   story_.detailsUrl = [ NSURL URLWithString: [ [ element_ elementForName: @"Link" ] stringValue ] ];

   return story_;
}

@end

@implementation PFDowJonesStoryDetails (XMLParser)

+(id)storyDetailsWithElement:( CXMLElement* )element_
{
   PFDowJonesStoryDetails* details_ = [ self new ];

   NSArray* text_elements_ =  [ element_ nodesForXPath: @"Body/Paragraph/PItems/Text" error: nil ];
   details_.contentLines = [ text_elements_ map: ^id( id element_ )
                            {
                               return [ element_ stringValue ];
                            }];

   return details_;
}

@end
