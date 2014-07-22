//
//  IndRSIDataSource.m
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "IndRSIDataSource.h"
#import "IndDataSource.h"
#import "PropertiesStore.h"
#import "ArrayMath.h"


@implementation IndRSIDataSource
@synthesize priceField, period, level;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super initWithDataSource:baseData AndProperties:properties AndPath:path];
    if(self == nil)
        return self;
    priceField = [properties getApplyToParam:[NSString stringWithFormat:@"%@.apply", path]];
    period = [properties getUIntParam:[NSString stringWithFormat:@"%@.interval", path]];    
    level = [properties getUIntParam:[NSString stringWithFormat:@"%@.level", path]];    
    return self;
}

//called to do the first build based on the whole source vector
-(void)build
{
    ArrayMath* src_data = [src GetVector:priceField];
    int scr_len = [src_data getLength];
    
    ArrayMath* hundred = [[[ArrayMath alloc] initWithLength:scr_len] autorelease];
    for(int i = 0; i<scr_len; i++)
        [hundred getData][i] = 100.0; 
    
    ArrayMath* avgGains 	= [[[src_data delta:1] selectGTZ:0] movAvgRsi:period];		
    ArrayMath* avgLosses 	= [[[[src_data delta:1] selectLTZ:0] abs] movAvgRsi:period];
    
    ArrayMath* res1 = [[avgGains div:avgLosses] sub2:-1];
    ArrayMath* res2 = [hundred div:res1];   
    ArrayMath* res = [hundred sub:res2];   
    
    lastGain = [avgGains getData][[avgGains getLength] - 2];
    lastLoss = [avgLosses getData][[avgLosses getLength] - 2];
    
    newGain = [avgGains getData][[avgGains getLength] - 1];
    newLoss = [avgLosses getData][[avgLosses getLength] - 1];
    
    [self SetVector:res forKey:@"indData"];
    
    ArrayMath* level_top = [[[ArrayMath alloc] initWithLength:scr_len] autorelease];
    for(int i = 0; i<scr_len; i++)
        [level_top getData][i] = 100 - level;
    [self SetVector:level_top forKey:@"level_top"]; 
    
    ArrayMath* level_bottom = [[[ArrayMath alloc] initWithLength:scr_len] autorelease];
    for(int i = 0; i<scr_len; i++)
        [level_bottom getData][i] = level;
    [self SetVector:level_bottom forKey:@"level_bottom"]; 
    
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
            [[self GetVector:@"level_top"] addElement:100 - level];
            [[self GetVector:@"level_bottom"] addElement:level];

            [self SourceDataProcedureWithLastIndex:lastIndex andSrcData:srcData andIndData:indData];
        }
    }
    else 
    {
        [self SourceDataProcedureWithLastIndex:src_len andSrcData:srcData andIndData:indData];    
    }
}

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData
{
    if (isnan([indData getData][lastIndex-1]))
    {				
        lastGain = newGain;
        lastLoss = newLoss;
    }
    
    double curGain = 0;
    double curLoss = 0;
    
    double change = [srcData getData][lastIndex-1] - [srcData getData][lastIndex-2]; 
    if (change < 0)
        curLoss = fabs(change);
    else
        curGain = change;
    
    double avgGain = (lastGain * (period-1) + curGain) / period;
    double avgLoss = (lastLoss * (period-1) + curLoss) / period;
    
    double RS = avgGain / avgLoss;
    
    if (!isnan([indData getData][lastIndex-1]))
    {
        newGain = avgGain;
        newLoss = avgLoss;
    }
    [indData getData][lastIndex-1] = 100 - 100 / (1 + RS);   
}
@end
