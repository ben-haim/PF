#import "PFTableViewController.h"

#import <UIKit/UIKit.h>

@protocol PFAccountsViewControllerDelegate;

@interface PFAccountsViewController : PFTableViewController

@property ( nonatomic, weak ) id< PFAccountsViewControllerDelegate > delegate;

@end

@protocol PFAccount;

@protocol PFAccountsViewControllerDelegate <NSObject>

-(void)accountsViewController:( PFAccountsViewController* )controller_
             didSelectAccount:( id< PFAccount > )account_;

@end
