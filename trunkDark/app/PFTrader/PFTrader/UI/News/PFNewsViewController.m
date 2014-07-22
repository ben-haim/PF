#import "PFNewsViewController.h"
#import "PFNewsBrowserViewController.h"
#import "PFNavigationController.h"
#import "PFModalWindow.h"
#import "PFBrandingSettings.h"
#import "PFStoryCell.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFNewsViewController () < PFSessionDelegate, UITableViewDelegate >

@end

@implementation PFNewsViewController

@synthesize delegate;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [super initWithStyle: UITableViewStylePlain ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"NEWS", nil );
   }
   
   return self;
}

+(BOOL)isAvailable
{
   return [ PFBrandingSettings sharedBranding ].useNews && [ PFSession sharedSession ].allowsNews;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];

   self.clearsSelectionOnViewWillAppear = NO;
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.tableView.backgroundColor = [ UIColor clearColor ];
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

-(NSArray*)stories
{
   return [ PFSession sharedSession ].stories.stories;
}

#pragma mark - Table cell height

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return 70;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)table_view_ numberOfRowsInSection:(NSInteger)section_
{
   return [ self.stories count ];
}

-( UITableViewCell* )tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFStoryCell";

   PFStoryCell* cell_ = [ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ PFStoryCell cell ];
   }

   cell_.story = [ self.stories objectAtIndex: index_path_.row ];

   return cell_;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   id< PFStory > story_ = [ self.stories objectAtIndex: index_path_.row ];

   if ( [ self.delegate respondsToSelector: @selector(newsViewController:didSelectStory:) ] )
   {
      [ self.delegate newsViewController: self didSelectStory: story_ ];
   }
   else
   {
      PFNavigationController* navigation_controller_ = [ PFNavigationController navigationControllerWithController: [ [ PFNewsBrowserViewController alloc ] initWithStory: story_ ] ];
      navigation_controller_.useCloseButton = YES;
      
      [ PFModalWindow showWithNavigationController: navigation_controller_ ];
   }
}

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories
{
   [ self.tableView reloadData ];
}

-(void)didReconnectedSessionWithNewSession:( PFSession* )session_
{
   [ [ PFSession sharedSession ] addDelegate: self ];
   [ self.tableView reloadData ];
}

@end
