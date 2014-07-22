#import "NSDictionary+URLHelpers.h"

@implementation NSDictionary (URLHelpers)

-(NSString*)URLArguments
{
   NSMutableArray* name_value_array_ = [ NSMutableArray arrayWithCapacity: [ self count ] ];
   for ( id key_ in self )
   {
      NSString* value_ = [ self[key_] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
      [ name_value_array_ addObject: [ NSString stringWithFormat: @"%@=%@", key_, value_ ] ];
   }
   return [ name_value_array_ componentsJoinedByString: @"&" ];
}

@end

@implementation NSMutableDictionary (URLHelpers)

-(void)setIfNotNilObject:( NSObject* )object_ forKey:( NSString* )key_
{
   if ( object_ )
   {
      self[key_] = object_;
   }
}

@end
