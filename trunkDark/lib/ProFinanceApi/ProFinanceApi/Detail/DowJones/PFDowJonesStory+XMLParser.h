#import "PFDowJonesStory.h"

@class CXMLElement;

@interface PFDowJonesStory (XMLParser)

+(id)storyWithElement:( CXMLElement* )element_;

@end

@interface PFDowJonesStoryDetails (XMLParser)

+(id)storyDetailsWithElement:( CXMLElement* )element_;

@end