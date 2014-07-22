#import "PFTableViewCell.h"

@protocol PFChatMessage;

@interface PFChatCell : PFTableViewCell

@property ( nonatomic, strong ) IBOutlet UIImageView* messageBackgroundView;
@property ( nonatomic, strong ) IBOutlet UIView* messageView;
@property ( nonatomic, strong ) IBOutlet UILabel* dateLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* messageLabel;

@property ( nonatomic, strong ) id< PFChatMessage > message;

+(CGFloat)cellHeightForMessage:( id< PFChatMessage > )message_
                      forWidth:( CGFloat )width_;

@end
