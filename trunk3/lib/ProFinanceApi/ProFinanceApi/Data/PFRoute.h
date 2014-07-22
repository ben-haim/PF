#import "../PFTypes.h"

#import "Detail/PFObject.h"
#import "PFOrderType.h"

#import <Foundation/Foundation.h>

@protocol PFRoute <NSObject>

-(PFInteger)routeId;
-(PFInteger)quoteRouteId;
-(NSString*)name;

-(PFBool)allowsTifModification;

-(NSArray*)allowedOrderTypes;
-(NSArray*)allowedValiditiesForOrderType:( PFOrderType )order_type_;

@end

@interface PFRoute : PFObject< PFRoute >

@property ( nonatomic, assign ) PFInteger routeId;
@property ( nonatomic, assign ) PFInteger quoteRouteId;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, assign ) PFBool allowsTifModification;

+(id)routeWithName:( NSString* )name_;
-(NSArray*)allowedOrderTypes;
-(NSArray*)allowedValiditiesForOrderType:( PFOrderType )order_type_;

@end
