#import "PFAccountsViewController.h"

#import "PFAccountDetailViewController.h"

#import "PFTableViewCategory.h"
#import "PFTableView.h"

#import "PFTableViewItem+Accounts.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountsViewController ()< PFSessionDelegate >

@property ( nonatomic, strong, readonly ) NSArray* accounts;

@end

@implementation PFAccountsViewController

@synthesize delegate;
@dynamic accounts;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super init ];
   if (self)
   {
      self.title = NSLocalizedString( @"ACCOUNTS", nil );
   }
   return self;
}

-(void)showDetailsForAccount:( id< PFAccount > )account_
{
   if ( [ self.delegate respondsToSelector: @selector(accountsViewController:didSelectAccount:) ] )
   {
      [ self.delegate accountsViewController: self didSelectAccount: account_ ];
   }
   else
   {
      PFAccountDetailViewController* detail_controller_ = [ PFAccountDetailViewController detailControllerWithAccount: account_ ];
      [ self.navigationController pushViewController: detail_controller_ animated: YES ];
   }
}

-(void)reloadData
{
   id< PFAccounts > accounts_ = [ PFSession sharedSession ].accounts;

   __weak PFAccountsViewController* unsafe_controller_ = self;

   PFTableViewCategory* active_account_category_ = [  PFTableViewCategory new ];
   PFTableViewItem* default_account_item_ = [ PFTableViewItem itemWithDefaultAccount: accounts_.defaultAccount ];
   default_account_item_.action = ^( PFTableViewItem* item_ )
   {
      [ unsafe_controller_ showDetailsForAccount: accounts_.defaultAccount ];
   };

   active_account_category_.items = [ NSArray arrayWithObject: default_account_item_ ];

   NSMutableArray* other_items_ = [ NSMutableArray arrayWithCapacity: [ accounts_.accounts count ] - 1 ];
   
   for ( id< PFAccount > account_ in accounts_.accounts )
   {
      if ( account_ != accounts_.defaultAccount )
      {
         PFTableViewItem* account_item_ = [ PFTableViewItem itemWithAccount: account_ ];
         account_item_.action = ^( PFTableViewItem* item_ )
         {
            [ unsafe_controller_ showDetailsForAccount: account_ ];
         };
         [ other_items_ addObject: account_item_ ];
      }
   }
   
   PFTableViewCategory* inactive_account_category_ = nil;
   if ( [ other_items_ count ] > 0 )
   {
      inactive_account_category_ = [ PFTableViewCategory categoryWithTitle: NSLocalizedString( @"ACCOUNT_DETAILS", nil )
                                                                     items: other_items_ ];
   }

   self.tableView.categories = [ NSArray arrayWithObjects: active_account_category_, inactive_account_category_, nil ];

   [ self.tableView reloadData ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   [ self reloadData ];
}

#pragma mark PFSessionDelegate

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
