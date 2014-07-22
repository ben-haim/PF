
#import "IncomingChartInfo.h"


@implementation IncomingChartInfo
@synthesize symbol, chart;

-(void) dealloc
{
	//NSLog(@"IncomingChartInfo dealloc\n");
	[symbol release];
	[chart release];
	[super dealloc];
}
@end
