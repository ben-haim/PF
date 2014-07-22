
#import "ExitNavController.h"
#import "MySingleton.h"


@implementation ExitNavController

- (void)viewDidLoad
{
	self.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	
	
}

@end
