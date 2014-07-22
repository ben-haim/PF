#import "PFOrderedDictionary.h"

#import <Foundation/Foundation.h>

@interface PFOrderedDictionary (PFConstructors)

+(id)dictionaryWithOrders:( NSArray* )orders_;
+(id)dictionaryWithTrades:( NSArray* )trades_;
+(id)dictionaryWithPositions:( NSArray* )positions_;

@end
