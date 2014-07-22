#import <UIKit/UIKit.h>

@protocol PFAccount;

@interface PFAccountCell : UITableViewCell

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;

+(id)accountCell;

-(void)setModel:( id< PFAccount > )account_;

@end
