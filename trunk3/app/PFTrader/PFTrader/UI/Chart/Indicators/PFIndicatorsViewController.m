#import "PFIndicatorsViewController.h"

#import "PFIndicatorCell.h"

#import "PFIndicator.h"

#import "UIColor+Skin.h"

@interface PFIndicatorsViewController ()

@property ( nonatomic, strong ) NSArray* indicators;

@end

@implementation PFIndicatorsViewController

@synthesize indicators;

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

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.tableView.backgroundColor = [ UIColor whiteColor ];
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

   PFIndicator* indicator_ = [ self.indicators objectAtIndex: index_path_.row ];
   cell_.nameLabel.text = indicator_.title;

   return cell_;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   [ self.delegate indicatorsController: self
                        didSelectIndicator: [ self.indicators objectAtIndex: index_path_.row ] ];
}

@end
