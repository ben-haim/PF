#import "PFAccountOperationsSource.h"
#import "PFAccountTransferViewController.h"
#import "PFTableViewController.h"
#import "PFNavigationController.h"
#import "PFTableView.h"
#import "PFTableViewCategory+Transfer.h"
#import "PFTableViewCategory+Withdrawal.h"
#import "PFTableViewDecimalPadItem.h"
#import "PFTableViewMoneyItem.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFAccountOperationsSource () < PFSessionDelegate >

@property ( nonatomic, weak ) PFTableViewController* controller;
@property ( nonatomic, strong ) id< PFAccount > sourceAccount;
@property ( nonatomic, strong ) id< PFAccount > targetAccount;

@end

@implementation PFAccountOperationsSource

@synthesize controller;
@synthesize sourceAccount;
@synthesize targetAccount;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(void)activateInController:( PFTableViewController* )controller_
                 andAccount:( id< PFAccount > )account_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   self.sourceAccount = account_;
   self.controller = controller_;
   [ self updateCategories ];
}

-(void)deactivate
{
   self.sourceAccount = nil;
   self.controller = nil;
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
                         andAccount:( id< PFAccount > )account_
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(NSString*)title
{
   [ self doesNotRecognizeSelector: _cmd ];
   return nil;
}

-(void)updateTargetAccount
{
   
}

-(void)submitAction
{
   [ self doesNotRecognizeSelector: _cmd ];
}

-(void)updateCategories
{
   self.controller.tableView.categories = [ self categoriesWithController: self.controller
                                                               andAccount: self.sourceAccount ];
   [ self.controller.tableView reloadData ];
}

-(void)handleOperation:( id< PFMarketOperation > )operation_
{
   [ self updateCategories ];
}

#pragma mark - PFSessionDelegate

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self updateCategories ];
}

@end

@interface PFAccountTransferSource () < PFTableViewDecimalPadItemDelegate >

@property ( nonatomic, assign ) double transferValue;

@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceEquityItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceAvailableItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceRemainsItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* targetEquityItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* targetDepositItem;
@property ( nonatomic, strong ) PFTableViewDecimalPadItem* transferPadItem;

@end

@implementation PFAccountTransferSource

@synthesize transferValue;
@synthesize sourceEquityItem;
@synthesize sourceAvailableItem;
@synthesize sourceRemainsItem;
@synthesize targetEquityItem;
@synthesize targetDepositItem;
@synthesize transferPadItem;


-(NSString*)title
{
   return NSLocalizedString( @"TRANSFER", nil );
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
                         andAccount:( id< PFAccount > )account_
{
   self.transferValue = 0.0;
   self.sourceAccount = account_;
   
   for ( id< PFAccount > other_account_ in [ PFSession sharedSession ].accounts.accounts )
   {
      if ( other_account_ != account_ )
      {
         self.targetAccount = other_account_;
         [self.targetAccount setCurrAssetAccountFromAccount: account_ ];
         break;
      }
   }

   
   PFTableViewCategory* info_category_ = [ PFTableViewCategory transferSourceInfoCategoryWithAccount: self.sourceAccount
                                                                                         andTransfer: self.transferValue ];
   
   PFTableViewCategory* value_category_ = [ PFTableViewCategory transferSourceValueCategoryWithAccount: self.sourceAccount
                                                                                           andTransfer: self.transferValue ];
   
   PFTableViewCategory* target_category_ = [ PFTableViewCategory transferTargetInfoCategoryWithFromAccount: self.sourceAccount
                                                                                           transferAccount: self.targetAccount
                                                                                                  transfer: self.transferValue
                                                                                        transferController: (PFAccountTransferViewController*)controller_ ];
   
   self.sourceEquityItem = (info_category_.items)[0];
   self.sourceAvailableItem = (info_category_.items)[1];
   self.sourceRemainsItem = (info_category_.items)[2];
   self.transferPadItem = [ value_category_.items lastObject ];
   self.targetEquityItem = (target_category_.items)[1];
   self.targetDepositItem = [ target_category_.items lastObject ];
   
   self.transferPadItem.delegate = self;
   
   return @[info_category_
           , target_category_
           , value_category_];
}

-(void)updateTransferInfo
{
   self.sourceAvailableItem.amount = self.sourceAccount.withdrawalAvailable;
   self.sourceEquityItem.amount = self.sourceAccount.equity;
   self.sourceRemainsItem.amount = self.sourceAccount.withdrawalAvailable - ( self.transferValue + self.transferValue * [ [ PFSession sharedSession ] transferCommission ] / 100.0 );
   [ self.controller.tableView reloadCategory: (self.controller.tableView.categories)[0] withRowAnimation: UITableViewRowAnimationNone ];
}

-(void)updateTargetAccount
{
   self.targetEquityItem.amount = self.targetAccount.equity;
   [ self.controller.tableView reloadCategory: (self.controller.tableView.categories)[1] withRowAnimation: UITableViewRowAnimationNone ];
}

-(void)submitAction
{
   if ( self.transferValue + self.transferValue * [ [ PFSession sharedSession ] transferCommission ] / 100.0 > self.sourceAccount.withdrawalAvailable )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_TRANSFER_SUM", nil ) ];
   }
   else
   {
      [ [ PFSession sharedSession ] transferFromAccount: self.sourceAccount
                                              toAccount: self.targetAccount
                                                 amount: - self.transferValue ];
      
      
      if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
      {
         [ self.controller.pfNavigationController popViewControllerAnimated: YES ];
      }
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   static double source_withdrawal_ = 0.0;
   static double source_equity_ = 0.0;
   static double target_equity_ = 0.0;
   
   if ( account_ == self.sourceAccount && ( source_withdrawal_ != account_.withdrawalAvailable || source_equity_ != account_.equity ) )
   {
      source_withdrawal_ = account_.withdrawalAvailable;
      source_equity_ = account_.equity;
      
      [ self updateTransferInfo ];
   }
   else if ( account_ == self.targetAccount && target_equity_ != account_.equity )
   {
      target_equity_ = account_.equity;
      
      [ self updateTargetAccount ];
   }
}

#pragma mark - PFTableViewDecimalPadItemDelegate

-(void)decimalPadItemValueChanged
{
   self.transferValue = self.transferPadItem.doubleValue;
   
   self.targetDepositItem.amount = self.transferValue * self.targetAccount.crossPrice / self.sourceAccount.crossPrice;
   [ self.controller.tableView reloadCategory: (self.controller.tableView.categories)[1] withRowAnimation: UITableViewRowAnimationNone ];
   
   [ self updateTransferInfo ];
}

@end

@interface PFAccountWithdrawalSource () < PFTableViewDecimalPadItemDelegate >

@property ( nonatomic, assign ) double withdrawalValue;

@property ( nonatomic, strong ) PFTableViewMoneyItem* availableItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* remainsItem;
@property ( nonatomic, strong ) PFTableViewDecimalPadItem* withdrawalPadItem;

@end

@implementation PFAccountWithdrawalSource

@synthesize withdrawalValue;

@synthesize availableItem;
@synthesize remainsItem;
@synthesize withdrawalPadItem;

-(NSString*)title
{
   return NSLocalizedString( @"WITHDRAWAL_TITLE", nil );
}

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
                         andAccount:( id< PFAccount > )account_
{
   self.withdrawalValue = 0.0;
   self.sourceAccount = account_;
   
   PFTableViewCategory* info_category_ = [ PFTableViewCategory withdrawalInfoCategoryWithAccount: self.sourceAccount
                                                                                   andWithdrawal: self.withdrawalValue ];
   
   PFTableViewCategory* value_category_ = [ PFTableViewCategory withdrawalValueCategoryWithAccount: self.sourceAccount
                                                                                     andWithdrawal: self.withdrawalValue ];
   
   self.withdrawalPadItem = [ value_category_.items lastObject ];
   self.withdrawalPadItem.delegate = self;
   
   self.availableItem = (info_category_.items)[0];
   self.remainsItem = [ info_category_.items lastObject ];
   
   
   return @[info_category_, value_category_];
}

-(void)updateAccountInfo
{
   self.availableItem.amount = self.sourceAccount.withdrawalAvailable;
   self.remainsItem.amount = self.sourceAccount.withdrawalAvailable - self.withdrawalValue;
   
   [ self.controller.tableView reloadCategory: (self.controller.tableView.categories)[0] withRowAnimation: UITableViewRowAnimationNone ];
}

-(void)submitAction
{
   if ( self.withdrawalValue > self.sourceAccount.withdrawalAvailable )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_WITHDRAWAL_SUM", nil ) ];
   }
   else
   {
      [ [ PFSession sharedSession ] withdrawalForAccount: self.sourceAccount
                                               andAmount: - self.withdrawalValue ];
      
      if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
      {
         [ self.controller.pfNavigationController popViewControllerAnimated: YES ];
      }
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   if ( account_ == self.sourceAccount )
   {
      [ self updateAccountInfo ];
   }
}

#pragma mark - PFTableViewDecimalPadItemDelegate

-(void)decimalPadItemValueChanged
{
   self.withdrawalValue = self.withdrawalPadItem.doubleValue;
   [ self updateAccountInfo ];
}

@end
