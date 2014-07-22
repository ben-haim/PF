
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"


@interface SelectServer : UITableViewController 
{
	ParamsStorage *storage;
}
-(void)SetServers:(ParamsStorage*)_storage;
@end
