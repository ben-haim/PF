
#import <Foundation/Foundation.h>
#import "BaseDataStore.h"

@interface HLOCDataSource : BaseDataStore 
{
    uint RangeType;
    uint symbol_digits; 
    double last_bid;
    double last_ask;
}
- (id)initWithRangeType:(uint)_RangeType AndDigits:(uint)_sym_digits;
-(bool)MergePriceWithBid:(double)bid AndAsk:(double)ask AtTime:(NSDate*)timeValue;
-(NSDate*)RoundDate:(NSDate*)dtDate ForRange:(uint)_RangeType;
-(NSString*)getIntervalName;

@property (assign) uint RangeType;
@property (assign) uint symbol_digits;
@property (assign) double last_bid;
@property (assign) double last_ask;
@end
