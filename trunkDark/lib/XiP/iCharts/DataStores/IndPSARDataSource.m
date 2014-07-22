//
//  IndPSARDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 03/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndPSARDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndPSARDataSource
@synthesize maxStepPeriod, stepPeriod, lastEP, lastChange;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self  = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    stepPeriod = [properties getDblParam:[NSString stringWithFormat:@"%@.step", path]];
    maxStepPeriod = [properties getDblParam:[NSString stringWithFormat:@"%@.max", path]];    
    lastChange = 0;
    lastEP = NAN;
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
    [self CalculateData:0];
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    [self CalculateData:lastChange+1];
}

-(void)CalculateData:(int)fromIndex
{
    int srclen = [src GetLength];
    if([self GetLength]==0)
    {
        [self SetVector:[[ArrayMath alloc] initWithLength:srclen] forKey:@"sarData"];
        [self SetVector:[[ArrayMath alloc] initWithLength:srclen] forKey:@"loc2"];        
    }
    
    int thislen = [self GetLength];
    if(srclen > thislen)
    {
        while (srclen > [self GetLength])
        {
            int lastIndex = [self GetLength];
            [[self GetVector:@"loc2"] addElement:NAN];
            [[self GetVector:@"sarData"] addElement:NAN];
            
            [self SourceDataProcedureWithLastIndex:lastIndex andFromIndex:fromIndex andSrcLength:srclen];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:srclen andFromIndex:fromIndex andSrcLength:srclen];
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andFromIndex:(int)fromIndex andSrcLength:(int)srclen
{
    double curSAR = NAN;
    double EP = 0;
    double AF = NAN;
    
    double* loc2 = [[self GetVector:@"loc2"] getData];   
    double* sarData = [[self GetVector:@"sarData"] getData];  
    //
    
    double* closeData = [[src GetVector:@"closeData"] getData];    
    double* lowData = [[src GetVector:@"lowData"] getData];    
    double* highData = [[src GetVector:@"highData"] getData];
    
    if (lastIndex > 2)
    {
        if (fromIndex != 0)
        {
            EP = lastEP;
        }
        else if (closeData[1] >= lowData[0])
        {
            loc2[0] = 1;
            loc2[1] = 1;
            
            double low = MIN(lowData[0], lowData[1]);
            
            sarData[0] = low;
            sarData[1] = low;
            
            EP = highData[0] > highData[1] ? highData[0] : highData[1];
        }
        else 
        {
            loc2[0] = -1;
            loc2[1] = -1;
            
            double high = MAX(highData[0], highData[1]);
            
            sarData[0] = high;
            sarData[1] = high;
            
            EP = lowData[0] > lowData[1] ? lowData[1] : lowData[0];
        }
        
        AF = stepPeriod;
        
        int i = (fromIndex == 0) ? 2 : fromIndex;	
        while (i < srclen) 
        {				
            if (loc2[i - 1] != 1)
            { // Falling SAR
                double priorEP = EP;
                double priorAF = AF;
                
                if (lowData[i] < EP)
                {
                    EP = lowData[i];
                    AF = MIN(AF + stepPeriod, maxStepPeriod);
                }
                curSAR = sarData[i - 1] - priorAF * (sarData[i - 1] - priorEP);
                if (highData[i] >= curSAR)
                {
                    curSAR = EP;
                    AF = stepPeriod;
                    sarData[i] = curSAR;
                    loc2[i] = 1;
                    EP = highData[i];
                    
                    lastChange = i;
                    lastEP = EP;
                }
                else 
                {
                    sarData[i] = curSAR;
                    loc2[i] = -1;
                }
            }
            else 
            { // Rising SAR
                double priorEP = EP;
                double priorAF = AF;
                
                if (highData[i] > EP)
                {
                    EP = highData[i];
                    AF = MIN(AF + stepPeriod, maxStepPeriod);						
                }
                curSAR = sarData[(i - 1)] + priorAF * (priorEP - sarData[(i - 1)]);
                if (lowData[i] <= curSAR)
                {
                    curSAR = EP;
                    AF = stepPeriod;
                    sarData[i] = curSAR;
                    loc2[i] = -1;
                    EP = lowData[i];
                    
                    lastChange = i;
                    lastEP = EP;
                }
                else 
                {
                    sarData[i] = curSAR;
                    loc2[i] = 1;
                }
            }
            ++i;
        }
    }

}

@end
