#import "PFMarketOperationViewController.h"

#import <UIKit/UIKit.h>

@protocol PFPosition;

@interface PFModifyPositionViewController : PFMarketOperationViewController

@property (strong, nonatomic) IBOutlet UIButton* modifyButton;
@property (strong, nonatomic) IBOutlet UIButton* closeButton;
@property (strong, nonatomic) IBOutlet UILabel* bidTextLabel;
@property (strong, nonatomic) IBOutlet UILabel* askTextLabel;

+(void)showWithPosition:( id< PFPosition > )position_;

-(IBAction)modifyPositionAction:( id )sender_;
-(IBAction)closePositionAction:( id )sender_;

@end
