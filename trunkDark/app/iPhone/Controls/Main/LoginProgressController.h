#import <UIKit/UIKit.h>

@class XColoredProgress;

@interface LoginProgressController : UIViewController 

@property (assign) BOOL isCanceled;

@property (nonatomic, retain) IBOutlet id MainWnd;
@property (nonatomic, retain) IBOutlet UILabel *lblStatus;
@property (nonatomic, retain) IBOutlet UIButton *btnCancel;
@property (nonatomic, retain) IBOutlet XColoredProgress *pbProgress;
@property (nonatomic, retain) IBOutlet UIImageView *logo;
@property (nonatomic, retain) IBOutlet UIImageView *bg;

@property ( nonatomic, assign ) NSUInteger stepsCount;

-(void)reset;

- (IBAction)btnCancel_Clicked:(id)sender;

-(void)stepCompletedWithDescription:( NSString* )description_;

@end
