#import "PFFrameView.h"

#import "UIImage+Stretch.h"

#import <QuartzCore/QuartzCore.h>

@interface PFFrameView ()

@end

@implementation PFFrameView

@synthesize contentView = _contentView;

-(void)addFrame
{
   UIImage* frame_image_ = [ [ UIImage imageNamed: @"PFStyleSelector" ] symmetricStretchableImage ];
   UIImageView* frame_view_ = [ [ UIImageView alloc ] initWithImage: frame_image_ ];
   frame_view_.frame = self.bounds;
   frame_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ self addSubview: frame_view_ ];
}

-(id)initWithFrame:(CGRect)frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self addFrame ];
   }
   return self;
}

-(void)awakeFromNib
{
   [ self addFrame ];
}

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
