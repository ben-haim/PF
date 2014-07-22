#import <Foundation/Foundation.h>
#import "MZFormSheetController.h"

@interface PFModalWindow : NSObject

+(void)showWithController:( UIViewController* )controller_;
+(void)showWithNavigationController:( UINavigationController* )navigation_controller_;

@end
