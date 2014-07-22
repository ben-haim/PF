#import "PFEventLogViewController.h"

#import "PFEventBrowserViewController.h"

#import "PFStoryCell.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFEventLogViewController () < PFSessionDelegate >

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
   self.tableView.backgroundColor = [ UIColor whiteColor ];
}

-(NSArray*)events
{
   return [ PFSession sharedSession ].events;
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
      PFEventBrowserViewController* browser_controller_ = [ [ PFEventBrowserViewController alloc ] initWithReport: report_ ];
      [ self.navigationController pushViewController: browser_controller_ animated: YES ];
   }
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
 didLoadReport:( id< PFReportTable > )report_
{
   [ self.tableView reloadData ];
}

@end