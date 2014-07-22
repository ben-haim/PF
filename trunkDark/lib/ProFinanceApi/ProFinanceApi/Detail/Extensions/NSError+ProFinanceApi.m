#import "NSError+ProFinanceApi.h"

#import "NSBundle+PFResources.h"

static NSString* const PFErrorDomain = @"ProFinanceApi";

@implementation NSError (ProFinanceApi)

+(id)PFErrorWithDescription:( NSString* )description_
{
   NSDictionary* user_info_ = @{NSLocalizedDescriptionKey: description_};

   return [ [ self alloc ] initWithDomain: PFErrorDomain code: 0 userInfo: user_info_ ];
}

+(id)connectionError
{
   return [ NSError PFErrorWithDescription: PFLocalizedString( @"CONNECTION_ERROR", nil ) ];
}

@end
