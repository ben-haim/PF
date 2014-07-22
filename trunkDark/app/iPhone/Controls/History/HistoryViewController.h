#import <UIKit/UIKit.h>

@class ParamsStorage;

@interface HistoryViewController : UITableViewController
{
@private
	int c;
	double deposit;
	double withdrawal;
	double pl;
	double netCredit;
	//Balancecell *balanceCell;
}
@property( nonatomic, retain ) ParamsStorage *storage;
@property( nonatomic, retain ) NSMutableArray *items;

-(void)RequestHistory;
- (void)dateDlgClosed:(NSNotification *)notification;
- (void) clearItems;

@end
