#import "Stopwatch.h"

@interface Stopwatch ()

@property (nonatomic, retain) NSDate* startDate;

@end


@implementation Stopwatch

@synthesize name;
@synthesize runTime;
@synthesize startDate;

- (id) initWithName:(NSString*)_name
{
	if ((self = [super init])) {
		self.name = _name;
		runTime = 0;
	}
    
	return self;
}

- (void) start
{
	self.startDate = [NSDate date];
}

- (void) stop
{
	runTime += -[startDate timeIntervalSinceNow];
}

- (void) statistics
{
	NSLog(@"%@ finished in %f seconds.", name, runTime);
}

- (void) dealloc
{
	self.name = nil;
	self.startDate = nil;
    
	[super dealloc];
}


@end
