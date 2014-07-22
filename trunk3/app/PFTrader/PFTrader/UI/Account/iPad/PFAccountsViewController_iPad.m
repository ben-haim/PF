#import "PFAccountsViewController_iPad.h"

#import "PFAccountsViewController.h"
#import "PFAccountDetailViewController.h"
#import "PFReportsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountsViewController_iPad ()< PFAccountsViewControllerDelegate >

@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation PFAccountsViewController_iPad

@synthesize account;

-(id)init
{
   self = [ super init ];
   if (self)
   {
      self.title = NSLocalizedString( @"ACCOUNTS", nil );
   }
   return self;
}

-(void)showAccount:( id< PFAccount > )account_
{
   self.title = account_.name;
   self.account = account_;
   
   PFAccountDetailViewController* detail_controller_ = [ PFAccountDetailViewController detailControllerWithAccount: account_ ];
   detail_controller_.parentNavigation = self.navigationController;
   detail_controller_.view.backgroundColor = [ UIColor clearColor ];
   [ detail_controller_.backgroundView removeFromSuperview ];
   
   self.detailController = detail_controller_;
}

-(void)reports
{
   PFReportsViewController* controller_ = [ [ PFReportsViewController alloc ] initWithAccount: self.account ];
   [ self.navigationController pushViewController: controller_ animated: YES ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   PFAccountsViewController* accounts_controller_ = [ PFAccountsViewController new ];
   accounts_controller_.delegate = self;
   
   accounts_controller_.view.backgroundColor = [ UIColor clearColor ];
   [ accounts_controller_.backgroundView removeFromSuperview ];
   self.masterController = accounts_controller_;

   id< PFAccount > default_account_ = [ PFSession sharedSession ].accounts.defaultAccount;
   [ self showAccount: default_account_ ];

   if ( [ PFSession sharedSession ].supportedReportTypes.count > 0 )
   {
      self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString(@"REPORTS", nil)
                                                                                   style: UIBarButtonItemStyleBordered
                                                                                  target: self
                                                                                  action: @selector( reports )];
   }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PFAccountsViewControllerDelegate

-(void)accountsViewController:( PFAccountsViewController* )controller_
             didSelectAccount:( id< PFAccount > )account_
{
   [ self showAccount: account_ ];
}

@end
