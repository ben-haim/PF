#import "PFReconnectionBannerView.h"

#import "PFReconnectionBanner.h"
#import "PFButton.h"
#import <QuartzCore/QuartzCore.h>

@interface PFReconnectionBannerView ()

@property ( nonatomic, strong ) UIActivityIndicatorView* indicatorView;
@property ( nonatomic, strong ) UILabel* titleLabel;

@property ( nonatomic, strong ) PFReconnectionBanner* reconnectionBanner;
@property ( nonatomic, strong ) NSObject* isPresentedMutex;
@property ( nonatomic, assign ) BOOL isPresented;

@end

@implementation PFReconnectionBannerView

@synthesize reconnectionBanner = _reconnectionBanner;
@synthesize indicatorView;
@synthesize titleLabel;

@synthesize isPresented;
@synthesize isPresentedMutex;

-(id)initWithBanner:( PFReconnectionBanner* )banner_
{
   self = [ super init ];
   if ( self )
   {
      self.isPresentedMutex = [ NSObject new ];
      self.backgroundColor = [ UIColor colorWithRed: 39.f / 255.f green: 152.f / 255.f blue: 236.f / 255.f alpha: 1.f ];
      
      self.indicatorView = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite ];
      self.indicatorView.hidesWhenStopped = YES;
      self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
      | UIViewAutoresizingFlexibleRightMargin
      | UIViewAutoresizingFlexibleTopMargin
      | UIViewAutoresizingFlexibleBottomMargin;
      [ self addSubview: self.indicatorView ];
      
      self.titleLabel = [ UILabel new ];
      self.titleLabel.font = [ UIFont systemFontOfSize: 16.f ];
      self.titleLabel.textColor = [ UIColor whiteColor ];
      self.titleLabel.backgroundColor = [ UIColor clearColor ];
      [ self addSubview:self.titleLabel ];
      
      self.reconnectionBanner = banner_;
   }
   return self;
}

-(void)layoutSubviews
{
   if ( self.frame.size.width <= 0 )
      return;
   
   self.layer.cornerRadius = 5.0f;
   self.layer.masksToBounds = YES;
   
   self.indicatorView.center = CGPointMake( 20.f,  self.bounds.size.height / 2 );
   [ self.indicatorView startAnimating ];
   
   self.titleLabel.frame = CGRectMake( 40.f, 5.f, self.bounds.size.width - 50.f, self.bounds.size.height - 10.f );
}

-(void)setReconnectionBanner:( PFReconnectionBanner* )reconnection_banner_
{
   _reconnectionBanner = reconnection_banner_;
   self.titleLabel.text = reconnection_banner_.title;
}

-(BOOL)getCurrentPresentingStateAndAtomicallySetPresentingState:( BOOL )state_
{
   @synchronized( self.isPresentedMutex )
   {
      BOOL original_state_ = self.isPresented;
      self.isPresented = state_;
      return original_state_;
   }
}
@end
