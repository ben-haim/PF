#import "PFTableViewCategory.h"

@protocol PFAccount;

@interface PFTableViewCategory (Withdrawal)

+(id)withdrawalInfoCategoryWithAccount:( id< PFAccount > )account_
                         andWithdrawal:( double )withdrawal_;

+(id)withdrawalValueCategoryWithAccount:( id< PFAccount > )account_
                          andWithdrawal:( double )withdrawal_;

@end
