#import "PFSplittedViewController.h"

#import "PFSplittedView.h"

@interface PFSplittedViewController ()

@property ( nonatomic, strong ) PFSplittedView* splittedView;

@end

@implementation PFSplittedViewController

@synthesize splittedView;

@synthesize topViewController = _topViewController;
@synthesize bottomViewController = _bottomViewController;

-(void)loadView
{
   self.view = [ [ UIView alloc ] initWithFrame: [ UIScreen mainScreen ].bounds ];

   self.splittedView = [ [ PFSplittedView alloc ] initWithFrame: self.view.bounds ];
   self.splittedView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   self.splittedView.topView = self.topViewController.view;
   self.splittedView.bottomView = self.bottomViewController.view;

   [ self.view addSubview: self.splittedView ];
}

-(void)setTopViewController:( UIViewController* )top_view_controller_
{
    self.splittedView.topView = top_view_controller_.view;
   _topViewController = top_view_controller_;
}

-(void)setBottomViewController:( UIViewController* )bottom_view_controller_
{
   self.splittedView.bottomView = bottom_view_controller_.view;
   _bottomViewController = bottom_view_controller_;
}

-(void)dealloc
{
    self.splittedView = nil;
}

-(PFSplittedViewState)state
{
   return self.splittedView.state;
}

-(void)setState:( PFSplittedViewState )state_
{
   self.splittedView.state = state_;
}

-(void)setState:( PFSplittedViewState )state_ animated:( BOOL )animated_
{
   [ self.splittedView setState: state_ animated: animated_ ];
}

@end
