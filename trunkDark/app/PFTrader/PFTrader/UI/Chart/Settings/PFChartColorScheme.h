#import "PFChartColorSchemeType.h"

#import <Foundation/Foundation.h>

@interface PFChartColorScheme : NSObject

@property ( nonatomic, strong, readonly ) NSDictionary* properties;

+(id)defaultScheme;
+(id)greenScheme;

+(id)schemeWithType:( PFChartColorSchemeType )scheme_type_;

@end
