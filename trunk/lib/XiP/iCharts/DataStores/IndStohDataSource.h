//
//  IndStohDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 05/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndStohDataSource : IndDataSource 
{
    int k_period;
    int d_period;
    int smoothing;
}
@property (assign) int k_period;
@property (assign) int d_period;
@property (assign) int smoothing;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andKData:(ArrayMath*)dataK andDData:(ArrayMath*)dataD;

@end
