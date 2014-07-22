#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFReportTableTypeItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) PFReportTableType tableType;

-(id)initWithTableType:( PFReportTableType )table_type_;

@end
