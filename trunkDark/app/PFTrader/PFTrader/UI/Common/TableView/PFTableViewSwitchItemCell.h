#import "PFTableViewItemCell.h"

#import <UIKit/UIKit.h>

@class PFSwitch;

@interface PFTableViewSwitchItemCell : PFTableViewItemCell

@property ( nonatomic, strong ) IBOutlet PFSwitch* switchView;

-(IBAction)switchAction:( id )sender_;

@end
