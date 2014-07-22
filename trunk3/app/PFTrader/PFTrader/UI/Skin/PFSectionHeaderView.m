#import "PFSectionHeaderView.h"

#import "UIImageView+Skin.h"

@implementation PFSectionHeaderView

@synthesize textLabel = _textLabel;

-(UILabel*)textLabel
{
   if ( !_textLabel )
   {
      _textLabel = [ [ UILabel alloc ] initWithFrame: CGRectInset( self.bounds, 5.f, 0.f ) ];
      _textLabel.font = [ UIFont systemFontOfSize: 12.f ];
      _textLabel.textColor = [ UIColor colorWithWhite: 0.5f alpha: 1.f ];
      _textLabel.backgroundColor = [ UIColor clearColor ];
      _textLabel.shadowColor = [ UIColor clearColor ];
      _textLabel.shadowOffset = CGSizeMake( 0.f, 0.f );
      _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ self addSubview: _textLabel ];
   }
   return _textLabel;
}

-(id)init
{
   return [ self initWithFrame: CGRectMake( 0.f, 0.f, 320.f, 40.f ) ];
}

-(void)addBackground
{
   UIImageView* background_view_ = [ PFSectionView new ];
   background_view_.frame = self.bounds;
   background_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ self addSubview: background_view_ ];
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self addBackground ];
   }
   return self;
}

-(void)awakeFromNib
{
   [ self addBackground ];
}

@end
