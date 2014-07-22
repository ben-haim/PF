#import <UIKit/UIKit.h>

@class FinanceChart;

@interface PFChartHolderView : UIView

@property ( nonatomic, strong ) IBOutlet UIView* portraiteHolderView;
@property ( nonatomic, strong ) IBOutlet UIView* chartView;
@property ( nonatomic, strong ) IBOutlet FinanceChart* financeChart;

@end
