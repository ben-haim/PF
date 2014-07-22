#import "PFNavigationController.h"
#import "UINavigationBar+Skin.h"

@interface PFNavigationController ()

@end

@implementation PFNavigationController


-(id)initWithRootViewController:(UIViewController *)rootViewController
{
   self = [ super initWithRootViewController: rootViewController ];
   
   if ( self )
   {
      [ self.navigationBar applySkin ];
      self.modalPresentationStyle = UIModalPresentationFormSheet;
   }
   
   return self;
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

- (BOOL)disablesAutomaticKeyboardDismissal
{
   return NO;
}

@end
