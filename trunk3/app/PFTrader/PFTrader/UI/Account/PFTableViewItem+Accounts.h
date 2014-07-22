#import "PFTableViewItem.h"

#import <Foundation/Foundation.h>

@protocol PFAccount;

@interface PFTableViewItem (Accounts)

+(id)itemWithAccount:( id< PFAccount > )account_;
+(id)itemWithDefaultAccount:( id< PFAccount > )account_;

@end
