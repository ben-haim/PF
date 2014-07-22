

#import "AggragateTradeRecord.h"
#import "TickData.h"


@implementation AggragateTradeRecord

@synthesize type, profitMode, volSell, volBuy, buyOrdersCount, sellOrdersCount, avgOpenSell, avgOpenBuy, avgCloseSell, avgCloseBuy, digits, conv1, conv2, sellPrices, buyPrices, askPrice, bidPrice;

- (id)init 
{
    self = [super init];
    if (self) {
        self.profit = 0;
        self.volSell = 0;
        self.volBuy = 0;
        self.commission = 0;
        self.storage = 0;
        self.buyOrdersCount = 0;
        self.sellOrdersCount = 0;
        self.avgOpenSell = 0;
        self.avgOpenBuy = 0;
        self.digits = 0;
        self.profitMode = 0;
        
        self.conv1 = nil;
        self.conv2 = nil;
        
        self.sellPrices = 0;
        self.buyPrices = 0;
        
        self.askPrice = 0;
        self.bidPrice = 0;
		
		buyPrices = [[NSMutableDictionary alloc] init];
		sellPrices = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
	[buyPrices release];
	[sellPrices release];
	[super dealloc];
}

- (void)putOpenBuyPrice:(double)price withVolume:(double)lVolume
{
    NSNumber *priceObject = [NSNumber numberWithDouble:price];
    NSNumber *volumeEntry = nil;
    if ([buyPrices objectForKey:priceObject])
    {
        volumeEntry = [buyPrices objectForKey:priceObject];
        volumeEntry = [NSNumber numberWithDouble:([volumeEntry doubleValue] + lVolume)];
    }
    else
    {
        volumeEntry = [NSNumber numberWithDouble:lVolume];        
    }
    [buyPrices setObject:volumeEntry forKey:priceObject];
}

- (void)putOpenSellPrice:(double)price withVolume:(double)lVolume
{
    NSNumber *priceObject = [NSNumber numberWithDouble:price];
    NSNumber *volumeEntry = nil;
    if ([sellPrices objectForKey:priceObject])
    {
        volumeEntry = [sellPrices objectForKey:priceObject];
        volumeEntry = [NSNumber numberWithDouble:([volumeEntry doubleValue] + lVolume)];
    }
    else
    {
        volumeEntry = [NSNumber numberWithDouble:lVolume];        
    }
    [sellPrices setObject:volumeEntry forKey:priceObject];
}

- (void)calculateSellWeightedAverage
{
    NSArray *prices = [sellPrices allKeys];
    double sumValues = 0;
    double sumVolumes = 0;
    for (int i=0; i<[sellPrices count]; ++i)
    {
        NSNumber *sellPriceKey = [prices objectAtIndex:i];
        NSNumber *sellPrice = [sellPrices objectForKey:sellPriceKey];
        
        sumValues += ([sellPrice doubleValue] * [sellPriceKey doubleValue]);
        sumVolumes += [sellPrice doubleValue];
    }
    if (sumValues != 0)
    {
        avgOpenSell = sumValues / sumVolumes;
    }
    else
    {
        avgOpenSell = 0;
    }
}

- (void)calculateBuyWeightedAverage
{
    NSArray *prices = [buyPrices allKeys]; NSLog(@"prices count: %d", [prices count]);
    double sumValues = 0;
    double sumVolumes = 0;
    for (int i=0; i<[prices count]; ++i)
    {
        NSNumber *buyPriceKey = [prices objectAtIndex:i];
        NSNumber *buyPrice = [buyPrices objectForKey:buyPriceKey];
        
        sumValues += ([buyPrice doubleValue] * [buyPriceKey doubleValue]);
        sumVolumes += [buyPrice doubleValue];
    }
    if (sumValues != 0)
    {
        avgOpenBuy = sumValues / sumVolumes;
		NSLog(@"%f", avgOpenBuy);
    }
    else
    {
        avgOpenBuy = 0;
    }
}

- (void)calculateWeightedAverage
{
    [self calculateSellWeightedAverage];
    [self calculateBuyWeightedAverage];
}

- (double)conversionRate:(BOOL)isBuy withParamsStorage:(ParamsStorage*)paramStorage
{
    double rate = 1;
    double rate2 = 1;
    
    if (conv1 == nil || conv1.Constant)
    {
        return 1;
    }
    
    double price = 0;
    TickData *td = [[paramStorage Prices] objectForKey:conv1.Pair];
    price = (isBuy) ? [td.Bid doubleValue] : [td.Ask doubleValue];
    
    if (![conv1 IsEmpty]) 
    {
        if ([conv1 ReversePrevious])
        {
            rate = 1 /price;
        }
        if ([conv1 Divide])
        {
            rate = 1 / price;
        }
        else
        {
            rate = price;
        }
    }
    
    if (conv2 == nil || conv1.Constant || [conv2 IsEmpty])
    {
        return rate;
    }
    
    td = [[paramStorage Prices] objectForKey:conv2.Pair];
    price = (isBuy) ? [td.Bid doubleValue] : [td.Ask doubleValue];
    
    if ([conv2 ReversePrevious])
    {
        rate2 = 1 /price;
    }
    if ([conv2 Divide])
    {
        rate2 = 1 / price;
    }
    else
    {
        rate2 = price;
    }

    return rate * rate2;
}

- (void)updateProfit:(ParamsStorage*)paramStorage
{
    TickData *td = [[paramStorage Prices] objectForKey:self.symbol];
    SymbolInfo *si = [[paramStorage Symbols] objectForKey:self.symbol];
    
    double closeBidPrice = [td.Bid doubleValue];
    double closeAskPrice = [td.Ask doubleValue];
	
	//NSLog(@"ask: %f", askPrice);
    
    if (closeBidPrice == bidPrice && volSell == 0) 
    {
        return;        
    }
    if (closeAskPrice == askPrice && volBuy == 0)
    {
        return;
    }
    if (closeBidPrice == bidPrice && closeAskPrice == askPrice)
    {
        return;
    }
    
    askPrice = closeAskPrice;
    bidPrice = closeBidPrice;
    
    double contract = si.ContractSize;
    double buyConversion = [self conversionRate:YES withParamsStorage:paramStorage];
    double sellConversion = [self conversionRate:NO withParamsStorage:paramStorage]; 
    
    double subqBidFromAvg = [td.Bid doubleValue] - avgOpenBuy;
    double subqAvgFromAsk = avgOpenSell - [td.Ask doubleValue];
    
    switch (profitMode)
    {
        case 0: //Forex
        case 1:
            self.profit = ( (volBuy * subqBidFromAvg * buyConversion) + (volSell * subqAvgFromAsk * sellConversion) ) * contract;
            break;
        case 2:
            self.profit = (si.TickValue / si.TickSize) * ( (volBuy * subqBidFromAvg * buyConversion) + (volSell * subqAvgFromAsk * sellConversion) );
            break;
        default:
            break;
    }
}

@end
