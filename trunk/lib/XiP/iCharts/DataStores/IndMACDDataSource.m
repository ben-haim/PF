
#import "IndMACDDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"

@implementation IndMACDDataSource
@synthesize priceField, sma_period, ema1, ema2;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.macd.apply", path]];
    NSLog(@"macd apply to %@", priceField);
    sma_period = [properties getUIntParam:[NSString stringWithFormat:@"%@.sma.interval", path]]; 
    ema1 = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema1.interval", path]];  
    ema2 = [properties getUIntParam:[NSString stringWithFormat:@"%@.ema2.interval", path]];       
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{			
    ArrayMath* srcData = [src GetVector:priceField];
    
    ArrayMath* ema1Data = [srcData expAvg:2.0/(ema2 + 1)];
    ArrayMath* emaData = [[srcData expAvg:2.0/(ema1 + 1)] sub:ema1Data];
    ArrayMath* smaData = [emaData movAvg:sma_period];
    ArrayMath* divData = [smaData sub:emaData];  
    
    [self SetVector:emaData forKey:@"indMACD"];
    [self SetVector:smaData forKey:@"indSMA"];
    [self SetVector:divData forKey:@"indDiv"];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* srcData = [src GetVector:priceField];
    ArrayMath* emaData = [self GetVector:@"indMACD"];
    ArrayMath* smaData = [self GetVector:@"indSMA"];
    ArrayMath* divData = [self GetVector:@"indDiv"];
    
    int src_len = [srcData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [emaData addElement:NAN];
            [smaData addElement:NAN];
            [divData addElement:NAN];	

            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andEmaData:emaData andSmaData:smaData andDivData:divData];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andEmaData:emaData andSmaData:smaData andDivData:divData];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andEmaData:(ArrayMath*)emaData andSmaData:(ArrayMath*)smaData andDivData:(ArrayMath*)divData
{
    int period = 2*MAX(sma_period, MAX(ema1, ema2));//choose the longest one
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
    
    int iStart = lastIndex - recalc_period - 1;
    int iLen = recalc_period + 1;
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    
    ArrayMath*  temp_ema1Data   = [srcDataTrim expAvg:2.0/(ema2 + 1)];
    ArrayMath*  temp_emaData    = [[srcDataTrim expAvg:2.0/(ema1 + 1)] sub:temp_ema1Data];
    ArrayMath*  temp_smaData    = [temp_emaData movAvg:sma_period];
    ArrayMath*  temp_divData    = [temp_smaData sub:temp_emaData]; 
    
    
    [emaData getData][lastIndex-1] = [temp_emaData getData][iLen-1];     
    [smaData getData][lastIndex-1] = [temp_smaData getData][iLen-1];
    [divData getData][lastIndex-1] = [temp_divData getData][iLen-1];
}
@end
