#import "PFObject.h"

@interface PFCrossRate : PFObject

@property ( nonatomic, assign, readonly ) PFDouble price;
@property ( nonatomic, strong, readonly ) NSString* exp1Name;
@property ( nonatomic, strong, readonly ) NSString* exp2Name;

@end
