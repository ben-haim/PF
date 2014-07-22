#import "PFSplittedViewController.h"

@class DDMenuController;

@interface PFTraderSplittedViewController : PFSplittedViewController

+(id)splittedControllerWithTopMenu:( DDMenuController* )top_controller_
                        bottomMenu:( DDMenuController* )bottom_controller_;

@end