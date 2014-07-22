#import "PFAccountDetailViewController.h"

#import "PFAccountDetailDataSource.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountDetailViewController ()< PFSessionDelegate >

@property ( nonatomic, strong ) NSArray* dataSources;
@property ( nonatomic, strong ) id< PFAccount > account;

@end

@implementation PFAccountDetailViewController

@synthesize headerView = _headerView;
@synthesize informationSwitchBox = _informationSwitchBox;

@synthesize dataSources = _dataSources;
@synthesize account = _account;

-(PFAccountDetailDataSource*)currentDataSource
{
   return [ self.dataSources objectAtIndex: self.informationSwitchBox.selectedSegmentIndex ];
}

-(void)dealloc
{
   [ _headerView release ];
   [ _informationSwitchBox release ];
   [ _dataSources release ];
   [ _account release ];

   [ super dealloc ];
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
   return [ [ [ self alloc ] initWithAccount: account_ ] autorelease ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.tableView.tableHeaderView = self.headerView;
   self.dataSources = [ NSArray arrayWithObjects: [ PFAccountDetailDataSource todayDataSource ]
                       , [ PFAccountDetailDataSource activityDataSource ]
                       , [ PFAccountDetailDataSource generalDataSource ]
                       , nil ];
}

-(void)viewDidUnload
{
   [ super viewDidUnload ];

   self.headerView = nil;
   self.informationSwitchBox = nil;
   self.dataSources = nil;
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ [ PFSession sharedSession ] addDelegate: self ];

   [ super viewWillAppear: animated_ ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];

   [ [ PFSession sharedSession ] removeDelegate: self ];
}

#pragma mark - Table view data source

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return [ self.currentDataSource numberOfRows ];
}

-( UITableViewCell* )tableView:( UITableView* )table_view_
         cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return [ self.currentDataSource cellForAccount: self.account
                                        tableView: table_view_
                                              row: index_path_.row ];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(IBAction)informationSwitchAction:( id )sender_
{
   [ self.tableView reloadData ];
}

@end
