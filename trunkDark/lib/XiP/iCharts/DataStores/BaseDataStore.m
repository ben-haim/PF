
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


-(void)SetVector:(ArrayMath*)v forKey:(NSString*)name
{
    lastKey = name;
    dataSets[name] = v;
}
-(ArrayMath*)GetVector:(NSString*)name
{
    return dataSets[name];
}
-(uint)GetLength
{
    if(lastKey==nil) 
        return 0;
    else
        return [((ArrayMath*)dataSets[lastKey]) getLength];
}
-(void)Clear
{
    [dataSets removeAllObjects];
    dataSets = [[NSMutableDictionary alloc] init];
}
@end
