#import "PFReconnectionBannerWindow.h"

@implementation PFReconnectionBannerWindow

@synthesize bannerView;

-(UIView*)hitTest:( CGPoint )point_
        withEvent:( UIEvent* )event_
{
   UIView* super_hit_view_ = [ super hitTest: point_ withEvent: event_ ];
   
   if ( super_hit_view_ != self.bannerView )
   {
      UIWindow* next_window_ = nil;
      BOOL use_next_window_ = NO;
      
      for ( UIWindow* window_ in [ [ UIApplication sharedApplication ].windows reverseObjectEnumerator ] )
      {
         if ( use_next_window_ )
         {
            next_window_ = window_;
            break;
         }
         
         if ( [ window_ isKindOfClass: [ PFReconnectionBannerWindow class ] ] )
         {
            use_next_window_ = YES;
         }
      }
      
      return next_window_ ? [ next_window_ hitTest: point_ withEvent: event_ ] : super_hit_view_;
   }
   
   return self.bannerView;
}

@end
