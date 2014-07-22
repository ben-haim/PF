
#import <Foundation/Foundation.h>


@interface MySingleton : NSObject {
	NSString *chartInterval;
}

@property (nonatomic, retain) NSString *chartInterval;

+(MySingleton*) sharedMySingleton;
-(UIColor*) tabColor;
-(UIColor*) segmentedColor;

@end
