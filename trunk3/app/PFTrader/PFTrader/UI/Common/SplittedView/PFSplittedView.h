#import "PFSplittedViewState.h"

#import <UIKit/UIKit.h>

@interface PFSplittedView : UIView

@property ( nonatomic, strong ) UIView* topView;
@property ( nonatomic, strong ) UIView* bottomView;

@property ( nonatomic, assign ) CGFloat topPart;
@property ( nonatomic, assign ) PFSplittedViewState state;

-(void)setState:( PFSplittedViewState )state_ animated:( BOOL )animated_;

@end
