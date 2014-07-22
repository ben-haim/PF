
#import <Foundation/Foundation.h>
#import <XiPFramework/HLOCDataSource.h>

@interface IncomingChartInfo : NSObject 
{
	NSString *symbol;
	HLOCDataSource *chart;
}

@property ( retain, nonatomic) NSString *symbol;
@property ( retain, nonatomic) HLOCDataSource *chart;
@end
