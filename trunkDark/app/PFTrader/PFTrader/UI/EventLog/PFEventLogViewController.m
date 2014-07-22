#import "PFEventLogViewController.h"
#import "PFEventBrowserViewController.h"
#import "PFNavigationController.h"
#import "PFModalWindow.h"
#import "PFStoryCell.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFEventLogViewController () < PFSessionDelegate, UITableViewDelegate >

@end

@implementation PFEventLogViewController

@synthesize delegate;

+(BOOL)isAvailable
{
   return [ PFSession sharedSession ].allowsEventLog;
}

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [super initWithStyle: UITableViewStylePlain ];
   if (self)
   {
      self.title = NSLocalizedString( @"EVENT_LOG", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   
   self.clearsSelectionOnViewWillAppear = NO;
   
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [ UIColor backgroundLightColor ] : [ UIColor backgroundDarkColor ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      UINavigationController* current_navigation_ = self.pfNavigationController ? self.pfNavigationController : self.navigationController;
      
      [ current_navigation_.navigationBar setBackgroundImage: [ UIImage imageNamed: @"PFNavigationLight" ] forBarMetrics: UIBarMetricsDefault ];
      [ current_navigation_.navigationBar setShadowImage: [ UIImage headerDarkShadowImage ] ];
   }
}

-(NSArray*)events
{
   return [ PFSession sharedSession ].events;
}

#pragma mark - Table cell height

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return 70;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)table_view_ numberOfRowsInSection:(NSInteger)section_
{
   return [ self.events count ];
}

-( UITableViewCell* )tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFEventCell";
   
   PFStoryCell* cell_ = [ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = [ PFStoryCell cell ];
   }
   
   cell_.report = [ self.events objectAtIndex: index_path_.row ];
   
   return cell_;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   id< PFReportTable > report_ = [ self.events objectAtIndex: index_path_.row ];
   
   if ( [ self.delegate respondsToSelector: @selector(eventLogViewController:didSelectReport:) ] )
   {
      [ self.delegate eventLogViewController: self didSelectReport: report_ ];
   }
   else
   {
      PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: [ [ PFEventBrowserViewController alloc ] initWithReport: report_ ] ];
      navigation_controller_.useCloseButton = YES;
      
      [ PFModalWindow showWithNavigationController: navigation_controller_ ];
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
 didLoadReport:( id< PFReportTable > )report_
{
   [ self.tableView reloadData ];
}

@end