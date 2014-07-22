#import "PFTableViewDetailItem.h"

@protocol PFTableViewDecimalPadItemDelegate

-(void)decimalPadItemValueChanged;

@end

@interface PFTableViewDecimalPadItem : PFTableViewDetailItem

@property ( nonatomic, assign, readonly ) double doubleValue;
@property ( nonatomic, assign ) double step;
@property ( nonatomic, unsafe_unretained ) id< PFTableViewDecimalPadItemDelegate > delegate;

-(id)initWithName: (NSString*)name_
            value: (double)value_
         minValue: (double)min_value_
             step: (double)step_;
@end
