#import "PFTableViewCategory.h"

@class PFChartSettings;

@interface PFTableViewCategory (ChartSettings)

+(id)generalCategoryWithSettings:( PFChartSettings* )settings_;
+(id)tradingLayersCategoryWithSettings:( PFChartSettings* )settings_;
+(id)additionalCategoryWithSettings:( PFChartSettings* )settings_;

@end
