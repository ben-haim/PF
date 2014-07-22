//
//  IndDMIDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 05/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndDMIDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndDMIDataSource
@synthesize period;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.adx.interval", path]];    
    return self;
}

- (ArrayMath*)computeTrueRange:(ArrayMath*)closeData 
                             h:(ArrayMath*)highData
                             l:(ArrayMath*)lowData
{
    ArrayMath* closedDataShifted = [closeData shiftRight:1];
    double* cdShifted = [closedDataShifted getData];
    ArrayMath* res = [highData sub:lowData];
    double *resRaw = [res getData];
    
    int src_len = [closeData getLength];
    int i = 0;

    while (i < src_len) 
    {
        if (!isnan(resRaw[i]) && !isnan(cdShifted[i]))
        {
            resRaw[i] = MAX(resRaw[i], fabs([highData getData][i] - cdShifted[i]));
            resRaw[i] = MAX(resRaw[i], fabs(cdShifted[i] - [lowData getData][i]));
        }
        i++;
    }
    return res;
}		


//called to do the first build based on the whole source vector
-(void)build
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 3) : period;
   
    ArrayMath *trueRange	= [self computeTrueRange:[src GetVector:@"closeData"] 
                                                    h:[src GetVector:@"highData"] 
                                                    l:[src GetVector:@"lowData"]];
    
    ArrayMath *diPlusData_m 	= [[[src GetVector:@"highData"] delta:1] selectGTZ:0];
    ArrayMath *diMinusData_m 	= [[[[src GetVector:@"lowData"] delta:1] mul2:-1] selectGTZ:0];  
    
    ArrayMath *diPlusData	 	= [[[[diPlusData_m selectGT:diMinusData_m AndStub:0] mul2:100] safeDiv:trueRange AndStub:0] expAvg:(2.0 / (recalc_period + 1))];
    ArrayMath *diMinusData      = [[[[diMinusData_m selectGT:diPlusData_m AndStub:0] mul2:100] safeDiv:trueRange AndStub:0] expAvg:(2.0 / (recalc_period + 1))];
    
    ArrayMath *diDeltaData 	= [diPlusData add:diMinusData];
    ArrayMath *adxData 		= [[[[[diPlusData sub:diMinusData] abs] safeDiv:diDeltaData AndStub:0] mul2:100] expAvg:(2.0 / (recalc_period + 1))];
    
    [self SetVector:diPlusData forKey:@"diPlusData"];
    [self SetVector:diMinusData forKey:@"diMinusData"];
    [self SetVector:adxData forKey:@"adxData"];
    
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* closeData = [src GetVector:@"closeData"];
    ArrayMath* diPlusData1 = [self GetVector:@"diPlusData"];
    ArrayMath* diMinusData1 = [self GetVector:@"diMinusData"];
    ArrayMath* adxData1 = [self GetVector:@"adxData"];
    
    int src_len = [closeData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [diPlusData1 addElement:NAN];
            [diMinusData1 addElement:NAN];
            [adxData1 addElement:NAN];
            
            [self SourceDataProcedureWithLastIndex:lastIndex andCloseData:closeData andDiPlusData:diPlusData1 andDiMinusData:diMinusData1 andAdxData1:adxData1];
        }        
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andCloseData:closeData andDiPlusData:diPlusData1 andDiMinusData:diMinusData1 andAdxData1:adxData1];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andCloseData:(ArrayMath*)closeDataData andDiPlusData:(ArrayMath*)diPlusData1 andDiMinusData:(ArrayMath*)diMinusData1 andAdxData1:(ArrayMath*)adxData1
{
    recalc_period = (period >= [src GetLength]) ? ([src GetLength] - 3) : period;
   
    int iStart = lastIndex - recalc_period - 3;
    int iLen = recalc_period + 3;
    
    ArrayMath* highDataTrim 	= [[src GetVector:@"highData"] trim:iStart AndLength:iLen];
    ArrayMath* lowDataTrim       = [[src GetVector:@"lowData"] trim:iStart AndLength:iLen];
    ArrayMath* closeDataTrim    = [[src GetVector:@"closeData"] trim:iStart AndLength:iLen];
    
    ArrayMath *trueRange	= [self computeTrueRange:closeDataTrim 
                                                h:highDataTrim 
                                                l:lowDataTrim];
    
    ArrayMath *diPlusData_m 	= [[highDataTrim delta:1] selectGTZ:0];
    ArrayMath *diMinusData_m 	= [[[lowDataTrim delta:1] mul2:-1] selectGTZ:0];  
    
    ArrayMath *diPlusData	 	= [[[[diPlusData_m selectGT:diMinusData_m AndStub:0] mul2:100] safeDiv:trueRange AndStub:0] expAvg:(2.0 / (recalc_period + 1))];
    ArrayMath *diMinusData      = [[[[diMinusData_m selectGT:diPlusData_m AndStub:0] mul2:100] safeDiv:trueRange AndStub:0] expAvg:(2.0 / (recalc_period + 1))];
    
    ArrayMath *diDeltaData 	= [diPlusData add:diMinusData];
    ArrayMath *adxData 		= [[[[[diPlusData sub:diMinusData] abs] safeDiv:diDeltaData AndStub:0] mul2:100] expAvg:(2.0 / (recalc_period + 1))];
    
    
    [diPlusData1 getData][lastIndex-1]    = [diPlusData getData][iLen-1]; 
    [diMinusData1 getData][lastIndex-1]   = [diMinusData getData][iLen-1]; 
    [adxData1 getData][lastIndex-1]       = [adxData getData][iLen-1]; 
}
@end
