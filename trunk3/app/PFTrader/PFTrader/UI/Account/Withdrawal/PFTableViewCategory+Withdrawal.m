#import "PFTableViewCategory+Withdrawal.h"

#import "PFTableViewMoneyItem.h"
#import "PFTableViewDecimalPadItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (Withdrawal)

+(id)withdrawalInfoCategoryWithAccount:( id< PFAccount > )account_
                         andWithdrawal:( double )withdrawal_
{
   PFTableViewItem* available_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"AVAILABLE", nil )
                                                                amount: account_.withdrawalAvailable
                                                                  currency: account_.currency
                                                             colorSign: NO ];
   
   PFTableViewItem* remains_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"REMAINS", nil )
                                                                amount: account_.withdrawalAvailable - withdrawal_
                                                              currency: account_.currency
                                                             colorSign: NO ];
   
   NSArray* general_items_ = [ NSArray arrayWithObjects: available_item_
                              , remains_item_
                              , nil ];
   
   return [ self categoryWithTitle: account_.name items: general_items_ ];
}

+(id)withdrawalValueCategoryWithAccount:( id< PFAccount > )account_
                          andWithdrawal:( double )withdrawal_
{
   PFTableViewDecimalPadItem* pad_item_ = [ [ PFTableViewDecimalPadItem alloc ] initWithName: NSLocalizedString(@"WITHDRAWAL_VALUE", nil)
                                                                                       value: withdrawal_
                                                                                    minValue: 0.0
                                                                                        step: 0.01 ];
   
   return [ self categoryWithTitle: NSLocalizedString(@"WITHDRAWAL", nil) items: [ NSArray arrayWithObject: pad_item_ ] ];
}

@end
