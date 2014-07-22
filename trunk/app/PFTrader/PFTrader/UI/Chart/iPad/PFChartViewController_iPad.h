#import "PFChartViewController.h"

#import <UIKit/UIKit.h>

@interface PFChartViewController_iPad : PFChartViewController

@property ( nonatomic, strong ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* volumeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* volumeLabel;
@property ( nonatomic, strong ) IBOutlet UIButton* buyButton;
@property ( nonatomic, strong ) IBOutlet UIButton* sellButton;
@property ( nonatomic, strong ) IBOutlet UITextField* qtyField;
@property ( nonatomic, strong ) IBOutlet UILabel* qtyLabel;

-(IBAction)buyAction:(id)sender;
-(IBAction)sellAction:(id)sender;
-(IBAction)qtyExitAction:(id)sender;

@end
