//
//  IndPSARDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 03/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndPSARDataSource : IndDataSource 
{
    double maxStepPeriod;
    double stepPeriod;
    int lastChange;
    double lastEP;
}
-(void)CalculateData:(int)fromIndex;
@property (assign) double maxStepPeriod;
@property (assign) double stepPeriod;
@property (assign) int lastChange;
@property (assign) double lastEP;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andFromIndex:(int)fromIndex andSrcLength:(int)srclen;

@end
