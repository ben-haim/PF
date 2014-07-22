#import <UIKit/UIKit.h>

@interface PFNavigationController : UINavigationController

@property ( nonatomic, strong ) NSString* navigationTitle;
@property ( nonatomic, assign ) BOOL useCloseButton;

+(id)navigationControllerWithController:( UIViewController* )controller_;

-(void)pushViewController:( UIViewController* )view_controller_
            previousTitle:( NSString* )previous_title_
                 animated:( BOOL )animated_;

@end

@interface UIViewController ( PFS_NAVIGATION_OBJC_ASSOCIATION )

-(PFNavigationController*)pfNavigationController;
-(UIViewController*)pfNavigationWrapperController;

@end
