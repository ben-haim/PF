#import "../PFAccount.h"
#import "../PFAssetAccount.h"
#import "../PFRule.h"

@interface PFAccount (Update)

//Returns list of updated positions
-(NSArray*)update;

@end
