#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFChartPeriodPickerItem : PFTableViewChoicesPickerItem

@property ( nonatomic, assign, readonly ) PFChartPeriodType chartPeriod;

-(id)initWithChartPeriod:( PFChartPeriodType )chart_period_;

@end
