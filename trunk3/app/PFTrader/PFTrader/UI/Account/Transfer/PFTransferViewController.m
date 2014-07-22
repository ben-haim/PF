#import "PFTransferViewController.h"

#import "PFTableView.h"
#import "PFTableViewMoneyItem.h"
#import "PFTableViewDecimalPadItem.h"
#import "PFTableViewCategory+Transfer.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFTransferViewController () < PFSessionDelegate, PFTableViewDecimalPadItemDelegate >

@property ( nonatomic, assign ) double transferValue;

@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceEquityItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceAvailableItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* sourceRemainsItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* targetEquityItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* targetDepositItem;
@property ( nonatomic, strong ) PFTableViewDecimalPadItem* transferPadItem;

@end

@implementation PFTransferViewController

@synthesize submitButton;
@synthesize transferValue;

@synthesize sourceAccount;
@synthesize targetAccount;

@synthesize sourceEquityItem;
@synthesize sourceAvailableItem;
@synthesize sourceRemainsItem;
@synthesize targetEquityItem;
@synthesize targetDepositItem;
@synthesize transferPadItem;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];

   self.submitButton = nil;
   self.sourceAccount = nil;
   self.targetAccount = nil;

   self.sourceEquityItem = nil;
   self.sourceAvailableItem = nil;
   self.sourceRemainsItem = nil;
   self.targetEquityItem = nil;
   self.targetDepositItem = nil;
   self.transferPadItem = nil;
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString(@"TRANSFER_TITLE", nil);
      self.transferValue = 0.0;
      self.sourceAccount = account_;

      for ( id< PFAccount > other_account_ in [ PFSession sharedSession ].accounts.accounts )
      {
         if ( other_account_ != account_ )
         {
            self.targetAccount = other_account_;
            [self.targetAccount setCurrAssetAccountFromAccount: account_];
            break;
         }
      }
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.submitButton setTitle: NSLocalizedString( @"SUBMIT_BUTTON", nil ) forState: UIControlStateNormal ];
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   PFTableViewCategory* info_category_ = [ PFTableViewCategory transferSourceInfoCategoryWithAccount: self.sourceAccount
                                                                                         andTransfer: self.transferValue ];
   
   PFTableViewCategory* value_category_ = [ PFTableViewCategory transferSourceValueCategoryWithAccount: self.sourceAccount
                                                                                           andTransfer: self.transferValue ];
   
   PFTableViewCategory* target_category_ = [ PFTableViewCategory transferTargetInfoCategoryWithFromAccount: self.sourceAccount
                                                                                           transferAccount: self.targetAccount
                                                                                                  transfer: self.transferValue
                                                                                        transferController: self ];
   
   self.sourceEquityItem = [ info_category_.items objectAtIndex: 0 ];
   self.sourceAvailableItem = [ info_category_.items objectAtIndex: 1 ];
   self.sourceRemainsItem = [ info_category_.items objectAtIndex: 2 ];
   self.transferPadItem = [ value_category_.items lastObject ];
   self.targetEquityItem = [ target_category_.items objectAtIndex: 1 ];
   self.targetDepositItem = [ target_category_.items lastObject ];
   
   self.transferPadItem.delegate = self;
   
   self.tableView.categories = [ NSArray arrayWithObjects: info_category_
                                , target_category_
                                , value_category_
                                , nil ];
}

-(IBAction)submitAction:( id )sender_
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
      
      [ self.navigationController popViewControllerAnimated: YES ];
   }
}

-(void)updateTransferInfo
{
   self.sourceAvailableItem.amount = self.sourceAccount.withdrawalAvailable;
   self.sourceEquityItem.amount = self.sourceAccount.equity;
   self.sourceRemainsItem.amount = self.sourceAccount.withdrawalAvailable - ( self.transferValue + self.transferValue * [ [ PFSession sharedSession ] transferCommission ] / 100.0 );
   [ self.tableView reloadCategory: [ self.tableView.categories objectAtIndex: 0 ] withRowAnimation: UITableViewRowAnimationNone ];  
}

-(void)updateTargetAccount
{
   self.targetEquityItem.amount = self.targetAccount.equity;
   [ self.tableView reloadCategory: [ self.tableView.categories objectAtIndex: 1 ] withRowAnimation: UITableViewRowAnimationNone ];
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
   [ self.tableView reloadCategory: [ self.tableView.categories objectAtIndex: 1 ] withRowAnimation: UITableViewRowAnimationNone ];
   
   [ self updateTransferInfo ];
}

@end
