

#import "ListEntry.h"


@implementation ListEntry
@synthesize alias, value, filter;

+ (id)initWithAlias:(NSString *)lAlias withValue:(NSString *)lValue withFilter:(NSString *)lFilter
{
	id newInstance = [[[self class] alloc] init];
	[newInstance setAlias:lAlias];
	[((ListEntry *)newInstance)setValue:lValue];
	[newInstance setFilter:lFilter];
	
	return [newInstance autorelease];
}

+ (id)initWithAlias:(NSString *)lAlias withValue:(NSString *)lValue
{
	id newInstance = [[[self class] alloc] init];
	[newInstance setAlias:lAlias];
	[((ListEntry *)newInstance)setValue:lValue];
	[newInstance setFilter:@""];
	
	return [newInstance autorelease];
}

- (NSString *)description
{
	return alias;
}
@end
