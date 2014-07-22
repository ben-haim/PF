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

   dictionary_[@"isOnePosition"] = account_.isOnePosition ? @"true" : @"false";
   dictionary_[@"countryId"] = [ NSString stringWithFormat: @"%d", account_.countryId ];
   dictionary_[@"accountInfo"] = [ NSString stringWithFormat: @"%@=%lld", account_.currency, account_.balance ];

   return dictionary_;
}

@end
