#import <Foundation/Foundation.h>

typedef void (^JCNotificationBannerTapHandlingBlock)();

@interface JCNotificationBanner : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, copy) JCNotificationBannerTapHandlingBlock tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)title
                                message:(NSString*)message
                             tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

@end
