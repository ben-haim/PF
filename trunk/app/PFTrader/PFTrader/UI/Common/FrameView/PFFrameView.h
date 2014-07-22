#import <UIKit/UIKit.h>

@interface PFFrameView : UIView

@property ( nonatomic, strong ) UIView* contentView;

-(void)setImage:( UIImage* )image_;
-(void)setColor:( UIColor* )color_;

@end
