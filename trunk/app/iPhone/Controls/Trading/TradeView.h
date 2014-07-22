
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"


@interface TradeView : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
	
	ParamsStorage *storage;
	TradeRecord *tr;
	IBOutlet UILabel *lblSymbol;
	IBOutlet UILabel *lblOrderNo;
	IBOutlet UILabel *lblOpenTime;
	IBOutlet UILabel *lblSwap;
	IBOutlet UILabel *lblOrderType;
	IBOutlet UILabel *lblProfit;
	IBOutlet UILabel *lblVolume;
	IBOutlet UIButton *edtOpenPrice;
	IBOutlet UILabel *lblClosePrice;
	IBOutlet UIButton *edtSL; //UITextField *edtSL;
	IBOutlet UIButton *edtTP; //UITextField *edtTP;
	IBOutlet UILabel *lblExecution;
	IBOutlet UILabel *lblCommission;
	IBOutlet UITextField *edtVol;
	
	IBOutlet UILabel *lblTitleOrderNo;
	IBOutlet UILabel *lblTitleOpenTime;
	IBOutlet UILabel *lblTitleSymbol;
	IBOutlet UILabel *lblTitleBuyLimit;
	IBOutlet UILabel *lblTitleSwap;
	IBOutlet UILabel *lblTitleOpenPrice;
	IBOutlet UILabel *lblTitleClosePrice;
	IBOutlet UILabel *lblTitleVolume;
	IBOutlet UILabel *lblTitleProfit;	
	IBOutlet UILabel *lblTitleCommission;
	IBOutlet UILabel *lblTitleSL;
	IBOutlet UILabel *lblTitleTP;
	
	IBOutlet UIButton *btnClose;
	IBOutlet UIButton *btnUpdate;
	IBOutlet UIButton *btnDelete;
	
	IBOutlet UIButton *btnClearSL;
	IBOutlet UIButton *btnClearTP;
	IBOutlet UIButton *btnClearPrice;
	
	IBOutlet UIView *line;
	IBOutlet UIImageView *bgView;
	IBOutlet UIView *edtVolView;
	IBOutlet UIView *volPopup;
	IBOutlet UILabel *lblVolOriginal;
	
	BOOL _isSL;
	BOOL isPending;
	UIPickerView *pricePicker;
	int pickerComponentsCount;
	
    NSNumberFormatter *numberFormatter;
}

- (IBAction) textFieldDidBeginEditing:(id)sender;
- (IBAction) textFieldEditingDidEnd:(id)sender;
-(void)ShowForTrade:(TradeRecord *)_tr AndParams:(ParamsStorage*)p;
-(BOOL)ValidateTextEdit:(UITextField*)aTextBox;
- (IBAction) closeClicked:(id)sender;
- (IBAction) updateClicked:(id)sender;
- (IBAction) deleteClicked:(id)sender;
- (void) goBack;
- (void)UpdatePrice;

- (IBAction) ValidateVolume:(id)sender;
- (IBAction) volumeChanged:(id)sender;
- (IBAction) HideVolume:(id)sender;
- (IBAction) volumeClicked:(id)sender;
- (IBAction) volumeUpClicked:(id)sender;
- (IBAction) volumeDownClicked:(id)sender;
- (IBAction) volumeUp10Clicked:(id)sender;
- (IBAction) volumeDown10Clicked:(id)sender;

- (IBAction) SLClicked:(id)sender;
- (IBAction) TPClicked:(id)sender;
- (IBAction) PriceClicked:(id)sender;

- (IBAction) clearSL:(id)sender;
- (IBAction) clearTP:(id)sender;
- (IBAction) clearPrice:(id)sender;

-(void) showHideButton:(id)sender;
-(void) showSpinner: (BOOL)isSL IsPending: (BOOL)isPendingOrder;
-(void) HideSpinner:(id)sender;
-(NSString*) getSpinnerValue;


@property (nonatomic, assign) ParamsStorage *storage;
@property (nonatomic, retain) TradeRecord *tr;


@property (nonatomic, retain) IBOutlet UIButton *btnClose;
@property (nonatomic, retain) IBOutlet UIButton *btnUpdate;
@property (nonatomic, retain) IBOutlet UIButton *btnDelete;

@property (nonatomic, retain) IBOutlet UILabel *lblSymbol;
@property (nonatomic, retain) IBOutlet UILabel *lblOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblOpenTime;
@property (nonatomic, retain) IBOutlet UILabel *lblSwap;
@property (nonatomic, retain) IBOutlet UILabel *lblOrderType;
@property (nonatomic, retain) IBOutlet UILabel *lblProfit;
@property (nonatomic, retain) IBOutlet UILabel *lblVolume;
@property (nonatomic, retain) IBOutlet UIButton *edtOpenPrice;
@property (nonatomic, retain) IBOutlet UILabel *lblClosePrice;
@property (nonatomic, retain) IBOutlet UIButton *edtSL;
@property (nonatomic, retain) IBOutlet UIButton *edtTP;
@property (nonatomic, retain) IBOutlet UILabel *lblExecution;
@property (nonatomic, retain) IBOutlet UILabel *lblCommission;
@property (nonatomic, retain) IBOutlet UITextField *edtVol;

@property (nonatomic, retain) IBOutlet UILabel *lblTitleOrderNo;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleOpenTime;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSymbol;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleBuyLimit;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSwap;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleOpenPrice;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleClosePrice;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleVolume;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleProfit;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleCommission;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleSL;
@property (nonatomic, retain) IBOutlet UILabel *lblTitleTP;

@property (nonatomic, retain) IBOutlet UIView *line;
@property (nonatomic, retain) IBOutlet UIImageView *bgView;
@property (nonatomic, retain) IBOutlet UIView *edtVolView;
@property (nonatomic, retain) IBOutlet UIView *volPopup;

@property (nonatomic, retain) IBOutlet UILabel *lblVolOriginal;
@property (nonatomic, retain) UIPickerView *pricePicker;

@property (nonatomic, retain) IBOutlet UIButton *btnClearSL;
@property (nonatomic, retain) IBOutlet UIButton *btnClearTP;
@property (nonatomic, retain) IBOutlet UIButton *btnClearPrice;

@end
