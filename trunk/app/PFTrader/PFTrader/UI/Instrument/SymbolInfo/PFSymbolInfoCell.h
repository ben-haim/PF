#import "PFTableViewCell.h"

@interface PFSymbolInfoCell : PFTableViewCell

@property ( strong, nonatomic ) IBOutlet UILabel* nameLabel;
@property ( strong, nonatomic ) IBOutlet UILabel* valueLabel;

-(void)setName:( NSString* )name_ andValue:( NSString* )value_;

@end
