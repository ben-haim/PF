//
//  IndWillDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndWillDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndWillDataSource
@synthesize period;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.interval", path]];  
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
   recalc_period = period >= [src GetLength] ? [src GetLength] - 1 : period;
   
    ArrayMath* dataHighestHigh = nil;	//highest high
    ArrayMath* dataLowestLow = nil;		//lowest low
    ArrayMath* dataHHMinusLL = nil;		//highest high -lowest low
    ArrayMath* dataWilliams = nil;		//(MAX (HIGH (i - n)) - CLOSE (i)) / (MAX (HIGH (i - n)) - MIN (LOW (i - n))) * 100

    
    dataHighestHigh     = [[src GetVector:@"highData"] movMax:recalc_period];
    dataLowestLow       = [[src GetVector:@"lowData"] movMin:recalc_period];
    dataHHMinusLL       = [dataHighestHigh sub:dataLowestLow];
    dataWilliams        = [[[dataHighestHigh sub:[src GetVector:@"closeData"]] div:dataHHMinusLL] mul2:-100];	
    [self SetVector:dataWilliams forKey:@"indData"];
    
    
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    ArrayMath* closeData = [src GetVector:@"closeData"];
    ArrayMath* lowData = [src GetVector:@"lowData"];
    ArrayMath* highData = [src GetVector:@"highData"];
    ArrayMath* indData = [self GetVector:@"indData"];
    
    int src_len = [closeData getLength];
    if(src_len > [self GetLength])
    {
        while (src_len > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [indData addElement:NAN];
            
            [self SourceDataProcedureWithLastIndex:lastIndex andCloseData:closeData andLowData:lowData andHighData:highData andIndData:indData];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andCloseData:closeData andLowData:lowData andHighData:highData andIndData:indData];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andCloseData:(ArrayMath*)closeData andLowData:(ArrayMath*)lowData andHighData:(ArrayMath*)highData andIndData:(ArrayMath*)indData
{
    recalc_period = period >= [src GetLength] ? [src GetLength] - 1 : period;
   
    int iStart = lastIndex - recalc_period - 1;
    int iLen = recalc_period + 1;
    
    ArrayMath* closeDataTrim = [closeData trim:iStart AndLength:iLen];
    ArrayMath* lowDataTrim = [lowData trim:iStart AndLength:iLen];
    ArrayMath* highDataTrim = [highData trim:iStart AndLength:iLen];
    
    ArrayMath* dataHighestHigh = nil;	//highest high
    ArrayMath* dataLowestLow = nil;		//lowest low
    ArrayMath* dataHHMinusLL = nil;		//highest high -lowest low
    ArrayMath* dataWilliams = nil;		//(MAX (HIGH (i - n)) - CLOSE (i)) / (MAX (HIGH (i - n)) - MIN (LOW (i - n))) * 100
    
    
    dataHighestHigh     = [highDataTrim movMax:recalc_period];
    dataLowestLow       = [lowDataTrim movMin:recalc_period];
    dataHHMinusLL       = [dataHighestHigh sub:dataLowestLow];
    dataWilliams        = [[[dataHighestHigh sub:closeDataTrim] div:dataHHMinusLL] mul2:-100];	
    
    
    [indData getData][lastIndex-1] = [dataWilliams getData][iLen-1];   
}

@end
