
#import <UIKit/UIKit.h>

@protocol SelectionListViewControllerDelegate <NSObject>
@required
- (void)rowChosen:(NSInteger)row;
@end

@interface SelectionListViewController : UITableViewController 
{
    NSArray         *list;
    NSIndexPath     *lastIndexPath;
    NSInteger       initialSelection;
	int selectedRow;
    id <SelectionListViewControllerDelegate>    delegate;
}
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, retain) NSArray *list;
@property NSInteger initialSelection;
@property (nonatomic, assign) id <SelectionListViewControllerDelegate> delegate;
@end
