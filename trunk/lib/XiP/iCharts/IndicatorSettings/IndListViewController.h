#import <UIKit/UIKit.h>

@class PropertiesStore;
@interface IndListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  
{    
    UIViewController* rootViewController;
    IBOutlet UITableView *tableIndList;
    PropertiesStore* default_properties;
}
- (void)ShowIndicators:(PropertiesStore*)def_store;
- (void)close;
@property (nonatomic, retain)	PropertiesStore* default_properties;
@property (nonatomic, retain)	UITableView* tableIndList;
@property (assign)              UIViewController* rootViewController;

@end
