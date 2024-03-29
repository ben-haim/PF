#import "PFAccountDetailViewController.h"

#import "PFReportsViewController.h"
#import "PFWithdrawalViewController.h"
#import "PFTransferViewController.h"

#import "PFTableView.h"
#import "PFSegmentedControl.h"

#import "PFTableViewCategory+AccountDetail.h"
#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

typedef enum
{
   PFAccountDetailTodayTab
   , PFAccountDetailActivityTab
   , PFAccountDetailGeneralTab
} PFAccountDetailTab;

@interface PFAccountDetailViewController ()< PFSessionDelegate, PFSegmentedControlDelegate >

@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation PFAccountDetailViewController

@synthesize footerView;
@synthesize headerView;
@synthesize informationSwitchBox;
@synthesize makeActiveButton;
@synthesize withdrawalButton;
@synthesize transferButton;
@synthesize parentNavigation;

@synthesize account;

//!Workaround for assign delegate
-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];

    self.footerView = nil;
    self.headerView = nil;
    self.informationSwitchBox = nil;
    self.makeActiveButton = nil;
    self.withdrawalButton = nil;
    self.transferButton = nil;
    self.parentNavigation = nil;
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   if ( self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ] )
   {
      self.title = account_.name;
      self.account = account_;
   }
   return self;
}

+(id)detailControllerWithAccount:( id< PFAccount > )account_
{
   return [ [ self alloc ] initWithAccount: account_ ];
}

-(PFTableViewCategory*)activeCategory
{
   switch ( self.informationSwitchBox.selectedSegmentIndex )
   {
      case PFAccountDetailTodayTab:
         return [ PFTableViewCategory todayCategoryWithAccount: self.account ];
      case PFAccountDetailActivityTab:
         return [ PFTableViewCategory activityCategoryWithAccount: self.account ];
      case PFAccountDetailGeneralTab:
         return [ PFTableViewCategory generalCategoryWithAccount: self.account ];
   }

   return nil;
}

-(void)reloadDataAnimated:( BOOL )animated_
{
   PFTableViewCategory* active_category_ = self.activeCategory;
   self.tableView.categories = [ NSArray arrayWithObject: active_category_ ];

   if ( animated_ )
   {
      [ self.tableView reloadCategory: active_category_ withRowAnimation: UITableViewRowAnimationFade ];
   }
   else
   {
      [ self.tableView reloadData ];
   }
}

-(void)reports
{
   PFReportsViewController* controller_ = [ [ PFReportsViewController alloc ] initWithAccount: self.account ];
   [ self.navigationController pushViewController: controller_ animated: YES ];
}

-(void)updateTableFooterView
{
   PFSession* session_ = [ PFSession sharedSession ];
   
   BOOL need_make_active_ = self.account != session_.accounts.defaultAccount;
   BOOL need_withdrawal_ = self.account.allowsWithdrawal;
   BOOL need_transfer_ = session_.accounts.accounts.count > 1 && [ PFBrandingSettings sharedBranding ].useTransfer;
   
   self.tableView.tableFooterView = ( need_make_active_ || need_withdrawal_ || need_transfer_ ) ? self.footerView : nil;
   
   if ( !need_make_active_ )
   {
      self.transferButton.frame = self.withdrawalButton.frame;
      self.withdrawalButton.frame = self.makeActiveButton.frame;
      self.makeActiveButton.hidden = YES;
   }
   
   if ( !need_withdrawal_ )
   {
      self.transferButton.frame = self.withdrawalButton.frame;
      self.withdrawalButton.hidden = YES;
   }
   
   if ( !need_transfer_ )
   {
      self.transferButton.hidden = YES;
   }
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   PFSession* session_ = [ PFSession sharedSession ];
   
   if ( session_.supportedReportTypes.count > 0 )
   {
      self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString(@"REPORTS", nil)
                                                                                   style: UIBarButtonItemStyleBordered
                                                                                  target: self
                                                                                  action: @selector( reports )];
   }

   [ session_ addDelegate: self ];

   [ self.makeActiveButton setTitle: NSLocalizedString( @"MAKE_ACTIVE", nil ) forState: UIControlStateNormal ];
   [ self.withdrawalButton setTitle: NSLocalizedString( @"WITHDRAWAL_TITLE", nil ) forState: UIControlStateNormal ];
   [ self.transferButton setTitle: NSLocalizedString( @"TRANSFER_TITLE", nil ) forState: UIControlStateNormal ];
   
   self.informationSwitchBox.font = [ UIFont boldSystemFontOfSize: 17.f ];
   self.informationSwitchBox.items = [ NSArray arrayWithObjects: NSLocalizedString( @"TODAY", nil )
                                      , NSLocalizedString( @"ACTIVITY", nil )
                                      , NSLocalizedString( @"GENERAL", nil )
                                      , nil ];

   [ self updateTableFooterView ];

   self.informationSwitchBox.selectedSegmentIndex = 0;
   [ self reloadDataAnimated: NO ];

   self.informationSwitchBox.delegate = self;
}

-(void)showController:( UIViewController* )controller_
{
   [ ( self.parentNavigation ? self.parentNavigation : self.navigationController ) pushViewController: controller_ animated: YES ];
}

-(IBAction)makeActiveAction:( id )sender_
{
   [ [ PFSession sharedSession ] selectDefaultAccount: self.account ];
   [ self updateTableFooterView ];
}

-(IBAction)withdrawalAction:( id )sender_
{
   [ self showController: [ [ PFWithdrawalViewController alloc ] initWithAccount: self.account ] ];
}

-(IBAction)transferAction:( id )sender_
{
   [ self showController: [ [ PFTransferViewController alloc ] initWithAccount: self.account ] ];
}

#pragma mark PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self reloadDataAnimated: YES ];
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
didUpdateAccount:( id< PFAccount > )account_
{
   [ self reloadDataAnimated: NO ];
}

@end
