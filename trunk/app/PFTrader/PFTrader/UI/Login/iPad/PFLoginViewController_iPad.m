#import "PFLoginViewController_iPad.h"

#import "PFRegistrationViewController_iPad.h"
#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFLoginViewController_iPad

-(PFRegistrationViewController*)createRegistrationController
{
   return [ [ PFRegistrationViewController_iPad alloc ] initWithServerInfo: [ [ PFServerInfo alloc ] initWithServers: [ PFBrandingSettings sharedBranding ].brandingServer
                                                                                                              secure: NO ] ];
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
