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
      [ [ self appearance ] setTintColor: [ UIColor mainTextColor ] ];
      [ [ self appearance ] setBackgroundImage: [ UIImage imageNamed: @"PFNavigation" ] forBarMetrics: UIBarMetricsDefault ];
      
      if ( [ UINavigationBar instancesRespondToSelector: @selector( setShadowImage: ) ] )
      {
         [ [ self appearance ] setShadowImage: [ [ UIImage alloc ] init ] ];
      }
      
      NSDictionary* text_attributes_ = [ NSDictionary dictionaryWithObjectsAndKeys: [ UIFont systemFontOfSize: 20.f ], UITextAttributeFont
                                        , [ NSValue valueWithUIOffset: UIOffsetMake( 0.f, 0.f ) ], UITextAttributeTextShadowOffset
                                        , [ UIColor mainTextColor], UITextAttributeTextColor
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
      
      [ appearance_ setBackButtonTitlePositionAdjustment: UIOffsetMake( 0.0f, -3.0f )
                                           forBarMetrics: UIBarMetricsDefault ];
      
      NSDictionary* text_attributes_ = [ NSDictionary dictionaryWithObjectsAndKeys:
                                        [ UIFont systemFontOfSize: 16.f ], UITextAttributeFont
                                        , [ NSValue valueWithUIOffset: UIOffsetMake( 0.f, 0.f ) ], UITextAttributeTextShadowOffset
                                        , [ UIColor mainTextColor ], UITextAttributeTextColor
                                        , nil ];
      
      [ appearance_ setTitleTextAttributes: text_attributes_ forState: UIControlStateNormal ];
      [ appearance_ setTitleTextAttributes: text_attributes_ forState: UIControlStateHighlighted ];
   }
}


@end
