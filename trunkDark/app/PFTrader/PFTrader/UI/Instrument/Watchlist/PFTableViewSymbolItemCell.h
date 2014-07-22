#import "PFTableViewItemCell.h"

@interface PFTableViewSymbolItemCell : PFTableViewItemCell

@property ( nonatomic, weak ) IBOutlet UILabel* symbolLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* overviewLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lastTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lastValueLabel;

@end
