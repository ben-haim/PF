
#import <UIKit/UIKit.h>
#import "Grid.h"

@interface GridViewController : UIViewController<UIScrollViewDelegate>
{
	Grid *grid_view;
}
@property (nonatomic, retain) IBOutlet Grid *grid_view;

@end
