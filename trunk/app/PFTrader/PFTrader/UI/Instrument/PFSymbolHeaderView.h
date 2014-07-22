#import <UIKit/UIKit.h>

@interface PFSymbolHeaderView : UIView

@property ( nonatomic, strong ) IBOutlet UILabel* topLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* bottomLabel;

+(id)symbolHeaderView;

@end
