#import "PFViewController.h"
#import "PFSystemHelper.h"

@interface PFViewController ()

@end

@implementation PFViewController

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
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

@end
