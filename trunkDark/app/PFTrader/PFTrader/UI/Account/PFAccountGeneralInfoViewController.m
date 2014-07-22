#import "PFAccountGeneralInfoViewController.h"
#import "PFModalWindow.h"
#import "UIColor+Skin.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountGeneralInfoViewController () < PFSessionDelegate >

@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation PFAccountGeneralInfoViewController

@synthesize account;

@synthesize accountBalanceLabel;
@synthesize projectedBalanceLabel;
@synthesize accountValueLabel;
@synthesize marginAvaliableLabel;
@synthesize currentMarginLabel;
@synthesize marginWarningLabel;
@synthesize blockedBalanceLabel;
@synthesize cashBalanceLabel;
@synthesize withdrawalLabel;
@synthesize accountBalanceValueLabel;
@synthesize projectedBalanceValueLabel;
@synthesize accountValueValueLabel;
@synthesize marginAvaliableValueLabel;
@synthesize currentMarginValueLabel;
@synthesize marginWarningValueLabel;
@synthesize blockedBalanceValueLabel;
@synthesize cashBalanceValueLabel;
@synthesize withdrawalValueLabel;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   if ( self = [ self init ] )
   {
      self.title = [ account_.name stringByAppendingFormat: @" %@", NSLocalizedString( @"GENERAL", nil ) ];
      self.account = account_;
   }
   return self;
}

+(id)controllerWithAccount:( id< PFAccount > )account_
{
   return [ [ self alloc ] initWithAccount: account_ ];
}

-(void)reloadAccountData
{
   [ self.accountBalanceValueLabel showAmount: account.balance
                                    precision: account.precision
                                     currency: account.currency ];

   [ self.projectedBalanceValueLabel showAmount: account.balance + account.totalGrossPl
                                      precision: account.precision
                                       currency: account.currency ];

   [ self.accountValueValueLabel showAmount: account.value
                                  precision: account.precision
                                   currency: account.currency ];

   [ self.marginAvaliableValueLabel showAmount: account.marginAvailable
                                     precision: account.precision
                                      currency: account.currency ];

   [ self.currentMarginValueLabel showAmount: account.usedMargin
                                   precision: account.precision
                                    currency: account.currency ];

   [ self.marginWarningValueLabel showAmount: account.marginWarning
                                   precision: account.precision
                                    currency: account.currency ];

   [ self.blockedBalanceValueLabel showAmount: account.blockedSum
                                    precision: account.precision
                                     currency: account.currency ];

   [ self.cashBalanceValueLabel showAmount: account.cashBalance
                                 precision: account.precision
                                  currency: account.currency ];

   [ self.withdrawalValueLabel showAmount: account.withdrawalAvailable
                                precision: account.precision
                                 currency: account.currency ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                style: UIBarButtonItemStylePlain
                                                                               target: self
                                                                               action: @selector( close ) ];

   self.accountBalanceLabel.textColor = [UIColor grayTextColor];
   self.projectedBalanceLabel.textColor = [UIColor grayTextColor];
   self.accountValueLabel.textColor = [UIColor grayTextColor];
   self.marginAvaliableLabel.textColor = [UIColor grayTextColor];
   self.currentMarginLabel.textColor = [UIColor grayTextColor];
   self.marginWarningLabel.textColor = [UIColor grayTextColor];
   self.blockedBalanceLabel.textColor = [UIColor grayTextColor];
   self.cashBalanceLabel.textColor = [UIColor grayTextColor];
   self.withdrawalLabel.textColor = [UIColor grayTextColor];

   self.accountBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.projectedBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.accountValueValueLabel.textColor = [UIColor mainTextColor];
   self.marginAvaliableValueLabel.textColor = [UIColor mainTextColor];
   self.currentMarginValueLabel.textColor = [UIColor mainTextColor];
   self.marginWarningValueLabel.textColor = [UIColor mainTextColor];
   self.blockedBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.cashBalanceValueLabel.textColor = [UIColor mainTextColor];
   self.withdrawalValueLabel.textColor = [UIColor mainTextColor];

   self.accountBalanceLabel.text = NSLocalizedString( @"ACCOUNT_BALANCE", nil );
   self.projectedBalanceLabel.text = NSLocalizedString( @"PROJECTED_BALANCE", nil );
   self.accountValueLabel.text = NSLocalizedString( @"ACCOUNT_VALUE", nil );
   self.marginAvaliableLabel.text = NSLocalizedString( @"MARGIN_AVAILABLE", nil );
   self.currentMarginLabel.text = NSLocalizedString( @"CURRENT_MARGIN", nil );
   self.marginWarningLabel.text = NSLocalizedString( @"MARGIN_WARNING", nil );
   self.blockedBalanceLabel.text = NSLocalizedString( @"BLOCKED_BALANCE", nil );
   self.cashBalanceLabel.text = NSLocalizedString( @"CASH_BALANCE", nil );
   self.withdrawalLabel.text = NSLocalizedString( @"WITHDRAWAL_AVAILABLE", nil );

   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self reloadAccountData ];

   self.view.backgroundColor = [ UIColor backgroundLightColor ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   [ self setDarkNavigationBar ];
}

-(void)close
{
   [ self.navigationController.formSheetController mz_dismissFormSheetControllerAnimated: YES
                                                                       completionHandler: nil ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self reloadAccountData ];
}

@end
