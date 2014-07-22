#import "PFViewController.h"

@class FinanceChart;
@class ChartSensorView;

@class PFActionSheetButton;

@protocol PFSymbol;

@interface PFChartViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet FinanceChart* chartView;
@property ( nonatomic, strong ) IBOutlet ChartSensorView* sensorView;

@property ( nonatomic, strong ) IBOutlet UITextField* nameField;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* emptyLabel;

@property ( nonatomic, strong ) IBOutlet PFActionSheetButton* rangeButton;

@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet UIView* drawingsView;
@property (strong, nonatomic) IBOutlet UIView* propertiesView;
@property (strong, nonatomic) IBOutlet UIView* buttonsView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray* drawButtons;

@property ( nonatomic, strong ) id< PFSymbol > symbol;

-(id)initWithSymbol:( id< PFSymbol > )symbol_ andSymbols:( NSArray* )symbols_;

-(id)initSeparateChartWithSymbol:( id< PFSymbol > )symbol_ andSymbols:( NSArray* )symbols_;

-(BOOL)tryAllowTrading;
-(void)showOrderEntry;

-(IBAction)indicatorsAction:(id)sender_;
-(IBAction)settingsAction:(id)sender_;
-(IBAction)rangeChangeAction:( id )sender_;
-(IBAction)drawChangeAction:( id )sender_;
-(IBAction)drawAction:( id )sender_;
-(IBAction)symbolChangeAction:( id )sender_;

@end
