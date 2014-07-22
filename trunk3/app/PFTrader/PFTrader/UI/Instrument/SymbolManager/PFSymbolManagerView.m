#import "PFSymbolManagerView.h"

@implementation PFSymbolManagerView

- (id)initWithFrame:( CGRect )frame
{
   self = [ super initWithFrame: frame ];
   
   if ( self )
   {
      self.backgroundColor = [ UIColor clearColor ];
      self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   }
   
   return self;
}

- (void)drawRect:(CGRect)rect
{
   [ super drawRect: rect ];
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetStrokeColorWithColor( context, [ UIColor whiteColor ].CGColor );
   
   CGContextSetLineWidth( context, 2.f );
   CGContextMoveToPoint( context, 0.f, 0.f );
   CGContextAddLineToPoint( context, self.bounds.size.width, 0.f );
   
   CGContextStrokePath( context );
}

@end
