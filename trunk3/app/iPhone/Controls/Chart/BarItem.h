
#import <Foundation/Foundation.h>


@interface BarItem : NSObject 
{
	double open;
	double close;
	double high;
	double low;
	NSDate *dat;
}
@property (nonatomic, retain) NSDate *dat;
@property (assign) double open;
@property (assign) double close;
@property (assign) double high;
@property (assign) double low;
@end
