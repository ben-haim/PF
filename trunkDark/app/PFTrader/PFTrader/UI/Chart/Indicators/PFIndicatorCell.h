#import "PFTableViewCell.h"

@class PFIndicator;
@class PFEnabledIndicatorsInfoController;

@interface PFIndicatorCell : PFTableViewCell

@property ( nonatomic, weak ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, weak ) IBOutlet UIButton* removeButton;
@property ( nonatomic, weak ) PFEnabledIndicatorsInfoController* controller;
@property ( nonatomic, weak ) PFIndicator* indicator;

-(IBAction)removeAction:( id )sender_;

@end
