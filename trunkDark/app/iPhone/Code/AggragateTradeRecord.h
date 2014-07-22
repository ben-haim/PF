
#import <Foundation/Foundation.h>
#import "TradeRecord.h"
#import "Conversion.h"
#import "ParamsStorage.h"


enum AggregateOrderType
{
    AGGREGATE_ORDER_TYPE_INSTANT,
    AGGREGATE_ORDER_TYPE_PENDING,
    
    AGGREGATE_ORDER_TYPE_TOTAL
};

@interface AggragateTradeRecord : TradeRecord 
{
	
}

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int profitMode;
@property (nonatomic, assign) double volSell;
@property (nonatomic, assign) double volBuy;
@property (nonatomic, assign) int buyOrdersCount;
@property (nonatomic, assign) int sellOrdersCount;
@property (nonatomic, assign) double avgOpenSell;
@property (nonatomic, assign) double avgOpenBuy;
@property (nonatomic, assign) double avgCloseSell;
@property (nonatomic, assign) double avgCloseBuy;
@property (nonatomic, assign) int digits;

@property (nonatomic, assign) Conversion *conv1;
@property (nonatomic, assign) Conversion *conv2;

@property (nonatomic, assign) NSMutableDictionary *sellPrices;
@property (nonatomic, assign) NSMutableDictionary *buyPrices;

@property (nonatomic, assign) double askPrice;
@property (nonatomic, assign) double bidPrice;

- (void)putOpenBuyPrice:(double)price withVolume:(double)volume;
- (void)putOpenSellPrice:(double)price withVolume:(double)volume;

- (void)calculateWeightedAverage;
- (void)updateProfit:(ParamsStorage*)paramStorage;

@end
