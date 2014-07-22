
#import <Foundation/Foundation.h>
#import "iTraderAppDelegate.h"

@protocol iTraderAppDelegate

-(void)volumeSelected:(NSString*)volume;

@end


@interface VolumeSelector : UIViewController {

	id<iTraderAppDelegate> _delegate;
}

@property (nonatomic, assign) id<iTraderAppDelegate> delegate;

@end
