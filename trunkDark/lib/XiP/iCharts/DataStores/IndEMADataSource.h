
#import <Foundation/Foundation.h>
#import "IndDataSource.h"

@class PropertiesStore;
@class BaseDataStore;

@interface IndEMADataSource : IndDataSource 
{
    NSString *priceField;
    uint period;
}
@property (nonatomic, retain) NSString *priceField;
@property (assign) uint period;

-(void)SourceDataProcedureWithLastIndex:(int)lastIndex andSrcData:(ArrayMath*)srcData andIndData:(ArrayMath*)indData;

@end
