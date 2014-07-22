
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"


@interface SelectSymbolDlg : UITableViewController 
{
	
	ParamsStorage *storage;
	int skips;
}
@property (assign) ParamsStorage *storage;
@end
