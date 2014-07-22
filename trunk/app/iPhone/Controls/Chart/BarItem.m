
#import "BarItem.h"


@implementation BarItem
@synthesize open, close, high, low, dat;

-(void)dealloc
{
	if(dat!=nil)
		[dat release];
	dat = nil;
	[super dealloc];
}

@end
