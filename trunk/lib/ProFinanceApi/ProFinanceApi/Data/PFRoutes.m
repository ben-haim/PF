#import "PFRoutes.h"

#import "PFRoute.h"

#import "PFMessage.h"
#import "PFField.h"

@interface PFRoutes ()

@property ( nonatomic, strong ) NSMutableDictionary* routesById;
@property ( nonatomic, strong ) NSMutableDictionary* routesByName;

@end

@implementation PFRoutes

@synthesize routesById = _routesById;
@synthesize routesByName = _routesByName;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.routesById = [ NSMutableDictionary dictionary ];
      self.routesByName = [ NSMutableDictionary dictionary ];
   }
   return self;
}

-(void)addRoute:( id< PFRoute > )route_
{
   [ self.routesByName setObject: route_ forKey: route_.name ];
   [ self.routesById setObject: route_ forKey: @(route_.routeId) ];
}

-(id< PFRoute >)routeByName:( NSString* )name_
{
   return [ self.routesByName objectForKey: name_ ];
}

-(id< PFRoute >)routeById:( PFInteger )id_
{
   return [ self.routesById objectForKey: @(id_) ];
}

-(NSString*)description
{
   return [ self.routesByName description ];
}

-(PFRoute*)writeRouteWithName:( NSString* )name_
{
   PFRoute* route_ = [ self.routesByName objectForKey: name_ ];
   if ( !route_ )
   {
      route_ = [ PFRoute routeWithName: name_ ];
      [ self addRoute: route_ ];
   }
   return route_;
}

-(NSArray*)writeRoutesWithNames:( NSArray* )names_
{
   if ( [ names_ count ] == 0 )
      return nil;
   
   NSMutableArray* routes_ = [ NSMutableArray arrayWithCapacity: [ names_ count ] ];
   for ( NSString* name_ in names_ )
   {
      [ routes_ addObject: [ self writeRouteWithName: name_ ] ];
   }

   return routes_;
}

-(void)updateRouteWithMessage:( PFMessage* )message_
{
   NSString* name_ = [ [ message_ fieldWithId: PFFieldName ] stringValue ];
   PFRoute* route_ = [ self writeRouteWithName: name_ ];
   [ route_ readFromFieldOwner: message_ ];
}

@end
