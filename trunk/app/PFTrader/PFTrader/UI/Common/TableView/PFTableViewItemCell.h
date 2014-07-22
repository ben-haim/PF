#import "PFTableViewCell.h"

@class PFTableViewItem;

@interface PFTableViewItemCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UIView* itemContentView;
@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;

@property ( nonatomic, strong ) PFTableViewItem* item;

-(void)performAction;

@end
