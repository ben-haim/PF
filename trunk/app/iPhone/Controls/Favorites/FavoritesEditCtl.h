

#import <UIKit/UIKit.h>

#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"
#import "TradePaneController.h"

@interface UIAlertView (Extended)
- (UITextField*)addTextFieldWithValue:(NSString*)value label:(NSString*)label;
- (UITextField*)textFieldAtIndex:(NSUInteger)index;
- (NSUInteger)textFieldCount;
- (UITextField*)textField;
@end

@interface FavoritesEditCtl : UITableViewController 
{
	
	ParamsStorage *storage;
	NSMutableArray *FavSymbols;
	UITextField *textfieldName;
	
	TradePaneController *tradePane;
}
@property (assign) ParamsStorage *storage;
@property (nonatomic, retain) NSMutableArray *FavSymbols;
-(void)rebind;
-(void)SymbolUpdated:(NSString*)symbol;
- (IBAction) EditTable:(id)sender;
@end
