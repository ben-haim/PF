#import "PFTableViewCategory.h"

@class PFSettings;

@interface PFTableViewCategory (Settings)

+(id)settingsDefaultsCategoryWithSettings:( PFSettings* )settings_;
+(id)settingsConfirmationCategoryWithSettings:( PFSettings* )settings_;
+(id)settingsChartCategoryWithSettings:( PFSettings* )settings_;
+(id)settingsMarketPanelsCategoryWithSettings:( PFSettings* )settings_;

@end
