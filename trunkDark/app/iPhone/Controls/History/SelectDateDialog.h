
#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"


@interface SelectDateDialog : UIViewController 
{
	UIDatePicker *picker;
	int stage;
	ParamsStorage *storage;
	UILabel *actionLabel;
	UITextField *txtDate;
}
@property (nonatomic, retain) IBOutlet UIDatePicker *picker;
@property (nonatomic, retain) ParamsStorage *storage;
@property (nonatomic, retain) IBOutlet UILabel *actionLabel;
@property (nonatomic, retain) IBOutlet UITextField *txtDate;
@property (assign) int stage;

-(void)doneClicked:(id)sender;
-(void)SetStage:(int)_stage AndParams:( ParamsStorage *)_storage;
-(IBAction) dateChanged;
@end
