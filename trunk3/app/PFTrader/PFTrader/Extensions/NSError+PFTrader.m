#import "NSError+PFTrader.h"

static NSString* const PFErrorDomain = @"PFTrader";

@implementation NSError (PFTrader)

+(id)traderErrorWithDescription:( NSString* )description_
{
   NSDictionary* user_info_ = [ NSDictionary dictionaryWithObject: description_
                                                           forKey: NSLocalizedDescriptionKey ];
   
   return [ [ self alloc ] initWithDomain: PFErrorDomain code: 0 userInfo: user_info_ ];
}

@end
