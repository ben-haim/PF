#import "CXMLElement+Parser.h"

@implementation CXMLElement (Parser)

-(CXMLElement*)elementForName:( NSString* )name_
{
   return [ [ self elementsForName: name_ ] lastObject ];
}

@end
