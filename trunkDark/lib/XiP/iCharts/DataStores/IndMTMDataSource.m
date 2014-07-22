
#import "IndMTMDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndMTMDataSource
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
   recalc_period = ((period * 2) >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    ArrayMath* srcDataArr   = [src GetVector:priceField];    
    ArrayMath *dataShifted  = [srcDataArr shiftRight:recalc_period];
    ArrayMath *momentumData = [[srcDataArr safeDiv:dataShifted AndStub:1] mul2:100];  
    [self SetVector:momentumData forKey:@"indData"];   
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{    
    ArrayMath* srcData = [src GetVector:priceField];
    ArrayMath* indData = [self GetVector:@"indData"];    
    
    int src_len = [srcData getLength];
    if (src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [indData addElement:NAN];
            
            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andIndData:indData];
        }
    }
//    else
//    {
//        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andIndData:indData];
//    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData
{
    recalc_period = ((period * 2) >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    int iStart = lastIndex - 2*(recalc_period + 1);
    if (iStart < 0) iStart = 0;
    int iLen = 2*(recalc_period + 1);
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    
    ArrayMath *dataShifted      = [srcDataTrim shiftRight:recalc_period];
    ArrayMath *momentumData     = [[srcDataTrim safeDiv:dataShifted AndStub:1] mul2:100]; 
    
    [indData getData][lastIndex-1] = [momentumData getData][iLen-1];  
}
@end
