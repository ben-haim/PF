#import "PFTableViewItem.h"

@protocol PFAccount;

@interface PFTableViewItem ( Accounts )

+(id)itemWithAccount:( id< PFAccount > )account_
           isDefault:( BOOL )is_default_;

@end
