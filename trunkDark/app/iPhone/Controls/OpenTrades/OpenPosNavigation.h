

//#import <UIKit/UIKit.h>
#import "OpenPosWatch.h"
#import "MySingleton.h"


@interface OpenPosNavigation : UINavigationController  
{
	OpenPosWatch *vc;
}
@property (nonatomic, retain) IBOutlet OpenPosWatch *vc;
@end
