#import "PFWithdrawalViewController.h"

#import "PFTableView.h"
#import "PFTableViewDecimalPadItem.h"
#import "PFTableViewMoneyItem.h"
#import "PFTableViewCategory+Withdrawal.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFWithdrawalViewController () < PFSessionDelegate, PFTableViewDecimalPadItemDelegate >

@property ( nonatomic, assign ) double withdrawalValue;
@property ( nonatomic, strong ) id< PFAccount > currentAccount;

@property ( nonatomic, strong ) PFTableViewMoneyItem* availableItem;
@property ( nonatomic, strong ) PFTableViewMoneyItem* remainsItem;
@property ( nonatomic, strong ) PFTableViewDecimalPadItem* withdrawalPadItem;

@end

@implementation PFWithdrawalViewController

@synthesize submitButton;
@synthesize withdrawalValue;
@synthesize currentAccount;

@synthesize availableItem;
@synthesize remainsItem;
@synthesize withdrawalPadItem;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];

   self.currentAccount = nil;
   self.submitButton = nil;
   self.availableItem = nil;
   self.remainsItem = nil;
   self.withdrawalPadItem = nil;
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString(@"WITHDRAWAL_TITLE", nil);
      self.withdrawalValue = 0.0;
      self.currentAccount = account_;
   }
   
   return self;
}

- (void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];

   [ self.submitButton setTitle: NSLocalizedString( @"SUBMIT_BUTTON", nil ) forState: UIControlStateNormal ];
   
   
   PFTableViewCategory* info_category_ = [ PFTableViewCategory withdrawalInfoCategoryWithAccount: self.currentAccount
                                                                                   andWithdrawal: self.withdrawalValue ];
   
   PFTableViewCategory* value_category_ = [ PFTableViewCategory withdrawalValueCategoryWithAccount: self.currentAccount
                                                                                     andWithdrawal: self.withdrawalValue ];
   
   self.withdrawalPadItem = [ value_category_.items lastObject ];
   self.withdrawalPadItem.delegate = self;
   
   self.availableItem = [ info_category_.items objectAtIndex: 0 ];
   self.remainsItem = [ info_category_.items lastObject ];
   

   self.tableView.categories = [ NSArray arrayWithObjects: info_category_, value_category_, nil ];
}

-(IBAction)submitAction:( id )sender_
{
   if ( self.withdrawalValue > self.currentAccount.withdrawalAvailable )
   {
      [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString(@"INVALID_WITHDRAWAL_SUM", nil ) ];
   }
   else
   {
      [ [ PFSession sharedSession ] withdrawalForAccount: self.currentAccount
                                               andAmount: - self.withdrawalValue ];
      
      [ self.navigationController popViewControllerAnimated: YES ];
   }
}

-(void)updateAccountInfo
{
   self.availableItem.amount = self.currentAccount.withdrawalAvailable;
   self.remainsItem.amount = self.currentAccount.withdrawalAvailable - self.withdrawalValue;
   
   [ self.tableView reloadCategory: [ self.tableView.categories objectAtIndex: 0 ] withRowAnimation: UITableViewRowAnimationNone ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   if ( account_ == self.currentAccount )
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
