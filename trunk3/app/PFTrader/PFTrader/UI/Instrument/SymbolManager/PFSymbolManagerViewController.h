#import "PFViewController.h"

@class FinanceChart;
@class ChartSensorView;

@protocol PFSymbol;

@interface PFSymbolManagerViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UIView* chartHolderView;
@property ( nonatomic, strong ) IBOutlet FinanceChart* chartView;
@property ( nonatomic, strong ) IBOutlet ChartSensorView* sensorView;
@property ( nonatomic, strong ) IBOutlet UILabel* emptyLabel;
@property ( nonatomic, strong ) IBOutlet UIView* actionsView;
@property ( nonatomic, strong ) IBOutlet UILabel* symbolNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* symbolOverviewLabel;

@property ( nonatomic, strong ) IBOutlet UILabel* bidNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* highNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* bidValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* highValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* lastNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* lowNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* lastValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* lowValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* askNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* closeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* openNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* askValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* closeValueLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* openValueLabel;

@property ( nonatomic, weak ) UIViewController* wrapController;

-(id)initWithSymbol:( id< PFSymbol > )symbol_
            symbols:( NSArray* )symbols_
           rowIndex:( NSUInteger )row_index_;

@end
