#import "PFAccountsViewController_iPad.h"
#import "PFAccountCardsViewController.h"
#import "PFChoicesViewController.h"
#import "PFAccountInfoViewController_iPad.h"
#import "PFAccountTransferViewController.h"
#import "PFReportsViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAccountsViewController_iPad () < PFAccountCardsViewControllerDelegate >

@end

@implementation PFAccountsViewController_iPad

-(id)init
{
   PFAccountCardsViewController* accounts_controller_ = [ PFAccountCardsViewController new ];
   accounts_controller_.delegate = self;
   
   self = [ super initWithMasterController: accounts_controller_ ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"ACCOUNTS", nil );
   }
   
   return self;
}

#pragma mark - PFAccountCardsViewControllerDelegate

-(void)accountCardsViewController:( PFAccountCardsViewController* )controller_
                 didSelectAccount:( id< PFAccount > )account_
{
   PFAccountInfoViewController_iPad* info_controller_ = [ PFAccountInfoViewController_iPad infoControllerWithAccount: account_ ];
   PFAccountTransferViewController* transfer_controller_ = [ [ PFAccountTransferViewController alloc ] initWithAccount: account_ ];
   PFReportsViewController* reports_controller_ = [ [ PFReportsViewController alloc ] initWithAccount: account_ ];
   
   NSArray* sources_ = @[ [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"PERFORMANCE", nil )
                                                               controller: info_controller_ ],
                          [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"TRANSFER_TITLE", nil )
                                                               controller: transfer_controller_ ],
                          [ PFChoicesViewControllerSource sourceWithTitle: NSLocalizedString( @"REPORTS", nil )
                                                               controller: reports_controller_ ] ];
   
   
   [ self showDetailController: [ PFChoicesViewController choicesControllerWithSources: sources_
                                                                                 title: account_.name ] ];
}

@end
