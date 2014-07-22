#import "ADQueue.h"

#import "Detail/ADDispatchQueue.h"

id< ADQueue > ADCreateSequenceQueue( NSString* name_ )
{
   return [ ADDispatchQueue serialQueueWithName: name_ ];
}
