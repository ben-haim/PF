#import <Foundation/Foundation.h>
#import "JCNotificationBannerView.h"
#import "JCNotificationBanner.h"
#import "JCNotificationBannerWindow.h"
#import "JCNotificationBannerViewController.h"
#import "JCNotificationBannerViewControlleriPhone.h"

@interface JCNotificationBannerPresenter : NSObject

+ (JCNotificationBannerPresenter*) sharedPresenter;
+ (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void) enqueueNotificationWithTitle:(NSString*)title
                              message:(NSString*)message
                           tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

@end
