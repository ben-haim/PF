
#import <Foundation/Foundation.h>
#import "MySingleton.h"

@interface FavoritesNavigation : UINavigationController 
{
	UIBarButtonItem *doneButton;
	UIBarButtonItem *editButton;
	BOOL editing;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
-(void)toggleEdit:(id)sender;
@end
