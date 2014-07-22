#import "NSURL+URLHelpers.h"

#import "NSDictionary+URLHelpers.h"

@implementation NSURL (URLHelpers)

+(id)URLWithString:( NSString* )string_
         arguments:( NSDictionary* )arguments_
{
   if ( [ arguments_ count ] == 0 )
      return [ NSURL URLWithString: string_ ];

   return [ NSURL URLWithString: [ string_ stringByAppendingFormat: @"?%@", [ arguments_ URLArguments ] ] ];
}

@end
