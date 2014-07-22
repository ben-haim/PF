
#import "IndBBDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndBBDataSource
@synthesize priceField, period, deviation;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.bb.apply", path]];
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.bb.interval", path]];  
    deviation = [properties getUIntParam:[NSString stringWithFormat:@"%@.bb.deviation", path]];  
    return self;
}


//called to do the first build based on the whole source vector
-(void)build
{        
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    ArrayMath* srcDataArr   = [src GetVector:priceField];
    
    ArrayMath *res1 = [[srcDataArr movStdDev:recalc_period] mul2:deviation];
    ArrayMath *res2 = [srcDataArr movAvg:recalc_period];
    
    [self SetVector:[res2 add:res1] forKey:@"indData1"];
    [self SetVector:[res2 sub:res1] forKey:@"indData2"];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* srcData = [src GetVector:priceField];
    ArrayMath* indData1 = [self GetVector:@"indData1"]; 
    ArrayMath* indData2 = [self GetVector:@"indData2"]; 
    
    int src_len = [srcData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [indData1 addElement:NAN];
            [indData2 addElement:NAN];

            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andIndData1:indData1 andIndData2:indData2];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andIndData1:indData1 andIndData2:indData2];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData1:(ArrayMath*)indData1 andIndData2:(ArrayMath*)indData2
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    int iStart = lastIndex - recalc_period - 1;
    if (iStart<0) iStart = 0;
    int iLen = recalc_period + 1;
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    
    ArrayMath *res1 = [[srcDataTrim movStdDev:recalc_period] mul2:deviation];
    ArrayMath *res2 = [srcDataTrim movAvg:recalc_period];
    
    
    [indData1 getData][lastIndex-1] = [res2 getData][iLen-1] + [res1 getData][iLen-1]; 
    [indData2 getData][lastIndex-1] = [res2 getData][iLen-1] - [res1 getData][iLen-1]; 
}
@end
