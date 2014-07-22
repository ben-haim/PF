#import "../PFMarketOperation.h"

#import <Foundation/Foundation.h>

@class PFFieldOwner;

@interface PFMarketOperation (PFMessage)

+(id)marketOperationWithFieldOwner:( PFFieldOwner* )field_owner_;

@end
