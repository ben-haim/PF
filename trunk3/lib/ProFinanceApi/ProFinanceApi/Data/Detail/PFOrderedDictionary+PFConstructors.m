#import "PFOrderedDictionary+PFConstructors.h"

@implementation PFOrderedDictionary (PFConstructors)

+(id)dictionaryWithOrders:( NSArray* )orders_
{
   NSArray* ids_ = [ orders_ valueForKeyPath: @"@unionOfObjects.orderId" ];
   return [ PFMutableOrderedDictionary orderedDictionaryWithObjects: orders_ keys: ids_ ];
}

+(id)dictionaryWithTrades:( NSArray* )trades_
{
   NSArray* ids_ = [ trades_ valueForKeyPath: @"@unionOfObjects.tradeId" ];
   return [ PFMutableOrderedDictionary orderedDictionaryWithObjects: trades_ keys: ids_ ];
}

+(id)dictionaryWithPositions:( NSArray* )positions_
{
   NSArray* ids_ = [ positions_ valueForKeyPath: @"@unionOfObjects.positionId" ];
   return [ PFMutableOrderedDictionary orderedDictionaryWithObjects: positions_ keys: ids_ ];
}

@end
