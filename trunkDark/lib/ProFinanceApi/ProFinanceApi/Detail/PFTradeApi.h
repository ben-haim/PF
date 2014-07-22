#import "PFApi.h"
#import "PFTradeCommander.h"

#import <Foundation/Foundation.h>

@class PFPrimaryServerDetails;

typedef void (^PFPrimaryServerDetailsDoneBlock)( PFPrimaryServerDetails* details_, NSError* error_ );

@interface PFTradeApi : PFApi< PFTradeCommander >

-(void)serverDetailsWithDoneBlock:( PFPrimaryServerDetailsDoneBlock )done_block_;

@end
