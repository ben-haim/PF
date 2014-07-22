
#import <Foundation/Foundation.h>


@interface ListEntry : NSObject {
	NSString *alias;
	NSString *value;
	NSString *filter;
}

@property(assign) NSString *alias;
@property(assign) NSString *value;
@property(assign) NSString *filter;

+ (id)initWithAlias:(NSString *)alias withValue:(NSString *)value withFilter:(NSString *)filter;
+ (id)initWithAlias:(NSString *)alias withValue:(NSString *)value;
@end
