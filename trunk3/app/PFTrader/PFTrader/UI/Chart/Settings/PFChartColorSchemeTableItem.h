#import "PFChartColorSchemeType.h"

#import "PFTableViewPickerItem.h"

@interface PFChartColorSchemeTableItem : PFTableViewChoicesPickerItem

@property ( nonatomic, assign, readonly ) PFChartColorSchemeType schemeType;

-(id)initWithSchemeType:( PFChartColorSchemeType )scheme_type_;

@end
