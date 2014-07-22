#import "PFViewController.h"
#import "PFNavigationController.h"
#import "PFSystemHelper.h"

#import "UIColor+Skin.h"
#import "UIImage+Skin.h"
#import "UIImage+Stretch.h"

@interface PFViewController ()

@end

@implementation PFViewController

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.view.backgroundColor = [ UIColor backgroundDarkColor ];
   if ( useFlatUI() )
   {
      [ self setNeedsStatusBarAppearanceUpdate ];
      self.edgesForExtendedLayout = UIRectEdgeNone;
   }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
   return UIStatusBarStyleLightContent;
}

-(void)setDarkNavigationBar
{
   UINavigationController* current_navigation_ = self.pfNavigationController ? self.pfNavigationController : self.navigationController;
   
   [ current_navigation_.navigationBar setBackgroundImage: [ UIImage imageNamed: @"PFNavigationDark" ] forBarMetrics: UIBarMetricsDefault ];
   [ current_navigation_.navigationBar setShadowImage: [ UIImage headerDarkShadowImage ] ];
}

-(void)setLightNavigationBar
{
   UINavigationController* current_navigation_ = self.pfNavigationController ? self.pfNavigationController : self.navigationController;
   
   [ current_navigation_.navigationBar setBackgroundImage: [ UIImage imageNamed: @"PFNavigation" ] forBarMetrics: UIBarMetricsDefault ];
   [ current_navigation_.navigationBar setShadowImage: [ UIImage headerDarkShadowImage ] ];
}

-(void)setSuperLightNavigationBar
{
   UINavigationController* current_navigation_ = self.pfNavigationController ? self.pfNavigationController : self.navigationController;
   
   [ current_navigation_.navigationBar setBackgroundImage: [ UIImage imageNamed: @"PFNavigationLight" ] forBarMetrics: UIBarMetricsDefault ];
   [ current_navigation_.navigationBar setShadowImage: [ UIImage headerDarkShadowImage ] ];
}

@end
