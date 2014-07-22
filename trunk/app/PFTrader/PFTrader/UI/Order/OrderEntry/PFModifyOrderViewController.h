#import "PFMarketOperationViewController.h"

#import <UIKit/UIKit.h>

@protocol PFOrder;

@interface PFModifyOrderViewController : PFMarketOperationViewController

@property (strong, nonatomic) IBOutlet UIButton* modifyButton;
@property (strong, nonatomic) IBOutlet UIButton* cancelButton;
@property (strong, nonatomic) IBOutlet UIButton* executeButton;
@property ( nonatomic, strong, readonly ) id< PFOrder > order;

-(id)initWithOrder:( id< PFOrder > )order_;

-(IBAction)modifyOrderAction:( id )sender_;
-(IBAction)cancelOrderAction:( id )sender_;
-(IBAction)executeAtMarketAction:( id )sender_;

@end
