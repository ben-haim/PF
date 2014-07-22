#import "../PFTypes.h"

#import "Detail/PFObject.h"

#import <Foundation/Foundation.h>

typedef enum
{
   PFAdressProtocolPFIX = 0
   , PFAdressProtocolPFIXS = 1
} PFAdressProtocol;

@interface PFClusterNode : PFObject

@property ( nonatomic, assign ) PFInteger nodeId;
@property ( nonatomic, assign ) PFBool isReportNode;
@property ( nonatomic, assign ) PFBool isHostNode;
@property ( nonatomic, assign ) PFInteger loadIndex;
@property ( nonatomic, assign ) PFInteger connectionMode;
@property ( nonatomic, strong ) NSString* adressPFIX;
@property ( nonatomic, strong ) NSString* adressPFIXS;

@end
