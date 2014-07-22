#import "PFTableViewCategory.h"

@protocol PFAccount;
@class PFTransferViewController;

@interface PFTableViewCategory (Transfer)

+(id)transferSourceInfoCategoryWithAccount:( id< PFAccount > )account_
                               andTransfer:( double )transfer_;

+(id)transferSourceValueCategoryWithAccount:( id< PFAccount > )account_
                                andTransfer:( double )transfer_;

+(id)transferTargetInfoCategoryWithFromAccount:( id< PFAccount > )from_account_
                               transferAccount:( id< PFAccount > )transfer_account_
                                      transfer:( double )transfer_
                            transferController:( PFTransferViewController* )controller_;

@end
