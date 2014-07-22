#import "PFTableViewItem+Accounts.h"
#import "PFTableViewAccountItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewItem (Accounts)

+(id)itemWithAccount:( id< PFAccount > )account_
           isDefault:( BOOL )is_default_
{
   PFTableViewAccountItem* account_item_ = [ PFTableViewAccountItem itemWithAction: nil
                                                                             title: account_.name
                                                                  isDefaultAccount: is_default_ ];
   
   account_item_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

   return account_item_;
}

@end
