#import "PFBadgeView.h"

#import "UIImage+PFBadgeView.h"

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
      _badgeLabel.font = [ UIFont systemFontOfSize: 16.f ];
      _badgeLabel.textColor = [ UIColor colorWithRed: 45.f / 255 green: 170.f / 255 blue: 240.f / 255 alpha: 1.f ];
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
}

@end
