

#import <Foundation/Foundation.h>
#import "HistoryViewController.h"
#import "MySingleton.h"

@interface HistoryNavigation : UINavigationController 
{
	UIBarButtonItem *requestButton;
	HistoryViewController *hist_view;
}
@property (nonatomic, retain) IBOutlet UIBarButtonItem *requestButton;
@property (nonatomic, retain) IBOutlet HistoryViewController *hist_view;
-(void)requestClick:(id)sender;
@end
