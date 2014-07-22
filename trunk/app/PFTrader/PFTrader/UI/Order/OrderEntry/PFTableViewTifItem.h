#import "PFTableViewPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <UIKit/UIKit.h>

@interface PFTableViewTifItem : PFTableViewPickerItem

@property ( nonatomic, assign, readonly ) PFOrderValidityType currentValidity;

-(id)initWithValidity:( PFOrderValidityType )validity_type_ andAllowedValidities:( NSArray* ) allowed_validities_;

@end
