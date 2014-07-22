#import "PFChangePasswordViewController_iPad.h"

@implementation PFChangePasswordViewController_iPad

+(id)changePasswordControllerWithSession:( PFSession* )current_session_
{
   return [ [ PFChangePasswordViewController_iPad alloc ] initWithTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil )
                                                             andSession: current_session_ ];
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
