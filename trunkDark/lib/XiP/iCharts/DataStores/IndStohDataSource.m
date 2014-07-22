//
//  IndStohDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 05/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndStohDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"

@implementation IndStohDataSource
@synthesize k_period, d_period, smoothing;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    k_period = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_k.interval", path]];    
    d_period = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_d.interval", path]];     
    smoothing = [properties getUIntParam:[NSString stringWithFormat:@"%@.perc_k.slowing", path]];  
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{   
    int k_period2 = k_period >= [src GetLength] ? [src GetLength] - 1 : k_period;
    int d_period2 = d_period >= [src GetLength] ? [src GetLength] - 1 : d_period;
   
    ArrayMath* src_data = [src GetVector:@"closeData"];
    
    ArrayMath* dataLowestLow = [[src GetVector:@"lowData"] movMin:k_period2];
    ArrayMath* dataHHMinusLL = [[[src GetVector:@"highData"] movMax:k_period2] sub:dataLowestLow];
    ArrayMath* dataK = [[[[src_data sub:dataLowestLow] div:dataHHMinusLL] mul2:100] movAvg:smoothing];
    ArrayMath* dataD = [dataK movAvg:d_period2];
    
    
    [self SetVector:dataK forKey:@"dataK"];
    [self SetVector:dataD forKey:@"dataD"];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* srcData = [src GetVector:@"closeData"];
    ArrayMath* dataK = [self GetVector:@"dataK"];
    ArrayMath* dataD = [self GetVector:@"dataD"];

    int src_len = [srcData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [dataK addElement:NAN];
            [dataD addElement:NAN];
            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andKData:dataK andDData:dataD];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andKData:dataK andDData:dataD];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andKData:(ArrayMath*)dataK andDData:(ArrayMath*)dataD
{
    int period = 2*MAX(smoothing, MAX(k_period, d_period));//chose the longest one
   
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 1) : period;
    k_period = (k_period >= [src GetLength]) ? ([src GetLength] - 1) : k_period;
    d_period = (d_period >= [src GetLength]) ? ([src GetLength] - 1) : d_period;
    
    int iStart = lastIndex - recalc_period - 1;
    int iLen = recalc_period + 1;
    ArrayMath* srcDataTrim = [srcData trim:iStart AndLength:iLen];
    ArrayMath* srcDataLowTrim = [[src GetVector:@"lowData"] trim:iStart AndLength:iLen];
    ArrayMath* srcDataHighTrim = [[src GetVector:@"highData"] trim:iStart AndLength:iLen];    
    
    ArrayMath* dataLowestLow 	= [srcDataLowTrim movMin:k_period];
    ArrayMath* dataHHMinusLL 	= [[srcDataHighTrim movMax:k_period] sub:dataLowestLow];
    ArrayMath* dataKtemp 		= [[[[srcDataTrim sub:dataLowestLow] div:dataHHMinusLL] mul2:100] movAvg:smoothing];
    ArrayMath* dataDtemp 		= [dataKtemp movAvg:d_period];
    
    
    [dataK getData][lastIndex-1] = [dataKtemp getData][iLen-1]; 
    [dataD getData][lastIndex-1] = [dataDtemp getData][iLen-1]; 
}
@end
