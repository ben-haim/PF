#import <UIKit/UIKit.h>

@interface PFAccountDetailCell : UITableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* titleLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* valueLabel;

+(id)accountDetailCell;

@end
