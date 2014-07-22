#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)

-(UIImage*)symmetricStretchableImage
{
   //CGFloat x_inset_ = ( self.size.width - 1 ) / 2;
   //CGFloat y_inset_ = ( self.size.height - 1 ) / 2;
   
   //return [ self resizableImageWithCapInsets: UIEdgeInsetsMake( y_inset_, x_inset_, y_inset_, x_inset_) ];
   return [ self stretchableImageWithLeftCapWidth: ( self.size.width - 1 ) / 2
                                     topCapHeight: ( self.size.height - 1 ) / 2 ];
}

@end
