#import "PFTableViewPickerItem.h"

@interface PFChartCasheSizePickerItem : PFTableViewChoicesPickerItem

@property ( nonatomic, assign, readonly ) double chartCasheLimit;

-(id)initWithChartCasheLimit:( double )cashe_limit_;

@end
