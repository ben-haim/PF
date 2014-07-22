#import "PFTableViewCell.h"

@protocol PFAccount;

@interface PFAccountCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;

-(void)setModel:( id< PFAccount > )account_;

@end
