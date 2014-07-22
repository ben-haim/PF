#import "PFRequestDoneBlock.h"

#import <Foundation/Foundation.h>

@interface PFRequestHandler : NSObject

@property ( nonatomic, copy ) PFRequestDoneBlock doneBlock;

@end
