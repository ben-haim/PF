//
//  IndENVDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndENVDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndENVDataSource
@synthesize priceField, period, deviation;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path 
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.env.apply", path]];
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.env.interval", path]];  
    deviation = [properties getUIntParam:[NSString stringWithFormat:@"%@.env.deviation", path]]/1000.0;  
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    ArrayMath* srcData   = [src GetVector:priceField];
    
    ArrayMath *envLower = [[srcData movAvg:recalc_period] mul2:(1-deviation)];
    ArrayMath *envUpper = [[srcData movAvg:recalc_period] mul2:(1+deviation)];

    [self SetVector:envLower forKey:@"envLower"];
    [self SetVector:envUpper forKey:@"envUpper"];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* srcData = [src GetVector:priceField];
    ArrayMath* envLower = [self GetVector:@"envLower"]; 
    ArrayMath* envUpper = [self GetVector:@"envUpper"];
    
    int src_len = [srcData getLength];
    if(src_len> [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [envLower addElement:NAN];
            [envUpper addElement:NAN];
            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andEnvLowerData:envLower andEnvUpperData:envUpper];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andEnvLowerData:envLower andEnvUpperData:envUpper];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andEnvLowerData:(ArrayMath*)envLower andEnvUpperData:(ArrayMath*)envUpper
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
   
    int iStart = lastIndex - recalc_period - 1;
    int iLen = recalc_period + 1;
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    
    ArrayMath *resLower = [[srcDataTrim movAvg:recalc_period] mul2:(1-deviation)];
    ArrayMath *resUpper = [[srcDataTrim movAvg:recalc_period] mul2:(1+deviation)];
    
    
    [envLower getData][lastIndex-1] = [resLower getData][iLen-1]; 
    [envUpper getData][lastIndex-1] = [resUpper getData][iLen-1]; 
}
@end
