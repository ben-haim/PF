#import "PFTableViewItem.h"

#import <Foundation/Foundation.h>

@class PFMarketOperationViewController;
@protocol PFMarketOperation;

@interface PFTableViewItem (MarketOperation)

@end

@interface NSArray (PFTableViewItem_MarketOperation)

+(id)arrayWithStopLossItemsWithPrice:( double )price_
                            slOffset:( double )sl_offset_
                          controller:( PFMarketOperationViewController* )controller_
                     marketOperation:( id< PFMarketOperation > )market_operation_;

+(id)arrayWithTakeProfitItemsForPrice:( double )price_
                           controller:( PFMarketOperationViewController* )controller_;

@end
