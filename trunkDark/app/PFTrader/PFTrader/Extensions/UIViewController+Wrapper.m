#import "UIViewController+Wrapper.h"
#import "UINavigationBar+Skin.h"

@implementation UIViewController (Wrapper)

-(UINavigationController*)wrapIntoNavigationController
{
   UINavigationController* navigation_controller_ = [ [ UINavigationController alloc ] initWithRootViewController: self ];
   [ navigation_controller_.navigationBar applySkin ];
   
   return navigation_controller_;
}

@end

@implementation UINavigationController (Rotation)

-(BOOL)shouldAutorotate
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscape;
}

@end
