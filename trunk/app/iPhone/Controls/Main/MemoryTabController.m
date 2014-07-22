
#import "MemoryTabController.h"


@implementation MemoryTabController

-(void) awakeFromNib
{
	[self setDelegate: self];
}

-(void) viewDidLoad
{
	NSMutableArray	 *controllers = [NSMutableArray array];
	NSMutableDictionary	*keys = [NSMutableDictionary dictionary];
	UIViewController	*view;
	NSString	 *title;
	NSArray	 *order;
	
	order = (id) CFPreferencesCopyAppValue((CFStringRef) @"MemoryTabControllerViews", 
										   kCFPreferencesCurrentApplication);
	if (order) {
		for (view in self.viewControllers)
			if (view.tabBarItem.title)
				[keys setObject: view forKey: view.tabBarItem.title];
		for (title in order)
			[controllers addObject: [keys objectForKey: title]];
		for (view in self.viewControllers)
			if (! [controllers containsObject: view])
				[controllers addObject: view];
		[self setViewControllers: controllers];
		[order release];
	}
}

-(void) tabBarController: (UITabBarController *) tabBarController
didEndCustomizingViewControllers: (NSArray *) viewControllers changed: (BOOL) changed
{	
	NSMutableArray	 *array = [NSMutableArray array];
	UIViewController	*view;
	
	for (view in viewControllers)
		if ([view.tabBarItem.title length])
		{
			[array addObject: view.tabBarItem.title];
		}
		else {
			NSLog(@"TabBarController cannot save customization unless every item has a title.");
			return;
		}
	CFPreferencesSetAppValue((CFStringRef) @"MemoryTabControllerViews", array, 
							 kCFPreferencesCurrentApplication);
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

@end
