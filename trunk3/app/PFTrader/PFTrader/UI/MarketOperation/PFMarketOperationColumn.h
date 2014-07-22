#import "PFConcreteColumn.h"

#import <Foundation/Foundation.h>

@interface PFMarketOperationColumn : PFConcreteColumn

+(id)symbolColumn;
+(id)quantityColumn;

+(id)slColumn;
+(id)tpColumn;

+(id)typeColumn;
+(id)accountColumn;
+(id)tifColumn;
+(id)instrumentTypeColumn;
+(id)boughtSoldColumn;

+(id)orderIdColumn;

@end
