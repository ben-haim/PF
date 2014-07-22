#import "UIImageView+Skin.h"

#import "UIImage+Skin.h"

@implementation PFImageView

-(void)applyStyle
{
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self applyStyle ];
   }
   return self;
}

-(void)awakeFromNib
{
   [ self applyStyle ];
}

@end

@implementation PFSectionView

-(void)applyStyle
{
   self.image = [ UIImage sectionBackground ];
}


@end

@implementation PFSeparatorView

-(void)applyStyle
{
   self.image = [ UIImage separatorBackground ];
}

@end
