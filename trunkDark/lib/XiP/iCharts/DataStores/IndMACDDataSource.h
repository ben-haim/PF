
#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndMACDDataSource : IndDataSource 
{
    NSString *priceField;
    uint sma_period;
    uint ema1;
    uint ema2;
}
@property (nonatomic, strong) NSString *priceField;
@property (assign) uint sma_period;
@property (assign) uint ema1;
@property (assign) uint ema2;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andEmaData:(ArrayMath*)emaData andSmaData:(ArrayMath*)smaData andDivData:(ArrayMath*)divData;

@end
