
#import <UIKit/UIKit.h>

#import "../../Code/ParamsStorage.h"
#import "../../Code/SymbolGroup.h"
#import "../../Code/SymbolInfo.h"
#import "../../Code/TickData.h"
#import "../Chart/Chart.h"
#import "../Chart/ChartViewController.h"

@class UINavigationButton;

@interface TradePaneController : UIViewController  <UIPickerViewDelegate, UIPickerViewDataSource>
{
	IBOutlet UILabel *lblSymbol;
	
	IBOutlet UIButton *btnBuy;
	IBOutlet UIButton *btnSell;
	IBOutlet UIButton *btnPlacePending;
	UISegmentedControl *segmentedControl;
	
	IBOutlet UITextField *edtVol;
	IBOutlet UIButton *edtSL; //UITextField *edtSL;
	IBOutlet UIButton *edtTP; //UITextField *edtTP;
	
	
	IBOutlet UILabel *lblBidPrice1;
	IBOutlet UILabel *lblBidPrice2;
	IBOutlet UILabel *lblBidPrice3;
	
	IBOutlet UILabel *lblAskPrice1;
	IBOutlet UILabel *lblAskPrice2;
	IBOutlet UILabel *lblAskPrice3;
	UIBarButtonItem *segmentBarItem;
	
	IBOutlet UIView *pnlInstant;
	IBOutlet UIView *pnlPending;
	IBOutlet UISegmentedControl *btnPendingType;
	IBOutlet UIButton *edtPendingPrice; //UITextField *edtPendingPrice;
	
	IBOutlet UILabel *lblTitleAtPrice;
	IBOutlet UILabel *lblTitleVol;
	IBOutlet UILabel *lblTitleSL;
	IBOutlet UILabel *lblTitleTP;
	IBOutlet UILabel *lblTitleSell;
	IBOutlet UILabel *lblTitleBuy;
	
	IBOutlet UIImageView *trade_edit_bg;
	IBOutlet UIImageView *trade_bg;
	
	UILabel *titleLabel;

	ParamsStorage *storage;
	SymbolInfo *sym;
	ChartViewController *chart;
	ChartViewController *modal_chart;
	CGRect small_chart_rect;
	double bid;
	double ask;
	
	UIPickerView *pricePicker;
	int pickerComponentsCount;
	BOOL isSL;
	BOOL isPending;
	
	IBOutlet UIView *volPopup;
	IBOutlet UIView *clearPopup;
	IBOutlet UIImageView *clear_panel;
	BOOL isClearPanel_rotated;

	TradePaneType mytype;
    
    NSNumberFormatter *numberFormatter;
}


@property (nonatomic, retain) IBOutlet UIButton *btnBuy;
@property (nonatomic, retain) IBOutlet UIButton *btnSell;
@property (nonatomic, retain) IBOutlet UIButton *btnPlacePending;

@property (nonatomic, retain) IBOutlet UILabel *lblSymbol;

@property (nonatomic, retain) IBOutlet UITextField *edtVol;
@property (nonatomic, retain) IBOutlet UIButton *edtSL; //UITextField *edtSL;
@property (nonatomic, retain) IBOutlet UIButton *edtTP; //UITextField *edtTP;

@property (nonatomic, retain) IBOutlet UILabel *lblBidPrice1;
@property (nonatomic, retain) IBOutlet UILabel *lblBidPrice2;
@property (nonatomic, retain) IBOutlet UILabel *lblBidPrice3;

@property (nonatomic, assign) ParamsStorage *storage;
@property (nonatomic, retain) IBOutlet UILabel *lblAskPrice1;
@property (nonatomic, retain) IBOutlet UILabel *lblAskPrice2;
@property (nonatomic, retain) IBOutlet UILabel *lblAskPrice3;
@property (nonatomic, retain) IBOutlet ChartViewController *chart;

@property (nonatomic, retain) IBOutlet UIView *pnlInstant;
@property (nonatomic, retain) IBOutlet UIView *pnlPending;
@property (nonatomic, retain) IBOutlet UIButton *edtPendingPrice; //UITextField *edtPendingPrice;
@property (nonatomic, retain) IBOutlet UISegmentedControl *btnPendingType;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleAtPrice;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleVol;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSL;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleTP;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSell;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleBuy;

@property (nonatomic, retain) IBOutlet UIImageView *trade_edit_bg;
@property (nonatomic, retain) IBOutlet UIImageView *trade_bg;

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UIPickerView *pricePicker;
@property (nonatomic, retain) IBOutlet UIView *volPopup;
@property (nonatomic, retain) IBOutlet UIView *clearPopup;
@property (nonatomic, retain) IBOutlet UIImageView *clear_panel;

@property (nonatomic, retain) ChartViewController *modal_chart;
@property (nonatomic, retain) SymbolInfo *sym;

@property (assign) TradePaneType mytype;

-(void)ShowForSymbol:(SymbolInfo *)si AndParams:(ParamsStorage*)p;
-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3;
- (BOOL)textFieldShouldReturn:(UITextField*)aTextBox;
- (IBAction) textFieldDidBeginEditing:(id)sender;   
- (IBAction) textFieldEditingDidEnd:(id)sender;
- (IBAction) buyClicked:(id)sender;
- (IBAction) sellClicked:(id)sender;
- (IBAction) placePending:(id)sender;
- (IBAction) SLClicked:(id)sender;
- (IBAction) TPClicked:(id)sender;
- (IBAction) PendingClicked:(id)sender;
- (IBAction) HideVolume:(id)sender;
- (IBAction) volumeClicked:(id)sender;
- (IBAction) volumeUpClicked:(id)sender;
- (IBAction) volumeDownClicked:(id)sender;
- (IBAction) volumeUp10Clicked:(id)sender;
- (IBAction) volumeDown10Clicked:(id)sender;
- (IBAction) ValidateVolume:(id)sender;
-(BOOL)ValidateTextEdit:(UITextField*)aTextBox;
- (int) ExecMode;
- (IBAction) clearSL:(id)sender;
- (IBAction) clearTP:(id)sender;
- (IBAction) clearPending:(id)sender;
- (IBAction) clearField:(id)sender;
-(void)goBack:(id)sender;
-(void)rotateClearPanel;

//-(void)pickerViewLoaded: (id)blah forComponent:(NSUInteger)component;
-(void) showHideButton:(id)sender;
-(void) showSpinner: (BOOL)forBid IsPending: (BOOL)isPendingOrder;
-(void) HideSpinner:(id)sender;
-(NSString*) getSpinnerValue;

- (void)showVolumeZeroDialog;

- (void) segmentAction:(id)sender;

@end
