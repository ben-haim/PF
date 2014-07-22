#import "PFTableViewCategory.h"

#import <Foundation/Foundation.h>

@class PFMarketOperationViewController;

@protocol PFMarketOperation;

@interface PFTableViewCategory (MarketOperation)

+(id)stopLossCategoryWithController:( PFMarketOperationViewController* )controller_
                    marketOperation:( id< PFMarketOperation > )market_operation_
                          orderView:( BOOL )order_view_;

+(id)takeProfitCategoryWithController:( PFMarketOperationViewController* )controller_
                      marketOperation:( id< PFMarketOperation > )market_operation_
                            orderView:( BOOL )order_view_;

@end
