#import "PFClusterNode.h"

#import "PFMetaObject.h"

#import "PFField.h"
#import "PFFieldOwner.h"

@implementation PFClusterNode

@synthesize nodeId;
@synthesize isReportNode;
@synthesize isHostNode;
@synthesize loadIndex;
@synthesize connectionMode;
@synthesize adressPFIX;
@synthesize adressPFIXS;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           @[[ PFMetaObjectField fieldWithId: PFFieldNodeId name: @"nodeId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNodeReportTable name: @"isReportNode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsHostNode name: @"isHostNode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldNodeLoad name: @"loadIndex" ]
            , [ PFMetaObjectField fieldWithId: PFFieldConnectionMode name: @"connectionMode" ]
            , [ PFMetaObjectField fieldWithId: PFFieldTimeZoneOffset name: @"adressProtocol" ]] ];
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* node_info_groups_ = [ field_owner_ groupFieldsWithId: PFGroupTradeServerInfo ];
   for ( PFGroupField* group_ in node_info_groups_ )
   {
      PFAdressProtocol adress_protocol_ = [ [ group_ fieldWithId: PFFieldAdressProtocol ] byteValue ];
      
      if ( adress_protocol_ == PFAdressProtocolPFIX )
      {
         self.adressPFIX = [ [ group_ fieldWithId: PFFieldValue ] stringValue ];
      }
      else
      {
         self.adressPFIXS = [ [ group_ fieldWithId: PFFieldValue ] stringValue ];
      }
   }
}

@end
