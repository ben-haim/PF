#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <UIKit/UIKit.h>

@interface PFTableViewOrderTypeItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) PFOrderType currentType;
@property ( nonatomic, assign, readonly ) PFOrderType oldType;
@property ( nonatomic, strong, readonly ) NSArray* types;

-(id)initWithType:( PFOrderType )order_type_ andAllowedTypes:( NSArray* )allowed_order_types_;

@end
