#import "JCNotificationBannerPresenter.h"

@interface JCNotificationBannerPresenter () {
  NSMutableArray* enqueuedNotifications;
  NSLock* isPresentingMutex;
  NSObject* notificationQueueMutex;
  JCNotificationBannerWindow* overlayWindow;
  UIViewController* bannerViewController;
}

- (JCNotificationBanner*) dequeueNotification;
- (void) beginPresentingNotifications;
- (void) presentNotification:(JCNotificationBanner*)notification;

@end

@implementation JCNotificationBannerPresenter

+ (JCNotificationBannerPresenter*) sharedPresenter {
  static JCNotificationBannerPresenter* sharedPresenter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedPresenter = [JCNotificationBannerPresenter new];
  });
  return sharedPresenter;
}

+ (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
  [[JCNotificationBannerPresenter sharedPresenter] enqueueNotificationWithTitle:title
                                                                        message:message
                                                                     tapHandler:tapHandler];
}


- (JCNotificationBannerPresenter*) init {
  self = [super init];
  if (self) {
    enqueuedNotifications = [NSMutableArray new];
    isPresentingMutex = [NSLock new];
    notificationQueueMutex = [NSObject new];
  }
  return self;
}

- (void) enqueueNotificationWithTitle:(NSString*)title
                       message:(NSString*)message
                    tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler {
  JCNotificationBanner* notification = [[JCNotificationBanner alloc] initWithTitle:title
                                                                           message:message
                                                                        tapHandler:tapHandler];
  @synchronized(notificationQueueMutex) {
    [enqueuedNotifications addObject:notification];
  }
  [self beginPresentingNotifications];
}

- (JCNotificationBanner*) dequeueNotification {
  JCNotificationBanner* notification;
  @synchronized(notificationQueueMutex) {
    if ([enqueuedNotifications count] > 0) {
      notification = enqueuedNotifications[0];
      [enqueuedNotifications removeObjectAtIndex:0];
    }
  }
  return notification;
}

- (void) beginPresentingNotifications {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([isPresentingMutex tryLock]) {
      JCNotificationBanner* nextNotification = [self dequeueNotification];
      if (nextNotification) {
        [self presentNotification:nextNotification];
      } else {
        [isPresentingMutex unlock];
      }
    } else {
      // Notification presentation already in progress; do nothing.
    }
  });
}

- (void) presentNotification:(JCNotificationBanner*)notification {
  overlayWindow = [[JCNotificationBannerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  overlayWindow.userInteractionEnabled = YES;
  overlayWindow.opaque = NO;
  overlayWindow.hidden = NO;
  overlayWindow.windowLevel = UIWindowLevelStatusBar;

  JCNotificationBannerView* banner = [[JCNotificationBannerView alloc] initWithNotification:notification];
  banner.userInteractionEnabled = YES;

  bannerViewController = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [JCNotificationBannerViewController new] : [JCNotificationBannerViewControlleriPhone new];
  overlayWindow.rootViewController = bannerViewController;

  UIView* containerView = [UIView new];
  containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  containerView.userInteractionEnabled = YES;
  containerView.opaque = NO;

  overlayWindow.bannerView = banner;

  [containerView addSubview:banner];
  bannerViewController.view = containerView;

  
  banner.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
                            | UIViewAutoresizingFlexibleLeftMargin
                            | UIViewAutoresizingFlexibleRightMargin;

  UIView* view = nil;

  if ( [[[UIApplication sharedApplication] keyWindow] subviews].count > 0)
    view = ((UIView*)[[[UIApplication sharedApplication] keyWindow] subviews][0]);

  containerView.bounds = view.bounds;
  containerView.transform = view.transform;
  [banner getCurrentPresentingStateAndAtomicallySetPresentingState:YES];

  CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
  CGFloat x = (MAX(statusBarSize.width, statusBarSize.height) / 2) - (350 / 2);
  if([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    statusBarSize.height = 0.f;
  CGFloat y = -60 - (MIN(statusBarSize.width, statusBarSize.height));
  banner.frame = CGRectMake(x, y, 350, 60);

  __unsafe_unretained UIView* unsafe_banner_ = banner;
  __unsafe_unretained UIView* unsafe_overlay_window_ = overlayWindow;

  JCNotificationBannerTapHandlingBlock originalTapHandler = notification.tapHandler;
  JCNotificationBannerTapHandlingBlock wrappingTapHandler = ^{
    if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO]) {
      if (originalTapHandler) {
        originalTapHandler();
      }

      [unsafe_banner_ removeFromSuperview];
      [unsafe_overlay_window_ removeFromSuperview];

      // Process any notifications enqueued during this one's presentation.
      [isPresentingMutex unlock];
      [self beginPresentingNotifications];
    }
  };
  notification.tapHandler = wrappingTapHandler;

  // Slide it down while fading it in.
  banner.alpha = 0;
  [UIView animateWithDuration:0.5 delay:0
                      options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     CGRect newFrame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
                     banner.frame = newFrame;
                     banner.alpha = 0.9;
                   } completion:^(BOOL finished) {
                     // Empty.
                   }];


  // On timeout, slide it up while fading it out.
  double delayInSeconds = 3.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                       banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                       banner.alpha = 0;
                     } completion:^(BOOL finished) {
                       if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO]) {
                         [banner removeFromSuperview];
                         [overlayWindow removeFromSuperview];
                         overlayWindow = nil;

                         // Process any notifications enqueued during this one's presentation.
                         [isPresentingMutex unlock];
                         [self beginPresentingNotifications];
                       }
                     }];
  });
}

@end
