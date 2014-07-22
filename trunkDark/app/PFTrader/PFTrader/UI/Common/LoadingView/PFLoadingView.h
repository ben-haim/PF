#import <UIKit/UIKit.h>

@interface PFLoadingView : UIView

@property ( nonatomic, assign ) UIActivityIndicatorViewStyle indicatorStyle;

-(void)showInView:( UIView* )view_;
-(void)hide;

@end
