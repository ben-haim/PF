

#import "ChartRequest.h"


@implementation ChartRequest
@synthesize symbol, rangeType;

-(void) dealloc
{
	[symbol release];
	[rangeType release];
	[super dealloc];
}
@end
