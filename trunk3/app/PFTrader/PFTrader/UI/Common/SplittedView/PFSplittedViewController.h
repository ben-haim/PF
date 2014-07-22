#import "PFSplittedViewState.h"

#import "PFViewController.h"

@class PFSplittedView;

@interface PFSplittedViewController : PFViewController

@property ( nonatomic, strong, readonly ) PFSplittedView* splittedView;

@property ( nonatomic, strong ) UIViewController* topViewController;
@property ( nonatomic, strong ) UIViewController* bottomViewController;

@property ( nonatomic, assign ) PFSplittedViewState state;

-(void)setState:( PFSplittedViewState )state_ animated:( BOOL )animated_;

@end
