
#import "BaseDataStore.h"
#import "ArrayMath.h"


@implementation BaseDataStore
@synthesize dataSets, lastKey;

- (id)init 
{
    self = [super init];
    if(self == nil)
        return self;
    
    dataSets = [[NSMutableDictionary alloc] init];
    lastKey = nil;
    return self;
}

-(void)dealloc
{
	if(lastKey!=nil)
		[lastKey release];
	lastKey = nil;
    [dataSets release];
	[super dealloc];
}

-(void)SetVector:(ArrayMath*)v forKey:(NSString*)name
{
    lastKey = name;
    [dataSets setObject:v forKey:name];
}
-(ArrayMath*)GetVector:(NSString*)name
{
    return [dataSets objectForKey:name];
}
-(uint)GetLength
{
    if(lastKey==nil) 
        return 0;
    else
        return [((ArrayMath*)[dataSets objectForKey:lastKey]) getLength];
}
-(void)Clear
{
    [dataSets removeAllObjects];
    [dataSets release];
    dataSets = [[NSMutableDictionary alloc] init];
}
@end
