#import "Detail/PFObject.h"
#import "PFMessage.h"

@interface PFPammInvestor : PFObject

@property (nonatomic, assign) PFInteger investId;
@property (nonatomic, assign) PFDouble capital;
@property (nonatomic, assign) PFDouble currCapital;

@end