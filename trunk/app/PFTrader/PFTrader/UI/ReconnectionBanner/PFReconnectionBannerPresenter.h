#import <Foundation/Foundation.h>

@interface PFReconnectionBannerPresenter : NSObject

+(PFReconnectionBannerPresenter*) sharedPresenter;

+(void)enqueueReconnectionWithTitle:( NSString* )title_;

-(void)dismissReconnection;

@end
