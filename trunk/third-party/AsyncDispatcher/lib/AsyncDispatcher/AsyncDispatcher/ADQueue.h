#import "Detail/ADExport.h"

#import "ADBlockDefs.h"

#import <Foundation/Foundation.h>

@protocol ADQueue <NSObject>

-(void)async:( ADQueueBlock )block_;
-(void)cancel;

@end

AD_EXPORT id< ADQueue > ADCreateSequenceQueue( NSString* name_ );