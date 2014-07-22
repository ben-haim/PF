#import "UIView+ResignFirstResponder.h"

@implementation UIView (ResignFirstResponder)

-(BOOL)findAndResignFirstResponder
{
   if ( self.isFirstResponder )
   {
      [ self resignFirstResponder ];
      return YES;
   }
   
   for ( UIView* subview_ in self.subviews )
   {
      if ( [ subview_ findAndResignFirstResponder ] )
      {
         return YES;
      }
   }
   
   return NO;
}

@end
