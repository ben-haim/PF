#import "PFLoginViewController_iPad.h"

#import "PFRegistrationViewController_iPad.h"
#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFLoginViewController_iPad

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.steelImageView.image = [ UIImage imageNamed: @"PFLoginScreenBackground_iPad" ];
   CGRect steel_image_frame_ = self.steelImageView.frame;
   steel_image_frame_.size.height += 30.f;
   self.steelImageView.frame = steel_image_frame_;
}

-(PFRegistrationViewController*)createRegistrationController
{
   return [ [ PFRegistrationViewController_iPad alloc ] initWithServerInfo: [ [ PFServerInfo alloc ] initWithServers: [ PFBrandingSettings sharedBranding ].brandingServer
                                                                                                              secure: NO
                                                                                                             useHTTP: [ PFBrandingSettings sharedBranding ].useHTTP ] ];
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
   return UIInterfaceOrientationMaskLandscape;
}

@end
