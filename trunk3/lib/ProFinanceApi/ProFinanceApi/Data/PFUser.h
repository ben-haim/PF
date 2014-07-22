#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

@protocol PFUser <NSObject>

-(PFInteger)userId;
-(NSString*)sessionId;
-(PFInteger)timeZoneOffset;
-(NSArray*)accountIdStrings;
-(PFBool)wrongServer;

@end

@class PFClusterNode;

@interface PFUser : PFObject< PFUser >

@property ( nonatomic, assign ) PFInteger userId;
@property ( nonatomic, strong ) NSString* sessionId;
@property ( nonatomic, strong ) NSSet* servers;
@property ( nonatomic, strong ) NSSet* nodes;
@property ( nonatomic, assign ) PFInteger timeZoneOffset;
@property ( nonatomic, strong ) NSArray* accountIdStrings;
@property ( nonatomic, assign, readonly ) PFBool isAuthenticated;
@property ( nonatomic, assign ) PFBool wrongServer;

-(PFClusterNode*)clusterNodeWithId:( PFInteger )node_id_;

@end
