
#import "IndEMADataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"

@implementation IndEMADataSource
@synthesize priceField, period;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.apply", path]];
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.interval", path]];    
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
    ArrayMath* arrRes = [src GetVector:priceField];
    ArrayMath* r = [arrRes expAvg:2.0 / (period + 1.0)];
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
            
            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andIndData:indData];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andIndData:indData];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData;
{
    double* indDataRaw = [indData getData];
    
    double multiplier = 2 / (period + 1.0);
    double lastPrice = [srcData getData][lastIndex-1];
    indDataRaw[lastIndex - 1] = (lastPrice - indDataRaw[lastIndex - 2]) * multiplier + indDataRaw[lastIndex - 2];
}
@end
