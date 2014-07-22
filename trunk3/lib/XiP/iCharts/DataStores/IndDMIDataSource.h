//
//  IndDMIDataSource.h
//  XiP
//
//  Created by Xogee MacBook on 05/08/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;


@interface IndDMIDataSource : IndDataSource 
{
    int period;
}
- (ArrayMath*)computeTrueRange:(ArrayMath*)closeData 
                             h:(ArrayMath*)highData
                             l:(ArrayMath*)lowData;
@property (assign) int period;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andCloseData:(ArrayMath*)closeDataData andDiPlusData:(ArrayMath*)diPlusData1 andDiMinusData:(ArrayMath*)diMinusData1 andAdxData1:(ArrayMath*)adxData1;

@end
