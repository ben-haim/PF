#import <UIKit/UIKit.h>

@interface PFGridHeaderView : UIView

@property ( nonatomic, strong ) IBOutlet UILabel* titleLabel;

+(id)headerView;

@end

@interface PFDetailGridHeaderView : PFGridHeaderView

@property ( nonatomic, strong ) IBOutlet UILabel* secondTitleLabel;

@end
