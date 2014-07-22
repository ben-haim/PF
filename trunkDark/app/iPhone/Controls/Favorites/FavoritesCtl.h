

#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"

#import "../Grid/GridControler.h"
#import "../Grid/MarketWatchGridCell.h" 
#import "../Grid/HeaderGridCell.h" 
#import "TradePaneController.h"

#import "FavoritesEditCtl.h"

@interface FavoritesCtl : UIViewController<UITableViewDelegate> 
{
	
	ParamsStorage *storage;
	UITextField *textfieldName;
	FavoritesEditCtl *favs_edit;
	GridViewController *gridCtl;
	
	UITabBar *tabBar;
	
	TradePaneController *tradePane;
    NSMutableArray *FavSymbols;
}
@property (assign) ParamsStorage *storage;
@property (nonatomic, retain) IBOutlet GridViewController *gridCtl;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) NSMutableArray *FavSymbols;
-(void)rebind;
-(void)SymbolUpdated:(NSString*)symbol;
- (IBAction) EditTable:(id)sender;
@end
