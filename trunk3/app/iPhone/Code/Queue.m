

#import "Queue.h"


@implementation NSMutableArray (QueueAdditions)
// Remove objects from the head
- (id)dequeue 
{
    if ([self count] == 0) 
	{
        return nil;
    }
    id queueObject = [[[self objectAtIndex:0] retain] autorelease];
    [self removeObjectAtIndex:0];
    return queueObject;
}

// Adds to the end of the array
- (void) enqueue:(id)anObject 
{
    [self addObject:anObject];
}
@end
