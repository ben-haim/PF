#import "PFReportsViewController.h"
#import "PFReportGridViewController.h"
#import "PFNavigationController.h"
#import "PFModalWindow.h"
#import "PFLoadingView.h"
#import "PFTableView.h"
#import "PFTableViewCategory+Report.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

static NSString* NSStringFromPFReportTableType( PFReportTableType type_ )
{
   switch ( type_ )
   {
      case PFReportTableTypeAccountStatement:
         return NSLocalizedString( @"REPORT_STATEMENT", nil );
      case PFReportTableTypeBalance:
         return NSLocalizedString( @"REPORT_BALANCE", nil );
      case PFReportTableTypeBalanceSummary:
         return NSLocalizedString( @"REPORT_BALANCE_SUMMARY", nil );
      case PFReportTableTypeCommissions:
         return NSLocalizedString( @"REPORT_COMMISSIONS", nil );
      case PFReportTableTypeTrades:
         return NSLocalizedString( @"REPORT_TRADES", nil );
      case PFReportTableTypeOrderHistory:
         return NSLocalizedString( @"REPORT_ORDER_HISTORY", nil );
      case PFReportTableTypeSummary:
         return NSLocalizedString( @"REPORT_SUMMARY", nil );
      default:
         return nil;
   }
}

@interface PFReportsViewController ()

@property ( nonatomic, strong ) id< PFAccount > account;
@property ( nonatomic, strong ) NSArray* categories;
@property ( nonatomic, strong ) PFSearchCriteria* criteria;

@end

@implementation PFReportsViewController

@synthesize account;
@synthesize categories = _categories;
@synthesize criteria;
@synthesize reportButton;

-(NSArray*)categories
{
   if ( !_categories )
   {
      _categories = [ NSArray arrayWithObjects:
                     [ PFTableViewCategory tableTypeCategoryWithCriteria: self.criteria ]
                     , [ PFTableViewCategory fromDateCategoryWithCriteria: self.criteria ]
                     , [ PFTableViewCategory toDateCategoryWithCriteria: self.criteria ]
                     , nil ];
   }
   return _categories;
}

-(void)dealloc
{
   self.categories = nil;
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];

   if ( self )
   {
      self.title = NSLocalizedString( @"REPORTS", nil );
      self.account = account_;

      self.criteria = [ [ PFSearchCriteria alloc ] initWithServerOffset: [ PFSession sharedSession ].user.timeZoneOffset ];
      self.criteria.tableType = PFReportTableTypeAccountStatement;
      self.criteria.fromDate = [ [ NSDate date ] dateByAddingTimeInterval: -1 * 24 * 60 * 60 ];
      self.criteria.toDate = [ NSDate date ];
      self.criteria.login = self.account.name;
   }

   return self;
}

-(id)init
{
   return [ self initWithAccount: [ PFSession sharedSession ].accounts.defaultAccount ];
}

- (void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.reportButton setTitle: NSLocalizedString( @"GET_REPORT_BUTTON", nil ) forState: UIControlStateNormal ];
   
   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

-(IBAction)reportAction:( id )sender_
{
   PFLoadingView* loading_view_ = [ PFLoadingView new ];

   [ loading_view_ showInView: self.view ];

   [ [ PFSession sharedSession ] reportTableWithCriteria: self.criteria
                                               doneBlock: ^( id< PFReportTable > report_table_, NSError* error_ )
   {
      [ loading_view_ hide ];
      if ( error_ )
      {
         [ error_ showAlertWithTitle: nil ];
      }
      else if ( [ report_table_.rows count ] == 0 )
      {
         [ JFFAlertView showAlertWithTitle: nil description: NSLocalizedString( @"EMPTY_REPORT", nil ) ];
      }
      else
      {
         PFReportGridViewController* controller_ = [ [ PFReportGridViewController alloc ] initWithReportTable: report_table_ ];
         controller_.title = NSStringFromPFReportTableType( self.criteria.tableType );
         
         if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
         {
            PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: controller_ ];
            navigation_controller_.useCloseButton = YES;
            
            [ PFModalWindow showWithNavigationController: navigation_controller_ ];
         }
         else
         {
            [ self.pfNavigationController pushViewController: controller_ animated: YES ];
         }
      }
   } ];
}

@end
