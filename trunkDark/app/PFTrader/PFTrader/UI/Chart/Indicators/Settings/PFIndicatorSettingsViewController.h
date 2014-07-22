#import "PFTableViewController.h"

#import <UIKit/UIKit.h>

@class PFIndicator;

typedef void (^PFIndicatorSettingsViewControllerCloseBlock)();

@interface PFIndicatorSettingsViewController : PFTableViewController

@property ( nonatomic, copy ) PFIndicatorSettingsViewControllerCloseBlock closeBlock;

-(id)initWithIndicator:( PFIndicator* )indicator_;

@end
