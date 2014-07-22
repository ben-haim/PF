#import "PFModalWindow.h"
#import "UIViewController+Wrapper.h"

@implementation PFModalWindow

+(void)showWithController:( UIViewController* )controller_
{
   [ PFModalWindow showWithNavigationController: [ controller_ wrapIntoNavigationController ] ];
}

+(void)showWithNavigationController:( UINavigationController* )navigation_controller_
{
   MZFormSheetController* form_sheet_ = [ [ MZFormSheetController alloc ] initWithViewController: navigation_controller_ ];
   form_sheet_.shouldDismissOnBackgroundViewTap = NO;
   form_sheet_.transitionStyle = MZFormSheetTransitionStyleFade;
   form_sheet_.cornerRadius = 8.0;
   form_sheet_.portraitTopInset = 0.f;
   form_sheet_.shouldCenterVertically = YES;
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      form_sheet_.presentedFormSheetSize = CGSizeMake( 800.f, 640.f );
   }
   else
   {
      form_sheet_.presentedFormSheetSize = CGSizeMake( [ [ UIScreen mainScreen ] bounds ].size.width - 20.f, [ [ UIScreen mainScreen ] bounds ].size.height - 38.f );
   }
   
   [ form_sheet_ presentAnimated: YES
               completionHandler: nil ];
}

@end
