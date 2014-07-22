#import "PFButton.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

@implementation PFButton

-(void)applyStyle
{
   [ self setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateNormal ];

   self.titleLabel.font = [ UIFont systemFontOfSize: 17.f ];
   self.titleLabel.textColor = [ UIColor mainTextColor ];
   self.titleLabel.shadowColor = [ UIColor clearColor ];
   self.titleLabel.shadowOffset = CGSizeMake( 0.f, 0.f );
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

@implementation PFGrayButtonBlueTitle

-(void)applyStyle
{
   [ super applyStyle ];

   [ self setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateNormal ];
   self.titleLabel.textColor = [ UIColor blueTextColor ];
}

@end

@implementation PFGrayRoundButton

-(void)applyStyle
{
   [ super applyStyle ];

   [ self setBackgroundImage: [ UIImage grayRoundButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedGrayRoundButtonBackground ] forState: UIControlStateHighlighted ];
   [ self setBackgroundImage: [ UIImage highlightedGrayRoundButtonBackground ] forState: UIControlStateSelected ];
}

@end

@implementation PFGrayRoundButtonBlueTitle

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setTitleColor: [ UIColor blueTextColor ] forState: UIControlStateNormal ];
   self.titleLabel.textColor = [ UIColor blueTextColor ];
}

@end

@implementation PFTransparentButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage transparentButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedTransparentButtonBackground ] forState: UIControlStateHighlighted ];
   [ self setBackgroundImage: [ UIImage highlightedTransparentButtonBackground ] forState: UIControlStateSelected ];
}

@end

@implementation PFFullTransparentButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage new ] forState: UIControlStateNormal ];
}

@end

@implementation PFChartPeriodButton

-(void)applyStyle
{
   [ super applyStyle ];
   
   [ self setBackgroundImage: [ UIImage chartPeriodButtonBackground ] forState: UIControlStateNormal ];
   [ self setBackgroundImage: [ UIImage highlightedChartPeriodButtonBackground ] forState: UIControlStateHighlighted ];
   [ self setBackgroundImage: [ UIImage highlightedChartPeriodButtonBackground ] forState: UIControlStateSelected ];
}

@end
