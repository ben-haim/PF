#import "PFReconnectionBannerPresenter.h"

#import "PFReconnectionBanner.h"
#import "PFReconnectionBannerView.h"
#import "PFReconnectionBannerViewController_iPad.h"
#import "PFReconnectionBannerViewController.h"
#import "PFReconnectionBannerWindow.h"

typedef void (^ReconnectionDoneBlock)();

@interface PFReconnectionBannerPresenter ()

@property ( nonatomic, strong ) NSMutableArray* enqueuedReconnections;
@property ( nonatomic, strong ) NSLock* isPresentingMutex;
@property ( nonatomic, strong ) NSObject* reconnectionQueueMutex;
@property ( nonatomic, strong ) PFReconnectionBannerWindow* overlayWindow;
@property ( nonatomic, strong ) UIViewController* reconnectionViewController;
@property ( nonatomic, copy ) ReconnectionDoneBlock doneBlock;

-(PFReconnectionBanner*)dequeueReconnection;
-(void)beginPresentingReconnections;
-(void)presentReconnection:( PFReconnectionBanner* )reconnection_banner_;

@end

@implementation PFReconnectionBannerPresenter

@synthesize enqueuedReconnections;
@synthesize isPresentingMutex;
@synthesize reconnectionQueueMutex;
@synthesize overlayWindow;
@synthesize reconnectionViewController;
@synthesize doneBlock;

+(PFReconnectionBannerPresenter*)sharedPresenter
{
   static PFReconnectionBannerPresenter* shared_presenter_ = nil;
   
   static dispatch_once_t onceToken;
   dispatch_once( &onceToken, ^{ shared_presenter_ = [ PFReconnectionBannerPresenter new ]; } );
   
   return shared_presenter_;
}

-(void)enqueueReconnectionWithTitle:( NSString* )title_
{
   PFReconnectionBanner* reconnection_banner_ = [ [ PFReconnectionBanner alloc ] initWithTitle: title_ ];
   
   @synchronized( self.reconnectionQueueMutex )
   {
      [ self.enqueuedReconnections addObject: reconnection_banner_ ];
   }
   
   [ self beginPresentingReconnections ];
}

+(void)enqueueReconnectionWithTitle:( NSString* )title_
{
   [ [ PFReconnectionBannerPresenter sharedPresenter ] enqueueReconnectionWithTitle: title_ ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.enqueuedReconnections = [ NSMutableArray new ];
      self.isPresentingMutex = [ NSLock new ];
      self.reconnectionQueueMutex = [ NSObject new ];
   }
   
   return self;
}

-(PFReconnectionBanner*)dequeueReconnection
{
   PFReconnectionBanner* reconnection_ = nil;
   
   @synchronized( self.reconnectionQueueMutex )
   {
      if ( self.enqueuedReconnections.count > 0 )
      {
         reconnection_ = [ self.enqueuedReconnections objectAtIndex: 0 ];
         [ self.enqueuedReconnections removeObjectAtIndex: 0 ];
      }
   }
   
   return reconnection_;
}

-(void)beginPresentingReconnections
{
   dispatch_async(dispatch_get_main_queue(),
                  ^{
                     if ( [ self.isPresentingMutex tryLock ] )
                     {
                        PFReconnectionBanner* next_reconnection_ = [ self dequeueReconnection ];
                        if ( next_reconnection_ )
                        {
                           [self presentReconnection: next_reconnection_ ];
                        }
                        else
                        {
                           [ self.isPresentingMutex unlock ];
                        }
                     }
                  });
}

-(void)presentReconnection:( PFReconnectionBanner* )reconnection_banner_
{
   self.overlayWindow = [ [ PFReconnectionBannerWindow alloc ] initWithFrame: [ UIScreen mainScreen ].bounds ];
   self.overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.overlayWindow.userInteractionEnabled = YES;
   self.overlayWindow.opaque = NO;
   self.overlayWindow.hidden = NO;
   self.overlayWindow.windowLevel = UIWindowLevelStatusBar;
   
   PFReconnectionBannerView* reconnection_view_ = [ [ PFReconnectionBannerView alloc] initWithBanner: reconnection_banner_ ];
   reconnection_view_.userInteractionEnabled = YES;
   
   self.reconnectionViewController = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ?
   [ PFReconnectionBannerViewController_iPad new ] :
   [ PFReconnectionBannerViewController new ];
   
   self.overlayWindow.rootViewController = self.reconnectionViewController;
   
   UIView* container_view_ = [ UIView new ];
   container_view_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   container_view_.userInteractionEnabled = YES;
   container_view_.opaque = NO;
   
   self.overlayWindow.bannerView = reconnection_view_;
   
   [ container_view_ addSubview: reconnection_view_ ];
   self.reconnectionViewController.view = container_view_;
   
   reconnection_view_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
   
   UIView* view_ = ( ( UIView* )[ [ [ [ UIApplication sharedApplication ] keyWindow ] subviews ] objectAtIndex: 0 ] );
   container_view_.bounds = view_.bounds;
   container_view_.transform = view_.transform;
   [ reconnection_view_ getCurrentPresentingStateAndAtomicallySetPresentingState: YES ];
   reconnection_view_.frame = CGRectMake( view_.bounds.size.width - 185.f , view_.bounds.size.height - 5.f, 180.f, 30.f );
   
   // Slide it down while fading it in.
   reconnection_view_.alpha = 0.f;
   [ UIView animateWithDuration: 0.5
                          delay: 0
                       options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                    animations: ^{
                       
                       CGRect new_frame_ = CGRectOffset( reconnection_view_.frame, 0, -reconnection_view_.frame.size.height);
                       reconnection_view_.frame = new_frame_;
                       reconnection_view_.alpha = 1.f;
                    }
                     completion: nil ];
   
   __unsafe_unretained PFReconnectionBannerPresenter* unsafe_self_ = self;
   
   self.doneBlock = ^{
      [ UIView animateWithDuration: 0.5
                             delay: 0
                           options: UIViewAnimationOptionCurveEaseIn
                        animations: ^{
                           reconnection_view_.frame = CGRectOffset( reconnection_view_.frame, 0, reconnection_view_.frame.size.height );
                           reconnection_view_.alpha = 0;
                        }
                        completion: ^( BOOL finished ) {
                           if ( [ reconnection_view_ getCurrentPresentingStateAndAtomicallySetPresentingState: NO ] )
                           {
                              [ reconnection_view_ removeFromSuperview ];
                              [ unsafe_self_.overlayWindow removeFromSuperview ];
                              unsafe_self_.overlayWindow = nil;
                              
                              // Process any notifications enqueued during this one's presentation.
                              [ unsafe_self_.isPresentingMutex unlock ];
                              [ unsafe_self_ beginPresentingReconnections ];
                           }
                        } ];
   };
}

-(void)dismissReconnection
{
   if ( self.doneBlock )
   {
      self.doneBlock();
   }
}

@end
