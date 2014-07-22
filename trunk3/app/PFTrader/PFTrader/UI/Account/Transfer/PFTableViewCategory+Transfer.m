#import "PFTableViewCategory+Transfer.h"

#import "PFTableView.h"
#import "PFTableViewDetailItem.h"
#import "PFTableViewMoneyItem.h"
#import "PFTableViewDecimalPadItem.h"
#import "PFAccountPickerItem.h"

#import "PFTransferViewController.h"
#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (Transfer)

+(id)transferSourceInfoCategoryWithAccount:( id< PFAccount > )account_
                               andTransfer:( double )transfer_
{
   PFTableViewItem* equity_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_EQUITY", nil )
                                                                 amount: account_.equity
                                                              precision: account_.precision
                                                               currency: account_.currency
                                                              colorSign: NO ];
   
   PFTableViewItem* available_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"AVAILABLE", nil )
                                                                    amount: account_.withdrawalAvailable
                                                                 precision: account_.precision
                                                                  currency: account_.currency
                                                                 colorSign: NO ];
   
   PFTableViewItem* remains_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"REMAINS", nil )
                                                                  amount: account_.withdrawalAvailable - transfer_
                                                               precision: account_.precision
                                                                currency: account_.currency
                                                               colorSign: NO ];
   
   PFTableViewItem* commission_item_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                        title: NSLocalizedString( @"COMMISSION", nil )
                                                                        value: [ NSString stringWithPercent: [ [ PFSession sharedSession ] transferCommission ]
                                                                                            showPercentSign: YES ] ];
   
   NSArray* general_items_ = [ NSArray arrayWithObjects: equity_item_
                              , available_item_
                              , remains_item_
                              , commission_item_
                              , nil ];
   
   return [ self categoryWithTitle: NSLocalizedString( @"SOURCE_ACCOUNT", nil )
                             items: general_items_ ];
}

+(id)transferSourceValueCategoryWithAccount:( id< PFAccount > )account_
                                andTransfer:( double )transfer_
{
   PFTableViewDecimalPadItem* pad_item_ = [ [ PFTableViewDecimalPadItem alloc ] initWithName: NSLocalizedString(@"TRANSFER_VALUE", nil)
                                                                                       value: transfer_
                                                                                    minValue: 0.0
                                                                                        step: 0.01 ];
   
   return [ self categoryWithTitle: NSLocalizedString(@"TRANSFER", nil) items: [ NSArray arrayWithObject: pad_item_ ] ];
}

+(id)transferTargetInfoCategoryWithFromAccount:( id< PFAccount > )from_account_
                               transferAccount:( id< PFAccount > )transfer_account_
                                      transfer:( double )transfer_
                            transferController:( PFTransferViewController* )controller_
{
   __weak PFTransferViewController* unsafe_controller_ = controller_;
   
   PFAccountPickerItem* account_item_ = [ [ PFAccountPickerItem alloc ] initWithAccount: transfer_account_
                                                                      andNonusedAccount: from_account_ ];
   
   account_item_.pickerAction = ^( PFTableViewBasePickerItem* picker_item_ )
   {
      id< PFAccount > new_target_account_ = (( PFAccountPickerItem* )picker_item_).selectedAccount;
      
      if ( new_target_account_ != unsafe_controller_.targetAccount )
      {
         unsafe_controller_.targetAccount = new_target_account_;
         [ unsafe_controller_ updateTargetAccount ];
      }
   };

   PFTableViewItem* equity_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"ACCOUNT_EQUITY", nil )
                                                                 amount: transfer_account_.equity
                                                              precision: transfer_account_.precision
                                                               currency: transfer_account_.currency
                                                              colorSign: NO ];
   
   PFTableViewItem* rate_item_ = [ PFTableViewDetailItem itemWithAction: nil
                                                                        title: NSLocalizedString( @"TRANSFER_RATE", nil )
                                                                        value: [ NSString stringWithFormat: @"%f", transfer_account_.crossPrice / from_account_.crossPrice ] ];
   
   PFTableViewItem* deposit_item_ = [ PFTableViewMoneyItem itemWithTitle: NSLocalizedString( @"DEPOSIT", nil )
                                                                  amount: transfer_
                                                               precision: transfer_account_.precision
                                                                currency: transfer_account_.currency
                                                               colorSign: NO ];
   
   NSArray* general_items_ = [ NSArray arrayWithObjects: account_item_
                              , equity_item_
                              , rate_item_
                              , deposit_item_
                              , nil ];
   
   return [ self categoryWithTitle: NSLocalizedString( @"TARGET_ACCOUNT", nil )
                             items: general_items_ ];
}

@end
