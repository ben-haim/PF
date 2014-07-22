#import <Foundation/Foundation.h>

@protocol PFDemoAccount;

@interface NSDictionary (PFDemoAccount)

+(id)dictionaryWithDemoAccount:( id< PFDemoAccount > )account_;

@end
