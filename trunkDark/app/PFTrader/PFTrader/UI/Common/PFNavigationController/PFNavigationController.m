#import "PFNavigationController.h"
#import "PFSNavigationViewController.h"
#import "UINavigationBar+Skin.h"
#import "PFSystemHelper.h"

#import <objc/runtime.h>

static const char* PFNavigationControllerAssociatedKey = "PFNavigationControllerAssociatedKey";
static const char* PFNavigationWrapperControllerAssociatedKey = "PFNavigationWrapperControllerAssociatedKey";

@implementation UIViewController ( PFS_NAVIGATION_OBJC_ASSOCIATION )

-(PFNavigationController*)pfNavigationController
{
   return objc_getAssociatedObject( self, PFNavigationControllerAssociatedKey );
}

-(void)setPfNavigationController:( PFNavigationController* )navigation_controller_
{
   objc_setAssociatedObject( self, PFNavigationControllerAssociatedKey, navigation_controller_, OBJC_ASSOCIATION_ASSIGN );
}

-(UIViewController*)pfNavigationWrapperController
{
   return objc_getAssociatedObject( self, PFNavigationWrapperControllerAssociatedKey );
}

-(void)setPfNavigationWrapperController:( UIViewController* )wrapper_controller_
{
   objc_setAssociatedObject( self, PFNavigationWrapperControllerAssociatedKey, wrapper_controller_, OBJC_ASSOCIATION_ASSIGN );
}

@end

@implementation PFNavigationController

@synthesize navigationTitle;
@synthesize useCloseButton;

+(id)navigationControllerWithController:( UIViewController* )controller_
{
   return [ [ PFNavigationController alloc ] initWithRootViewController: controller_ ];
}

-(void)dealloc
{
   self.navigationTitle = nil;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
   self = [ super initWithRootViewController: rootViewController ];
   
   if ( self )
   {
      [ self.navigationBar applySkin ];
   }
   
   return self;
}

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

-(void)pushViewController:( UIViewController* )view_controller_
            previousTitle:( NSString* )previous_title_
                 animated:( BOOL )animated_
{
   PFSNavigationViewController* wrapped_controller_ = [ [ PFSNavigationViewController alloc ] initWithRootController: view_controller_
                                                                                             previousControllerTitle: previous_title_ ];
   view_controller_.pfNavigationWrapperController = wrapped_controller_;
   view_controller_.pfNavigationController = self;
   
   if ( self.viewControllers.count == 0 )
   {
      self.navigationTitle = view_controller_.title;
      wrapped_controller_.isFirstInStack = YES;
   }
   
   [ super pushViewController: wrapped_controller_ animated: animated_ ];
   
   wrapped_controller_.navigationItem.title = self.navigationTitle;
   wrapped_controller_.navigationItem.hidesBackButton = YES;
}

-(void)pushViewController:( UIViewController* )view_controller_ animated:( BOOL )animated_
{
   [ self pushViewController: view_controller_
               previousTitle: self.viewControllers.count == 0 ? @"" : [ self.viewControllers.lastObject currentTitle ]
                    animated: animated_ ];
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return [ UIDevice currentDevice ].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? UIInterfaceOrientationMaskPortrait : UIInterfaceOrientationMaskLandscape;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
   return NO;
}

@end
