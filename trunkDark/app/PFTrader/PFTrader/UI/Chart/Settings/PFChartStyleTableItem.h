#import "PFChartStyleType.h"

#import "PFTableViewPickerItem.h"

@interface PFChartStyleTableItem : PFTableViewChoicesPickerItem

@property ( nonatomic, assign, readonly ) PFChartStyleType styleType;

-(id)initWithStyleType:( PFChartStyleType )style_type_;

@end
