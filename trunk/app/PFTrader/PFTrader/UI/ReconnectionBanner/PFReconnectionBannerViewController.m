#import "PFReconnectionBannerViewController.h"
#import "PFSystemHelper.h"

@interface PFReconnectionBannerViewController ()

@end

@implementation PFReconnectionBannerViewController

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( useFlatUI() )
   {
      [ self setNeedsStatusBarAppearanceUpdate ];
   }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
   return UIStatusBarStyleLightContent;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
