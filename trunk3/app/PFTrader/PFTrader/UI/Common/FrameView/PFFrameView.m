#import "PFFrameView.h"

#import "UIImage+Stretch.h"

#import <QuartzCore/QuartzCore.h>

@interface PFFrameView ()

@end

@implementation PFFrameView

@synthesize contentView = _contentView;

-(void)setContentView:( UIView* )view_
{
   if ( _contentView != view_ )
   {
      [ _contentView removeFromSuperview ];

      view_.frame = self.bounds;
      view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      view_.layer.cornerRadius = 5.f;
      [ self addSubview: view_ ];
      [ self sendSubviewToBack: view_ ];
      _contentView = view_;
   }
}

-(void)setImage:( UIImage* )image_
{
   UIImageView* image_view_ = [ [ UIImageView alloc ] initWithImage: image_ ];
   [ self setContentView: image_view_ ];
}

-(void)setColor:( UIColor* )color_
{
   UIView* color_view_ = [ UIView new ];
   color_view_.backgroundColor = color_;
   [ self setContentView: color_view_ ];
}

@end
