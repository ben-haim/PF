#import "NSDictionary+PFDemoAccount.h"

#import "PFDemoAccount.h"

#import <URLHelpers/URLHelpers.h>

@implementation NSDictionary (PFDemoAccount)

+(id)dictionaryWithDemoAccount:( id< PFDemoAccount > )account_
{
   NSMutableDictionary* dictionary_ = [ NSMutableDictionary new ];

   [ dictionary_ setIfNotNilObject: account_.brandingKey forKey: @"brandingKey" ];
   [ dictionary_ setIfNotNilObject: account_.login forKey: @"login" ];
   [ dictionary_ setIfNotNilObject: account_.password forKey: @"password" ];
   [ dictionary_ setIfNotNilObject: account_.firstName forKey: @"firstName" ];
   [ dictionary_ setIfNotNilObject: account_.lastName forKey: @"lastName" ];
   [ dictionary_ setIfNotNilObject: account_.email forKey: @"email" ];
   [ dictionary_ setIfNotNilObject: account_.phone forKey: @"phone" ];

   [ dictionary_ setObject: account_.isOnePosition ? @"true" : @"false" forKey: @"isOnePosition" ];
   [ dictionary_ setObject: [ NSString stringWithFormat: @"%d", account_.countryId ] forKey: @"countryId" ];
   [ dictionary_ setObject: [ NSString stringWithFormat: @"%@=%lld", account_.currency, account_.balance ] forKey: @"accountInfo" ];

   return dictionary_;
}

@end
