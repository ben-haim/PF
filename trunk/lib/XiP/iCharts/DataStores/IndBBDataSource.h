
#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndBBDataSource : IndDataSource 
{
    NSString *priceField;
    uint period;    
    uint deviation;    
}

@property (nonatomic, retain) NSString *priceField;
@property (assign) uint period;
@property (assign) uint deviation;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData1:(ArrayMath*)indData1 andIndData2:(ArrayMath*)indData2;

@end
