#import "PFIndicatorsViewController.h"
#import "PFIndicatorCell.h"
#import "PFIndicator.h"
#import "PFNavigationController.h"

#import "UIColor+Skin.h"

@interface PFIndicatorsViewController ()

@property ( nonatomic, strong ) NSArray* indicators;

@end

@implementation PFIndicatorsViewController

@synthesize indicators;
@synthesize closeBlock;
@synthesize delegate;

-(id)initWithIndicators:( NSArray* )indicators_
{
   self = [ self initWithStyle: UITableViewStylePlain ];
   if (self)
   {
      self.title = NSLocalizedString( @"ALL_INDICATORS", nil );
      self.indicators = indicators_;
   }
   return self;
}

-(void)done
{
   self.closeBlock();
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( self.closeBlock )
   {
      self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                                                 style: UIBarButtonItemStylePlain
                                                                                                                target: self
                                                                                                                action: @selector( done ) ];
   }
   
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.tableView.backgroundColor = [ UIColor backgroundLightColor ];
}

#pragma mark - Table view data source

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return [ self.indicators count ];
}

-(UITableViewCell*)tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFIndicatorCell";

   PFIndicatorCell* cell_ = ( PFIndicatorCell* )[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = [ PFIndicatorCell cell ];
   }

   PFIndicator* indicator_ = (self.indicators)[index_path_.row];
   cell_.nameLabel.text = indicator_.title;
   cell_.removeButton.hidden = YES;

   return cell_;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   [ self.delegate indicatorsController: self
                        didSelectIndicator: (self.indicators)[index_path_.row] ];
}

@end
