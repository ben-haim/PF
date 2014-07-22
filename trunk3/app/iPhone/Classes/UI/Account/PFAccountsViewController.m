#import "PFAccountsViewController.h"

#import "PFAccountDetailViewController.h"

#import "PFAccountCell.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountsViewController ()

@property ( nonatomic, strong, readonly ) NSArray* accounts;

@end

@implementation PFAccountsViewController

@dynamic accounts;

-(NSArray*)accounts
{
   return [ PFSession sharedSession ].accounts.accounts;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   // Uncomment the following line to preserve selection between presentations.
   // self.clearsSelectionOnViewWillAppear = NO;

   // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ self.accounts count ];
}

-(UITableViewCell*)tableView:( UITableView* )table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFAccountCell";
   PFAccountCell *cell_ = (PFAccountCell*)[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ PFAccountCell accountCell ];
   }
   
   id< PFAccount > account_ = [ self.accounts objectAtIndex: index_path_.row ];

   [ cell_ setModel: account_ ];

   return cell_;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   id< PFAccount > account_ = [ self.accounts objectAtIndex: index_path_.row ];

   PFAccountDetailViewController* detail_controller_ = [PFAccountDetailViewController detailControllerWithAccount: account_ ];

   [ self.navigationController pushViewController: detail_controller_ animated: YES ];
}

@end
