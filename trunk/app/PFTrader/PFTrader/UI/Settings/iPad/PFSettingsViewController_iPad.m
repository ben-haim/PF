#import "PFSettingsViewController_iPad.h"

#import "PFChangePasswordViewController_iPad.h"
#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFSettingsViewController_iPad

-(void)showChangePassword
{
   [ self.navigationController pushViewController: [ [ PFChangePasswordViewController_iPad alloc ] initWithTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil )
                                                                                                      andSession: [ PFSession sharedSession ] ]
                                         animated: YES ];
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

@end
