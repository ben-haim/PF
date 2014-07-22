#import "NSError+PFTrader.h"

static NSString* const PFErrorDomain = @"PFTrader";

@implementation NSError (PFTrader)

+(id)traderErrorWithDescription:( NSString* )description_
{
   NSDictionary* user_info_ = @{NSLocalizedDescriptionKey: description_};
   
   return [ [ self alloc ] initWithDomain: PFErrorDomain code: 0 userInfo: user_info_ ];
}

@end
