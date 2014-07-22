//
//  PFSplitViewController.m
//  PFTrader
//
//  Created by Denis on 08.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFSplitViewController.h"
#import "UIViewController+Wrapper.h"
#import "UIColor+Skin.h"

@interface PFSplitViewController () < UISplitViewControllerDelegate >

@property ( nonatomic, strong ) UIView* coverView;

@end

@implementation PFSplitViewController

@synthesize masterControllerWidth = _masterControllerWidth;
@synthesize coverView;

-(void)dealloc
{
   self.coverView = nil;
}

-(id)initWithMasterController:( UIViewController* )master_controller_
{
   self = [ super init ];
   
   if ( self )
   {
      self.viewControllers = @[ [ master_controller_ wrapIntoNavigationController ],
                                [ [ self emptyController ] wrapIntoNavigationController ] ];
      self.delegate = self;
      self.masterControllerWidth = 320.f;
      
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.view.backgroundColor = [ UIColor blackColor ];
   
   self.coverView = [ [ UIView alloc ] initWithFrame: CGRectMake( 320.f, 0.f, 1.f, 64.f ) ];
   self.coverView.backgroundColor = [ UIColor blackColor ];
   [ self.view addSubview: self.coverView ];
}

-(UIViewController*)emptyController
{
   UIViewController* controller_ = [ UIViewController new ];
   controller_.view.backgroundColor = [ UIColor backgroundDarkColor ];
   
   return controller_;
}

-(void)setMasterControllerWidth:(CGFloat)master_controller_width_
{
   _masterControllerWidth = master_controller_width_;
   self.coverView.hidden = master_controller_width_ == 0.f;
}

-(void)showDetailController:( UIViewController* )detail_controller_
{
   UINavigationController* second_controller_ = detail_controller_ ? [ detail_controller_ wrapIntoNavigationController ] : [ [ self emptyController ] wrapIntoNavigationController ];
   self.viewControllers = @[ (self.viewControllers)[0], second_controller_ ];
}

-(void)viewDidLayoutSubviews
{
   [ super viewDidLayoutSubviews ];
   
   UIViewController* master_view_controller_ = self.viewControllers.count > 0 ? (self.viewControllers)[0] : nil;
   UIViewController* detail_view_controller_ = self.viewControllers.count > 1 ? (self.viewControllers)[1] : nil;
   
   if ( detail_view_controller_.view.frame.origin.x > 0.f )
   {
      CGRect master_view_frame_ = master_view_controller_.view.frame;
      CGFloat delta_X_ = master_view_frame_.size.width - self.masterControllerWidth;
      master_view_frame_.size.width -= delta_X_;
      master_view_controller_.view.frame = master_view_frame_;
      
      if ( self.masterControllerWidth == 0.f )
      {
         delta_X_++;
      }
      
      CGRect detail_view_frame_ = detail_view_controller_.view.frame;
      detail_view_frame_.origin.x -= delta_X_;
      detail_view_frame_.size.width += delta_X_;
      detail_view_controller_.view.frame = detail_view_frame_;
      
      [ master_view_controller_.view setNeedsLayout ];
      [ detail_view_controller_.view setNeedsLayout ];
   }
}

#pragma mark - UISplitViewControllerDelegate

-(BOOL)splitViewController:( UISplitViewController* )svc_
  shouldHideViewController:( UIViewController* )vc_
             inOrientation:( UIInterfaceOrientation )orientation_
{
   return NO;
}


@end
