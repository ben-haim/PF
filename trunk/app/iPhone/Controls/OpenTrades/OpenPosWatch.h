
#import <UIKit/UIKit.h>

#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"

#import "../Grid/GridControler.h"
#import "../Grid/MarketWatchGridCell.h" 
#import "../Grid/OpenPosGridCell.h"
#import "../Grid/HeaderGridCell.h"
#import "../Grid/PendingPosGridCell.h"
#import "../Grid/BalanceGridCell.h"
#import "../Trading/TradeView.h"
#import "BalanceUIView.h"

#import "WEPopoverController.h"
#import "AggrOpenPosWatch.h"

@class TradeRecord;

@interface OpenPosWatch : UIViewController<UITableViewDelegate, WEPopoverControllerDelegate, UIPopoverControllerDelegate>
{	
	ParamsStorage *storage;
	BOOL isAllShown;
	NSMutableArray *open_items;
	NSMutableArray *pending_items;
	NSMutableDictionary *SymbolPositions;
	NSMutableDictionary *Dependencies;
	GridViewController *gridCtl;	
	BalanceUIView *myView;
	BOOL isBalanceExpanded;
	
	UILabel* txtAccount;
	UILabel* txtCredit;
	UILabel* txtProfit;
	UILabel* txtMargin;
	UILabel* txtBalance;
	UILabel* txtFree;
	UILabel* txtEquity;
	UILabel* txtLevel;
    
    //popover
    WEPopoverController *popoverController;
	NSInteger currentPopoverCellIndex;
	Class popoverClass;
    
    //Aggragate view
    AggrOpenPosWatch *aggragateViewControl;
}

@property( assign) ParamsStorage *	storage;
@property( nonatomic, retain) NSMutableArray *	open_items;
@property( nonatomic, retain) NSMutableArray *	pending_items;
@property( nonatomic, retain) NSMutableDictionary *		SymbolPositions;
@property( nonatomic, retain) NSMutableDictionary *		Dependencies;
@property (nonatomic, retain) IBOutlet GridViewController *gridCtl;
@property (nonatomic, retain) BalanceUIView *myView;

@property (nonatomic, retain) UILabel* txtAccount;
@property (nonatomic, retain) UILabel* txtCredit;
@property (nonatomic, retain) UILabel* txtProfit;
@property (nonatomic, retain) UILabel* txtMargin;
@property (nonatomic, retain) UILabel* txtBalance;
@property (nonatomic, retain) UILabel* txtFree;
@property (nonatomic, retain) UILabel* txtEquity;
@property (nonatomic, retain) UILabel* txtLevel;

@property (nonatomic, retain) WEPopoverController *popoverController;


-(void) ChangeView:(BOOL)_isAllShown;

-(void)addPosition:( TradeRecord* )trade_record_;
-(void)addPositions:( NSArray* )trades_;

//-(void) UpdateTradesList:(NSArray *)trade;
//-(void) UpdateTrades:(NSArray *)trade;
-(BOOL) UpdateProfits:(BOOL)forceChanged;
-(void) UpdateSummaryData;
- (void) Convert:(TradeRecord*)item UsingConv:(Conversion*)conv isCFD:(BOOL)cfd;
-(void) rebind:(BOOL)keepScroll;
-(void) SymbolUpdated:(NSString*)symbol;
- (void) segmentAction:(id)sender;
- (void)generateBalanceCell;
- (void)Expand:(id)sender;
- (void)updateBalanceValues;

- (IBAction)showPopover:(id)sender;
- (void)dismissPopover;
- (void)dismissPopoverAndChangeToView:(OpenTradesViewType)openTradesViewType;

@end
