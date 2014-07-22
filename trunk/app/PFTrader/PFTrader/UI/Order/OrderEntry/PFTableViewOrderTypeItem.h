#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <UIKit/UIKit.h>

@interface PFTableViewOrderTypeItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) PFOrderType currentType;

-(id)initWithType:( PFOrderType )order_type_ andAllowedTypes:( NSArray* )allowed_order_types_;

@end
