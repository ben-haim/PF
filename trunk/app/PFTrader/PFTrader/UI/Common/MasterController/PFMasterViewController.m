#import "PFMasterViewController.h"

@interface PFMasterViewController ()

@property ( nonatomic, strong ) UIView* masterView;
@property ( nonatomic, strong ) UIView* detailView;

@end

@implementation PFMasterViewController

@synthesize masterController = _masterController;
@synthesize detailController = _detailController;

@synthesize masterView;
@synthesize detailView;

-(void)addController:( UIViewController* )controller_
              toView:( UIView* )view_
{
   controller_.view.frame = view_.bounds;
   controller_.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   [ view_ addSubview: controller_.view ];
}

-(void)setMasterController:( UIViewController* )controller_
{
   [ _masterController.view removeFromSuperview ];
   [ self addController: controller_ toView: self.masterView ];
   _masterController = controller_;
}

-(void)setDetailController:( UIViewController* )controller_
{
   [ _detailController.view removeFromSuperview ];
   [ self addController: controller_ toView: self.detailView ];
   _detailController = controller_;
}

-(void)loadView
{
   CGFloat master_width_ = 320.f;

   self.view = [ [ UIView alloc ] initWithFrame: [ UIScreen mainScreen ].bounds ];

   CGRect master_rect_ = CGRectZero;
   CGRect detail_rect_ = CGRectZero;

   CGRectDivide( self.view.bounds,
                &master_rect_,
                &detail_rect_,
                master_width_,
                CGRectMinXEdge );

   self.masterView = [ [ UIView alloc ] initWithFrame: master_rect_ ];
   self.masterView.backgroundColor = [ UIColor clearColor ];
   self.masterView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;

   [ self addController: self.masterController toView: self.masterView ];

   [ self.view addSubview: self.masterView ];

   self.detailView = [ [ UIView alloc ] initWithFrame: detail_rect_ ];
   self.detailView.backgroundColor = [ UIColor clearColor ];
   self.detailView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   
   [ self addController: self.detailController toView: self.detailView ];

   [ self.view addSubview: self.detailView ];
}

@end
