
#import "IndSMADataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"

@implementation IndSMADataSource
@synthesize priceField, period;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self  = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.apply", path]];
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.interval", path]];    
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
   recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    ArrayMath* arrRes = [src GetVector:priceField];
    ArrayMath* r = [arrRes movAvg:recalc_period];
    [self SetVector:r forKey:@"indData"];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* srcData = [src GetVector:priceField];
    ArrayMath* indData = [self GetVector:@"indData"];

    int src_len = [srcData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [indData addElement:NAN];
            [self SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:(int)src_len andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData];
    }    
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    int iStart = lastIndex - recalc_period - 1;
    int iLen = recalc_period + 1;
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    
    ArrayMath* res = [srcDataTrim movAvg:recalc_period];
    double lastValue = [res getData][iLen-1];
    [indData getData][lastIndex-1] = lastValue; 
}

@end
