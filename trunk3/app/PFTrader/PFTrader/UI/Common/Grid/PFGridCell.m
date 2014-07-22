#import "PFGridCell.h"

@interface PFGridCell ()

@property ( nonatomic, strong ) NSString* reuseIdentifier;
@end

@implementation PFGridCell

@synthesize reuseIdentifier;
@synthesize contentView = _contentView;
@synthesize backgroundView = _backgroundView;

-(id)initWithReuseIdentifier:( NSString* )reuse_identifier_
{
   self = [ super init ];
   if ( self )
   {
      self.reuseIdentifier = reuse_identifier_;
   }
   return self;
}

-(void)setContentView:( UIView* )view_
{
   if ( _contentView != view_ )
   {
      [ _contentView removeFromSuperview ];

      _contentView = view_;

      _contentView.frame = self.bounds;
      _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      [ self addSubview: _contentView ];
   }
}

-(void)setBackgroundView:( UIView* )background_view_
{
   if ( _backgroundView != background_view_ )
   {
      [ _backgroundView removeFromSuperview ];

      _backgroundView = background_view_;

      _backgroundView.frame = self.bounds;
      _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      [ self addSubview: _backgroundView ];
      [ self sendSubviewToBack: _backgroundView ];
   }
}

-(void)prepareForEnqueue
{
}

-(void)prepareForDequeue
{
}

-(void)update
{
}

@end
