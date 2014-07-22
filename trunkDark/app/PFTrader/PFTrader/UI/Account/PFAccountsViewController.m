#import "PFAccountsViewController.h"
#import "PFAccountInfoViewController.h"
#import "PFNavigationController.h"
#import "PFTableViewItem+Accounts.h"
#import "PFTableViewCategory.h"
#import "PFTableView.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountsViewController () < PFSessionDelegate >

@end

@implementation PFAccountsViewController

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"ACCOUNTS", nil );
   }
   
   return self;
}

-(void)showDetailsForAccount:( id< PFAccount > )account_
{
   [ self.pfNavigationController pushViewController: [ PFAccountInfoViewController infoControllerWithAccount: account_ ]
                                           animated: YES ];
}

-(void)reloadData
{
   id< PFAccounts > accounts_ = [ PFSession sharedSession ].accounts;
   __weak PFAccountsViewController* weak_controller_ = self;
   NSMutableArray* account_categories_ = [ NSMutableArray arrayWithCapacity: accounts_.accounts.count ];
   
   for ( id< PFAccount > account_ in accounts_.accounts )
   {
      PFTableViewItem* account_item_ = [ PFTableViewItem itemWithAccount: account_
                                                               isDefault: account_ == accounts_.defaultAccount ];
      account_item_.action = ^( PFTableViewItem* item_ ) { [ weak_controller_ showDetailsForAccount: account_ ]; };
      [ account_categories_ addObject: [ PFTableViewCategory categoryWithTitle: nil
                                                                         items: @[account_item_] ] ];
   }
   
   self.tableView.categories = account_categories_;
   [ self.tableView reloadData ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.tableView.skipCellsBackground = YES;
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self reloadData ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didSelectDefaultAccount:( id< PFAccount > )account_
{
   [ self reloadData ];
}

-(void)didReconnectedSessionWithNewSession:(PFSession *)session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self reloadData ];
}

@end
