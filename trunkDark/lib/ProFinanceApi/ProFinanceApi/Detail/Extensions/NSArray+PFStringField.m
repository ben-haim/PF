#import "NSArray+PFStringField.h"

static NSString* const PFStringFieldSeparator = @";";

@implementation NSArray (PFStringField)

+(id)arrayWithPFString:( NSString* )string_value_
{
   if ( [ string_value_ length ] == 0 )
      return nil;

   NSCharacterSet* separator_ = [ NSCharacterSet characterSetWithCharactersInString: PFStringFieldSeparator ];

   NSString* trimmed_value_ = [ string_value_ stringByTrimmingCharactersInSet: separator_ ];

   return [ trimmed_value_ componentsSeparatedByCharactersInSet: separator_ ];
}

-(NSString*)PFString
{
   return [ self componentsJoinedByString: PFStringFieldSeparator ];
}

@end
