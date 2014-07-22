#import "PFTableViewCategoryLabel.h"

@implementation PFTableViewCategoryLabel

-(void)applySkinning
{
   self.font = [ UIFont boldSystemFontOfSize: 17.f ];
   self.textColor = [ UIColor colorWithWhite: 0.6f alpha: 1.f ];
   self.backgroundColor = [ UIColor clearColor ];
   self.shadowColor = [ UIColor colorWithWhite: 0.04f alpha: 1.f ];
   self.shadowOffset = CGSizeMake( 0.f, -1.f );
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self applySkinning ];
   }
   return self;
}

-(void)awakeFromNib
{
   [ self applySkinning ];
}

-(void)drawTextInRect:( CGRect )rect_
{
   return [ super drawTextInRect: CGRectInset( rect_, 20.f, 0.f ) ];
}

@end
