#import "PFTableViewCategoryLabel.h"
#import "UIColor+Skin.h"

@implementation PFTableViewCategoryLabel

-(void)applySkinning
{
   self.font = [ UIFont systemFontOfSize: 18.f ];
   self.textColor = [ UIColor mainTextColor ];
   self.backgroundColor = [ UIColor clearColor ];
   self.shadowColor = [ UIColor clearColor ];
   self.shadowOffset = CGSizeMake( 0.f, 0.f );
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
