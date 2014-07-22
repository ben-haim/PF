#import "PFCountriesViewController.h"

#import "PFCountryCell.h"

#import "PFCountry.h"

@interface PFCountriesViewController ()

@property ( nonatomic, strong ) NSArray* countries;
@property ( nonatomic, strong ) PFCountry* selectedCountry;

@end

@implementation PFCountriesViewController

@synthesize countries;
@synthesize selectedCountry;

@synthesize delegate;

- (id)init
{
   self = [ super initWithStyle: UITableViewStylePlain ];
   if (self)
   {
      self.title = NSLocalizedString( @"SELECT_COUNTRY", nil );
      self.countries = [ PFCountry defaultCountries ];
   }
   return self;
}

- (void)viewDidLoad
{
   [ super viewDidLoad ];

   // Uncomment the following line to preserve selection between presentations.
   self.clearsSelectionOnViewWillAppear = NO;
   
   // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
   self.tableView.separatorColor = [ UIColor darkGrayColor ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
    return [ self.countries count ];
}

-( UITableViewCell* )tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* identifier_ = @"PFCountryCell";
   PFCountryCell* cell_ = ( PFCountryCell* )[ table_view_ dequeueReusableCellWithIdentifier: identifier_ ];
   if ( !cell_ )
   {
      cell_ = [ PFCountryCell cell ];
   }

   PFCountry* country_ = (self.countries)[index_path_.row];
   cell_.nameLabel.text = country_.name;
   cell_.accessoryType = self.selectedCountry == country_
      ? UITableViewCellAccessoryCheckmark
      : UITableViewCellAccessoryNone;

   return cell_;
}

#pragma mark - Table view delegate

-(void)tableView:( UITableView* )table_view_ didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
   self.selectedCountry = (self.countries)[index_path_.row];
   [ self.tableView reloadData ];
   [ self.delegate countriesController: self didSelectCountry: self.selectedCountry ];
}

@end
