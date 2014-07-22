#import "PFCountry.h"

@interface NSDictionary (PFCountries)

+(id)dictionaryWithCountries;

@end

@implementation NSDictionary (PFCountries)

+(id)dictionaryWithCountries
{
   return [ self dictionaryWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"PFCountries"
                                                                                  ofType: @"plist" ] ];
}

@end


@implementation PFCountry

@synthesize countryId;
@synthesize name;

-(id)initWithId:( NSUInteger )country_id_
           name:( NSString* )name_
{
   self = [ super init ];
   if ( self )
   {
      self.countryId = country_id_;
      self.name = name_;
   }
   return self;
}

-( NSComparisonResult )compare:( PFCountry* )country_
{
   return [ self.name compare: country_.name ];
}

+(NSArray*)defaultCountries
{
   static NSArray* default_countries_ = nil;
   if ( !default_countries_ )
   {
      NSDictionary* name_by_id_ = [ NSDictionary dictionaryWithCountries ];
      NSMutableArray* mutable_countries_ = [ NSMutableArray arrayWithCapacity: [ name_by_id_ count ] ];
      for ( NSString* id_ in name_by_id_ )
      {
         [ mutable_countries_ addObject: [ [ self alloc ] initWithId: [ id_ integerValue ]
                                                                name: name_by_id_[id_] ] ];
      }
      default_countries_ = [ mutable_countries_ sortedArrayUsingSelector: @selector(compare:)];
   }
   return default_countries_;
}

@end


