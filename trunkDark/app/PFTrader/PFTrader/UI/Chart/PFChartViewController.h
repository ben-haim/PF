#import "PFViewController.h"

@class FinanceChart;
@class ChartSensorView;
@class PFActionSheetButton;
@class PFLoadingView;
@protocol PFSymbol;
@protocol PFOrder;
@protocol PFPosition;

@interface PFChartViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet FinanceChart* chartView;
@property ( nonatomic, strong ) IBOutlet ChartSensorView* sensorView;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* emptyLabel;
@property ( nonatomic, strong ) IBOutlet PFActionSheetButton* rangeButton;
@property ( nonatomic, strong ) IBOutlet UIScrollView* scrollView;
@property ( nonatomic, strong ) IBOutlet UIView* drawingsView;
@property ( nonatomic, strong ) IBOutlet UIView* propertiesView;
@property ( nonatomic, strong ) IBOutlet UIView* buttonsView;
@property ( nonatomic, strong ) IBOutletCollection( UIButton ) NSArray* drawButtons;
@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong, readonly ) PFLoadingView* loadingIndicator;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;
-(void)processOrderRemoving:( id< PFOrder > )order_;
-(void)processPositionRemoving:( id< PFPosition > )position_;
-(void)showLoadingView;
-(void)timerUpdate;

-(IBAction)indicatorsAction:( id )sender_;
-(IBAction)settingsAction:( id )sender_;
-(IBAction)rangeChangeAction:( id )sender_;
-(IBAction)drawChangeAction:( id )sender_;
-(IBAction)drawAction:( id )sender_;

@end
