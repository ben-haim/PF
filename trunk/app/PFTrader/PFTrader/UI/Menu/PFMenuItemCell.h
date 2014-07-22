#import "PFTableViewCell.h"

@class PFBadgeView;

@class PFMenuItem;

@interface PFMenuItemCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* titleLabel;
@property ( nonatomic, strong ) IBOutlet UIImageView* iconView;
@property ( nonatomic, strong ) IBOutlet PFBadgeView* badgeView;

@property ( nonatomic, strong ) PFMenuItem* menuItem;

@end
