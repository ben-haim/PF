#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndBandsDataSource : IndDataSource

@property (nonatomic, strong) NSString* priceField;
@property (assign) uint period;
@property (assign) uint deviation;

-(void)SourceDataProcedureWithLastIndex: (int)last_index_
                             andSrcData: (ArrayMath*) scr_data_
                            andIndData1: (ArrayMath*)ind_data1_
                            andIndData2: (ArrayMath*)ind_data2_
                            andIndData3: (ArrayMath*)ind_data3_;
@end
