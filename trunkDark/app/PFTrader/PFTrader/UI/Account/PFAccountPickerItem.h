#import "PFTableViewPickerItem.h"

@protocol PFAccount;

@interface PFAccountPickerItem : PFTableViewPickerItem

@property ( nonatomic, strong ) id< PFAccount > selectedAccount;

-(id)initWithAccount:( id< PFAccount > )account_;

-(id)initWithAccount:( id< PFAccount > )account_
   andNonusedAccount:( id< PFAccount > )nonused_account_;

@end
