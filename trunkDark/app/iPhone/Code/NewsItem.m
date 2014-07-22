
#import "NewsItem.h"


@implementation NewsItem

@synthesize isRead;
@synthesize news_id;
@synthesize subject;
@synthesize category;
@synthesize description;
@synthesize date;


- (void)dealloc 
{
	[subject release];
	[category release];
	[description release];
	[date release];
	
	[super dealloc];
}

@end
