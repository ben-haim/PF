#import <DDMenuController/DDMenuController.h>

#import <UIKit/UIKit.h>

@interface DDMenuController (PFTrader)

+(id)traderMenuControllerWithItems:( NSArray* )items_
                    rootController:( UIViewController* )default_controller_;

+(id)traderMenuControllerWithItems:( NSArray* )items_;

-(void)pushRootController:( UIViewController* )controller_
                 animated:( BOOL )animated_;

-(void)pushRightController:( UIViewController* )controller_
                  animated:( BOOL )animated_;

-(void)updateMenuWithItems:( NSArray* )items_;

@end
