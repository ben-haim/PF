#import "PFChartViewController.h"

#import <UIKit/UIKit.h>

@interface PFChartViewController_iPad : PFChartViewController

@property ( nonatomic, strong ) IBOutlet UILabel* volumeNameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* spreadLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* volumeLabel;
@property (strong, nonatomic) IBOutlet UIButton* buyButton;
@property (strong, nonatomic) IBOutlet UIButton* sellButton;
@property (strong, nonatomic) IBOutlet UITextField* qtyField;
@property (strong, nonatomic) IBOutlet UILabel* qtyLabel;

-(IBAction)buyAction:(id)sender;
-(IBAction)sellAction:(id)sender;
-(IBAction)qtyExitAction:(id)sender;

@end
