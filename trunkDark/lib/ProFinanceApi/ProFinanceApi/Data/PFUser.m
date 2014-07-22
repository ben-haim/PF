#import "PFUser.h"

#import "PFMetaObject.h"

#import "PFField.h"
#import "PFFieldOwner.h"
#import "PFClusterNode.h"

@implementation PFUser

@synthesize userId;
@synthesize sessionId;
@synthesize servers;
@synthesize nodes;
@synthesize timeZoneOffset;
@synthesize accountIdStrings;
@synthesize wrongServer;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldUserId name: @"userId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSessionId name: @"sessionId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTimeZoneOffset name: @"timeZoneOffset" ]
            , [ PFMetaObjectField fieldWithId: PFFieldAccounts name: @"accountIdStrings" ]
            , [ PFMetaObjectField fieldWithName: @"servers" ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* cluster_server_groups_ = [ field_owner_ groupFieldsWithId: PFGroupClusterNode ];
   if ( [ cluster_server_groups_ count ] > 0 )
   {
      NSMutableSet* nodes_ = [ NSMutableSet setWithCapacity: [ cluster_server_groups_ count ] ];
      
      for ( PFGroupField* node_group_ in cluster_server_groups_ )
      {
         [ nodes_ addObject: [ PFClusterNode objectWithFieldOwner: node_group_.fieldOwner ] ];
      }
      
      self.nodes = nodes_;
   }
   
   NSArray* server_groups_ = [ field_owner_ groupFieldsWithId: PFGroupTradeServerInfo ];
   NSMutableSet* servers_ = [ NSMutableSet setWithCapacity: [ server_groups_ count ] ];

   for ( PFGroupField* server_group_ in server_groups_ )
   {
      NSString* server_ = [ [ server_group_ fieldWithId: PFFieldValue ] stringValue ];
      if ( server_ )
      {
         [ servers_ addObject: server_ ];
      }
   }

   self.servers = servers_;
}

-(PFClusterNode*)clusterNodeWithId:( PFInteger )node_id_
{
   for ( PFClusterNode* node_ in self.nodes )
   {
      if ( node_.nodeId == node_id_ )
         return node_;
   }
   
   return nil;
}

-(PFBool)isAuthenticated
{
   return [ self.sessionId length ] > 0;
}

@end
