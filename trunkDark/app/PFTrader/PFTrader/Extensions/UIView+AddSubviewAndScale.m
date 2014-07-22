#import "UIView+AddSubviewAndScale.h"

@implementation UIView (AddSubviewAndScale)

-(void)addSubviewAndScale:( UIView* )subview_
{
   subview_.frame = self.bounds;
   subview_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self addSubview: subview_ ];
}

@end
