#import "PFBadgeView.h"
#import "UIImage+PFBadgeView.h"
#import "UIColor+Skin.h"

@interface PFBadgeView ()

@property ( nonatomic, strong, readonly ) UILabel* badgeLabel;

@end

@implementation PFBadgeView

@synthesize badgeLabel = _badgeLabel;

-(UILabel*)badgeLabel
{
   if ( !_badgeLabel )
   {
      _badgeLabel = [ [ UILabel alloc ] initWithFrame: self.bounds ];
      _badgeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      _badgeLabel.font = [ UIFont fontWithName: @"Helvetica" size: 16.f ];
      _badgeLabel.textColor = [ UIColor grayTextColor ];
      _badgeLabel.shadowColor = [ UIColor clearColor ];
      _badgeLabel.shadowOffset = CGSizeMake( 0.f, 0.f );
      _badgeLabel.backgroundColor = [ UIColor clearColor ];
      _badgeLabel.textAlignment = NSTextAlignmentCenter;
      [ self addSubview: _badgeLabel ];
   }
   return _badgeLabel;
}

-(void)awakeFromNib
{
   self.backgroundColor = [ UIColor clearColor ];

   UIImageView* image_view_ = [ [ UIImageView alloc ] initWithImage: [ UIImage badgeBackground ] ];
   image_view_.frame = self.bounds;
   image_view_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self addSubview: image_view_ ];
}

-(NSString*)badgeValue
{
   return self.badgeLabel.text;
}

-(void)setBadgeValue:( NSString* )badge_value_
{
   self.badgeLabel.text = badge_value_;

   NSAttributedString* badge_string_for_recalc = [ [NSAttributedString alloc] initWithString: badge_value_
                                                                                  attributes: @{ NSFontAttributeName: self.badgeLabel.font } ];

   CGRect badge_rect_ = [ badge_string_for_recalc boundingRectWithSize: CGSizeMake(CGFLOAT_MAX, 22)
                                                               options: NSStringDrawingUsesLineFragmentOrigin
                                                               context: nil ];
   badge_rect_.size.height = 22.f;

   if (badge_value_.length > 1)
      badge_rect_.size.width = 8.f + (badge_rect_.size.width);
   else
      badge_rect_.size.width = 23.f;

   self.bounds = badge_rect_;
}

@end
