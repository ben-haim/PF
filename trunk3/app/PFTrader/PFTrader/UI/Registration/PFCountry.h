#import <UIKit/UIKit.h>

@interface PFCountry : NSObject

@property ( nonatomic, assign ) NSUInteger countryId;
@property ( nonatomic, strong ) NSString* name;

+(NSArray*)defaultCountries;

@end
