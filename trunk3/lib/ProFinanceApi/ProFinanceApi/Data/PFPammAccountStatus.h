#import "Detail/PFObject.h"
#import "PFMessage.h"

@interface PFPammAccountStatus : PFObject

@property ( nonatomic, assign ) PFInteger pammStatusId;
-(NSArray*)allInvestors;

@end
