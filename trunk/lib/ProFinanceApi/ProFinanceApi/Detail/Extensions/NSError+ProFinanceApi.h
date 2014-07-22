#import <Foundation/Foundation.h>

@interface NSError (ProFinanceApi)

+(id)PFErrorWithDescription:( NSString* )string_;

+(id)connectionError;

@end
