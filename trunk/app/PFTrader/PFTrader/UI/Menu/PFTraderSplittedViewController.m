#import "PFTraderSplittedViewController.h"

#import "PFSplittedView.h"

#import "PFSettingsViewController.h"

#import "DDMenuController+PFTrader.h"
#import "NSObject+KeyboardNotifications.h"

#import "UIColor+Skin.h"
#import "PFSystemHelper.h"

@interface PFTraderSplittedViewController ()< DDMenuControllerDelegate >

@end

@implementation PFTraderSplittedViewController

-(void)dealloc
{
   [ self unsubscribeKeyboardNotifications ];
}

-(DDMenuController*)topMenu
{
   return ( DDMenuController* )self.topViewController;
}

-(DDMenuController*)bottomMenu
{
   return ( DDMenuController* )self.bottomViewController;
}

- (void)menuController:( DDMenuController* )menu_controller_
willShowViewController:( UIViewController* )view_controller_
{
   if ( view_controller_ == self.topMenu.leftViewController )
   {
      self.splittedView.frame = self.view.bounds;
      [ self.bottomMenu showRootController: YES ];
   }
   else if ( view_controller_ == self.bottomMenu.leftViewController )
   {
      self.splittedView.frame = self.view.bounds;
      [ self.topMenu showRootController: YES ];
   }
}

-(void)toggleTopFullscreen
{
   [ self setState: self.state == PFSplittedViewStateTopFullscreen ? PFSplittedViewStatePart : PFSplittedViewStateTopFullscreen
          animated: YES ];
};

-(void)toggleBottomFullscreen
{
   [ self setState: self.state == PFSplittedViewStateBottomFullscreen ? PFSplittedViewStatePart : PFSplittedViewStateBottomFullscreen
          animated: YES ];
}

-(NSArray*)leftBarButtonItemsInMenuController:( DDMenuController* )menu_controller_
{
   BOOL top_ = menu_controller_ == self.topMenu;
   
   if ( top_ )
   {
      UIBarButtonItem* fullscreen_button_item_ = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: useFlatUI() ? @"PFFullscreenFlat" :  @"PFFullscreen" ]
                                                                                     style: UIBarButtonItemStyleBordered
                                                                                    target: self
                                                                                    action: top_ ? @selector( toggleTopFullscreen ) : @selector( toggleBottomFullscreen ) ];
      
      return [ NSArray arrayWithObject: fullscreen_button_item_ ];
   }
   else
   {
      return nil;
   }
}

+(id)splittedControllerWithTopMenu:( DDMenuController* )top_controller_
                        bottomMenu:( DDMenuController* )bottom_controller_
{
   PFTraderSplittedViewController* splitted_controller_ = [ self new ];

   splitted_controller_.topViewController = top_controller_;
   splitted_controller_.bottomViewController = bottom_controller_;

   top_controller_.delegate = splitted_controller_;
   bottom_controller_.delegate = splitted_controller_;

   return splitted_controller_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ self subscribeKeyboardNotifications ];
}

-(void)changeContentViewFrame:( CGRect )new_frame_
            animationDuration:( NSTimeInterval )duration_
{
   [ UIView animateWithDuration: duration_ animations: ^() { self.splittedView.frame = new_frame_; } ];
}

-(void)willHideKeyboardWithDuration:( NSTimeInterval )duration_
{
   [ self changeContentViewFrame: self.view.bounds
               animationDuration: duration_ ];
}

-(void)willShowKeyboardWithHeight:( CGFloat )height_
                           inRect:( CGRect )rect_
                         duration:( NSTimeInterval )duration_
{
   CGRect content_rect_  = self.view.bounds;
   content_rect_.size.height -= height_;

   [ self changeContentViewFrame: content_rect_
               animationDuration: duration_ ];
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

