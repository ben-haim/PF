#import "PFMarketOperationColumn.h"

#import <Foundation/Foundation.h>

@interface PFPositionColumn : PFMarketOperationColumn

+(id)netPlColumn;
+(id)grossPlColumn;
+(id)commissionColumn;
+(id)slColumn;
+(id)tpColumn;
+(id)accountColumn;
+(id)expirationDateColumn;

@end
