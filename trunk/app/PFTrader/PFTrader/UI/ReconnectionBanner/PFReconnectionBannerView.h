#import <UIKit/UIKit.h>

@class PFReconnectionBanner;

@interface PFReconnectionBannerView : UIView

-(id)initWithBanner:( PFReconnectionBanner* )banner_;

-(BOOL)getCurrentPresentingStateAndAtomicallySetPresentingState:( BOOL )state_;

@end
