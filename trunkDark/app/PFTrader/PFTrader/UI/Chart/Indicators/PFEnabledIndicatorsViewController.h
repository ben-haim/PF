//
//  PFУEnabledIndicatorsViewController.h
//  PFTrader
//
//  Created by Denis on 27.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabsViewController.h"

@class PFChartSettings;
@protocol PFEnabledIndicatorsViewControllerDelegate;

@interface PFEnabledIndicatorsViewController : PFTabsViewController

@property ( nonatomic, weak ) id< PFEnabledIndicatorsViewControllerDelegate > delegate;

-(id)initWithSettings:( PFChartSettings* )settings_;

@end

@protocol PFEnabledIndicatorsViewControllerDelegate < NSObject >

-(void)didCompleteIndicatorsController:( PFEnabledIndicatorsViewController* )controller_;
-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_;

@end
