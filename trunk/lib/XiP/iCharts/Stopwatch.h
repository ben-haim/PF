#import <Foundation/Foundation.h>

@interface Stopwatch : NSObject {
	// Name to be used for logging
	NSString* name;
    
	// Total run time
	NSTimeInterval runTime;
    
	// The start date of the currently active run
	NSDate* startDate;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, readonly) NSTimeInterval runTime;

- (id) initWithName:(NSString*)name;

- (void) start;
- (void) stop;
- (void) statistics;

@end