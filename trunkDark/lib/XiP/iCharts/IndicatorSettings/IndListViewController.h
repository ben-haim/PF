#import <UIKit/UIKit.h>

@class PropertiesStore;
@interface IndListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>  
{    
    UIViewController* __unsafe_unretained rootViewController;
    IBOutlet UITableView *tableIndList;
    PropertiesStore* default_properties;
}
- (void)ShowIndicators:(PropertiesStore*)def_store;
- (void)close;
@property (nonatomic, strong)	PropertiesStore* default_properties;
@property (nonatomic, strong)	UITableView* tableIndList;
@property (unsafe_unretained)              UIViewController* rootViewController;

@end
