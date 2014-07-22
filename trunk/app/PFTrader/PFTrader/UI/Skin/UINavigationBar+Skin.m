#import "UIImage+Skin.h"
#import "UIFont+Skin.h"
#import "UIColor+Skin.h"
#import "PFSystemHelper.h"

@interface NSObject (AppearanceCheck)

+(BOOL)hasAppearance;

@end

@implementation NSObject (AppearanceCheck)

+(BOOL)hasAppearance
{
   return [ self respondsToSelector: @selector( appearance ) ];
}

@end

@implementation UINavigationBar (Skin)

-(void)applySkin
{
   if ( ![ [ self class ] hasAppearance ] )
   {
      [ self setBarStyle: UIBarStyleBlackTranslucent ];
      [ self setTintColor: [ UIColor navigationBarColor ] ];
   }
}

-(void)awakeFromNib
{
   [ self applySkin ];
}

+(void)initialize
{
   if ( [ UINavigationBar class ] != self )
      return;

   if ( [ self hasAppearance ] )
   {
      [ [ self appearance ] setBarStyle: UIBarStyleDefault ];
      [ [ self appearance ] setTintColor: [ UIColor colorWithRed: 82.f / 255 green: 166.f / 255 blue: 1.f alpha: 1.f ] ];
      [ [ self appearance ] setBackgroundImage: [ UIImage imageNamed: @"PFNavigation" ] forBarMetrics: UIBarMetricsDefault ];
      
      NSDictionary* text_attributes_ = [ NSDictionary dictionaryWithObjectsAndKeys: [ UIFont boldSystemFontOfSize: 20.f ], UITextAttributeFont
                                        , [ UIColor colorWithWhite: 0.08f alpha: 1.f ], UITextAttributeTextShadowColor
                                        , [ NSValue valueWithUIOffset: UIOffsetMake( 0.f, -1.f ) ], UITextAttributeTextShadowOffset
                                        , [ UIColor colorWithWhite: 0.78f alpha: 1.f ], UITextAttributeTextColor
                                        , nil ];

      [ [ self appearance ] setTitleTextAttributes: text_attributes_ ];
   }
}

@end

@implementation UIBarButtonItem (Skin)

+(void)initialize
{
   if ( [ UIBarButtonItem class ] != self )
      return;

   if ( [ self hasAppearance ] && !useFlatUI() )
   {
      id appearance_ = [ self appearanceWhenContainedIn: [ UINavigationBar class ], nil ];
      [ appearance_ setBackgroundImage: [ UIImage barButtonBackground ]
                              forState: UIControlStateNormal
                            barMetrics: UIBarMetricsDefault ];
      
      [ appearance_ setBackgroundImage: [ UIImage highlightedBarButtonBackground ]
                              forState: UIControlStateHighlighted
                            barMetrics: UIBarMetricsDefault ];
      
      [ appearance_ setBackButtonBackgroundImage: [ UIImage backBarButtonBackground ]
                                        forState: UIControlStateNormal
                                      barMetrics: UIBarMetricsDefault ];
      
      [ appearance_ setBackButtonBackgroundImage: [ UIImage highlightedBackBarButtonBackground ]
                                        forState: UIControlStateHighlighted
                                      barMetrics: UIBarMetricsDefault ];
      
      NSDictionary* text_attributes_ = [ NSDictionary dictionaryWithObjectsAndKeys:
                                        [ UIFont boldSystemFontOfSize: 12.f ], UITextAttributeFont
                                        , [ UIColor colorWithWhite: 0.04f alpha: 1.f ],UITextAttributeTextShadowColor
                                        , [ NSValue valueWithUIOffset: UIOffsetMake( 0.f, -1.f ) ], UITextAttributeTextShadowOffset
                                        , [ UIColor colorWithWhite: 0.71f alpha: 1.f ], UITextAttributeTextColor
                                        , nil ];
      
      [ appearance_ setTitleTextAttributes: text_attributes_ forState: UIControlStateNormal ];
   }
}


@end
