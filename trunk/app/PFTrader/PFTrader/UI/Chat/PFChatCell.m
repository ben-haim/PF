#import "PFChatCell.h"

#import "NSDateFormatter+PFTrader.h"
#import "UIImage+Chat.h"
#import "UIColor+Chat.h"

#import <ProFinanceApi/ProFinanceApi.h>

static CGFloat PFChatCellMessageMargin = 10.f;

@implementation PFChatCell

@synthesize messageBackgroundView;
@synthesize messageView;
@synthesize dateLabel;
@synthesize messageLabel;

@synthesize message = _message;

+(CGFloat)messageViewWidthForCellWidth:( CGFloat )cell_width_
{
   static CGFloat PFChatCellMessageMinWidth = 220.f;
   CGFloat message_width_ = ( cell_width_ / 2.f - PFChatCellMessageMargin );
   return fmax( message_width_, PFChatCellMessageMinWidth );
}

-(void)setMessage:( id< PFChatMessage > )message_
{
   self.messageLabel.text = message_.text;
   self.dateLabel.text = [ [ NSDateFormatter chatMessageDateFormatter ] stringFromDate: message_.date ];

   BOOL is_my_message_ = message_.senderId == [ PFSession sharedSession ].user.userId;
   CGRect message_rect_ = self.messageView.frame;
   message_rect_.size.width = [ [ self class ] messageViewWidthForCellWidth: self.bounds.size.width ];
   CGFloat message_margin_ = 10.f;
   if ( is_my_message_ )
   {
      self.messageBackgroundView.image = [ UIImage userMessageBackground ];
      self.messageLabel.textColor = [ UIColor userMessageColor ];
      message_rect_.origin.x = self.bounds.size.width - message_rect_.size.width - message_margin_;
   }
   else
   {
      self.messageBackgroundView.image = [ UIImage adminMessageBackground ];
      self.messageLabel.textColor = [ UIColor adminMessageColor ];
      message_rect_.origin.x = message_margin_;
   }
   self.messageView.frame = message_rect_;

   _message = message_;
}

+(CGFloat)cellHeightForMessage:( id< PFChatMessage > )message_
                      forWidth:( CGFloat )width_
{
   CGFloat message_width_ = [ self messageViewWidthForCellWidth: width_ ];

   CGFloat horyzontal_margin_ = 25.f;
   CGFloat vertical_margin_ = 53.f;

   return [ message_.text sizeWithFont: [ UIFont systemFontOfSize: 15.f ]
                     constrainedToSize: CGSizeMake( message_width_ - horyzontal_margin_, CGFLOAT_MAX )
                         lineBreakMode: NSLineBreakByWordWrapping ].height + vertical_margin_;
}

@end
