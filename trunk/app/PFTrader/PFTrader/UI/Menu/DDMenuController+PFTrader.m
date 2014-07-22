#import "DDMenuController+PFTrader.h"

#import "PFMainMenuViewController.h"

#import "PFSwitch.h"
#import "PFIndicatorCell.h"

#import "UIViewController+Wrapper.h"

//!XiP include
#import "ChartSensorView.h"

@implementation DDMenuController (PFTrader)

+(UINavigationController*)wrappedController:( UIViewController* )controller_
{
   return [ controller_ wrapIntoNavigationController ];
}

-(UINavigationController*)wrappedController:( UIViewController* )controller_
{
   return [ [ self class ] wrappedController: controller_ ];
}

+(id)traderMenuControllerWithItems:( NSArray* )items_
                    rootController:( UIViewController* )default_controller_
{
   UINavigationController* navigation_controller_ = [ self wrappedController: default_controller_ ];

   DDMenuController* menu_controller_ = [ [ self alloc ] initWithRootViewController: navigation_controller_ ];
   [ menu_controller_ ingnorePanForViewClass: [ PFSwitch class ] ];
   [ menu_controller_ ingnorePanForViewClass: [ ChartSensorView class ] ];
   [ menu_controller_ ingnorePanForViewClass: [ PFIndicatorCell class ] ];

   PFMainMenuViewController* left_navigation_controller_ = [ [ PFMainMenuViewController alloc ] initWithItems: items_ ];

   menu_controller_.leftViewController = left_navigation_controller_;

   return menu_controller_;
}

+(id)traderMenuControllerWithItems:( NSArray* )items_
{
   return [ self traderMenuControllerWithItems: items_ rootController: nil ];
}

-(void)pushRootController:( UIViewController* )controller_
                 animated:( BOOL )animated_
{
   [ self setRootController: [ self wrappedController: controller_ ] animated: animated_ ];
}

-(void)pushRightController:( UIViewController* )controller_
                  animated:( BOOL )animated_
{
   self.rightViewController = [ self wrappedController: controller_ ];
   [ self showRightController: YES ];
}

-(void)updateMenuWithItems:( NSArray* )items_
{
   self.leftViewController = [ [ PFMainMenuViewController alloc ] initWithItems: items_ ];
}

@end

