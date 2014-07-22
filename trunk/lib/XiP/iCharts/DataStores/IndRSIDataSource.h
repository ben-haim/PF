//
//  IndRSIDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndRSIDataSource : IndDataSource 
{
    NSString *priceField;
    uint period;
    uint level;
    
    double lastGain;
    double lastLoss;
    double newGain;
    double newLoss;
}
@property (nonatomic, retain) NSString *priceField;
@property (assign) uint period;
@property (assign) uint level;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData;

@end
