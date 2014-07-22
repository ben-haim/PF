//
//  IndENVDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;


@interface IndENVDataSource : IndDataSource 
{
    NSString *priceField;
    uint period;    
    double deviation;    
}

@property (nonatomic, retain) NSString *priceField;
@property (assign) uint period;
@property (assign) double deviation;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andEnvLowerData:(ArrayMath*)envLower andEnvUpperData:(ArrayMath*)envUpper;

@end