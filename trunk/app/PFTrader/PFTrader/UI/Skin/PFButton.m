#import "PFButton.h"

#import "UIImage+Skin.h"

@implementation PFButton

-(void)applyStyle
{
   [ self setTitleColor: [ UIColor whiteColor ] forState: UIControlStateNormal ];

   self.titleLabel.font = [ UIFont boldSystemFontOfSize: 17.f ];
   self.titleLabel.shadowColor = [ UIColor colorWithRed: 0.03f green: 0.23f blue: 0.48f alpha: 1.f ];
   self.titleLabel.shadowOffset = CGSizeMake( 0.f, -1.f );
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

@implementation PFBlueButton

-(void)applyStyle
{
   [ super applyStyle ];

   [ self setBackgroundImage: [ UIImage blueButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedBlueButtonBackground ] forState: UIControlStateHighlighted ];
}

@end

@implementation PFGreenButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage greenButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedGreenButtonBackground ] forState: UIControlStateHighlighted ];
}

@end

@implementation PFRedButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage redButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedRedButtonBackground ] forState: UIControlStateHighlighted ];
}

@end

@implementation PFGrayButton

-(void)applyStyle
{
   [ super applyStyle ];

   [ self setBackgroundImage: [ UIImage grayButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedGrayButtonBackground ] forState: UIControlStateHighlighted ];
   [ self setBackgroundImage: [ UIImage highlightedGrayButtonBackground ] forState: UIControlStateSelected ];
}

@end

@implementation PFBorderedButton

-(void)applyStyle
{
   [ super applyStyle ];

   [ self setBackgroundImage: [ UIImage borderedButtonBackgroundImage ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedBorderedButtonBackgroundImage ] forState: UIControlStateHighlighted ];
   [ self setBackgroundImage: [ UIImage highlightedBorderedButtonBackgroundImage ] forState: UIControlStateSelected ];
}

@end

@implementation PFTransparentButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage transparentButtonBackgroundImage ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedTransparentButtonBackgroundImage ] forState: UIControlStateHighlighted ];
}

@end
