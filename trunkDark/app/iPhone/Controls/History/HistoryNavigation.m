

#import "HistoryNavigation.h"


@implementation HistoryNavigation
@synthesize requestButton, hist_view;

-(void)requestClick:(id)sender
{
	[hist_view RequestHistory];
}
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return NO;
}

-(void) viewDidLoad
{
	self.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	requestButton.title = NSLocalizedString(@"SCREEN_HISTORY_REQUEST", nil);
}

@end
