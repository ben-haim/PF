

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAdditions) 

- (id) dequeue;
- (void) enqueue:(id)obj;

@end
