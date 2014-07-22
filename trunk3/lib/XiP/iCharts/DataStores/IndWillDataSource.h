//
//  IndWillDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 04/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"
#import "IndWillDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndWillDataSource : IndDataSource 
{
    uint period;
}
@property (assign) uint period;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andCloseData:(ArrayMath*)closeData andLowData:(ArrayMath*)lowData andHighData:(ArrayMath*)highData andIndData:(ArrayMath*)indData;

@end
