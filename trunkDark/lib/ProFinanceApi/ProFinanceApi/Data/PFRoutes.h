#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFRoute;

@protocol PFRoutes <NSObject>

-(id< PFRoute >)routeByName:( NSString* )name_;
-(id< PFRoute >)routeById:( PFInteger )id_;

@end

@class PFMessage;
@class PFRoute;

@interface PFRoutes : NSObject< PFRoutes >

-(PFRoute*)writeRouteWithName:( NSString* )name_;
-(NSArray*)writeRoutesWithNames:( NSArray* )names_;

-(void)updateRouteWithMessage:( PFMessage* )message_;

@end
