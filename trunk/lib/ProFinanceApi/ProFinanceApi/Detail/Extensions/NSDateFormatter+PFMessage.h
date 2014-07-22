#import <Foundation/Foundation.h>

@interface NSDateFormatter (PFMessage)

+(id)compileDateFormatter;
+(id)searchCriteriaDateFormatter;
+(id)expirationDateFormatter;
+(id)dowJonesDateFormatter;
+(id)dowJonesDetailedDateFormatter;

@end
