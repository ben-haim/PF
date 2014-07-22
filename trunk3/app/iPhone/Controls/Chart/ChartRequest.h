

#import <Foundation/Foundation.h>
#import "SymbolInfo.h"

@interface ChartRequest : NSObject 
{
	NSString *symbol;
	NSString *rangeType;
}

@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) NSString *rangeType;

@end
