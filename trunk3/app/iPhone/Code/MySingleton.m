
#import "MySingleton.h"
#import "ParamsStorage.h"

@implementation MySingleton

@synthesize chartInterval;

static MySingleton* _sharedMySingleton = nil;

+(MySingleton*) sharedMySingleton
{
	@synchronized([MySingleton class])
	{
		if (!_sharedMySingleton) [[self alloc] init];
		return _sharedMySingleton;
	}
	return nil;
}

+(id) alloc
{
	@synchronized([MySingleton class])
	{
		NSAssert(_sharedMySingleton == nil, @"Attempted to allocate a second instance of singleton.");
		_sharedMySingleton = [super alloc];
		return _sharedMySingleton;
	}
	return nil;
}

-(id) init
{
	self = [super init];
	if (self != nil) 
	{
		
	}
	return self;
}

-(UIColor*) tabColor
{
	return [UIColor blackColor];
}

-(UIColor*) segmentedColor
{
	return [UIColor darkGrayColor];
}

@end