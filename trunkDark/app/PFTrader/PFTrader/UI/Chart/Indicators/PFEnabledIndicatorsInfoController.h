//
//  PFEnabledIndicatorsInfoController.h
//  PFTrader
//
//  Created by Denis on 27.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFIndicator;
@class PFChartSettings;
@class PFIndicatorSettingsViewController;
@class PFIndicatorsViewController;
@protocol PFEnabledIndicatorsInfoControllerDelegate;

@interface PFEnabledIndicatorsInfoController : UITableViewController

@property ( nonatomic, strong, readonly ) PFChartSettings* settings;

+(id)controllerWithSettings:( PFChartSettings* )settings_
                   delegate:( id< PFEnabledIndicatorsInfoControllerDelegate > )delegate_
                     isMain:( BOOL )is_main_;

-(void)updateTable;
-(void)removeIndicator:( PFIndicator* )indicator_;

@end

@protocol PFEnabledIndicatorsInfoControllerDelegate < NSObject >

-(void)showIndicatorSettingsController:( PFIndicatorSettingsViewController* )controller_;
-(void)showAllIndicatorsController:( PFIndicatorsViewController* )controller_;

@end
