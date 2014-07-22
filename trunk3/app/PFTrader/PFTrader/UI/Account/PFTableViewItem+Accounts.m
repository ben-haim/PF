#import "PFTableViewItem+Accounts.h"

#import "PFTableViewDetailItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewItem (Accounts)

+(id)itemWithAccount:( id< PFAccount > )account_
{
   PFTableViewItem* account_item_ = [ self itemWithAction: nil
                                                    title: account_.name ];

   account_item_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

   return account_item_;
}

+(id)itemWithDefaultAccount:( id< PFAccount > )account_
{
   PFTableViewDetailItem* account_item_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                           title: NSLocalizedString( @"ACTIVE_ACCOUNT", nil )
                                                                           value: account_.name ];

   account_item_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

   return account_item_;
}

@end
