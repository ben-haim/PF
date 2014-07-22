
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"

#import "../Grid/GridControler.h"
#import "../Grid/MarketWatchGridCell.h" 
#import "../Grid/HeaderGridCell.h" 
#import "../Trading/TradePaneController.h"


@interface MarketWatch : UIViewController<UITableViewDelegate>
{
	ParamsStorage *storage;
	BOOL isSelecting;
	TradePaneController *tradePane;
	GridViewController *gridCtl;
}
@property (assign) ParamsStorage *storage;
@property (assign) BOOL isSelecting;
@property (nonatomic, retain) IBOutlet GridViewController *gridCtl;
-(void)rebind;
-(void)SymbolUpdated:(NSString*)symbol;

@end
