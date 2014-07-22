#import "PFTableViewController.h"

@class PFChartSettings;
@protocol PFChartSettingsViewControllerDelegate;

@interface PFChartSettingsViewController : PFTableViewController

@property ( nonatomic, strong, readonly ) PFChartSettings* settings;
@property ( nonatomic, weak ) id< PFChartSettingsViewControllerDelegate > delegate;

-(id)initWithSettings:( PFChartSettings* )chart_settings_;

@end

@protocol PFChartSettingsViewControllerDelegate < NSObject >

-(void)didCompleteSettingsController:( PFChartSettingsViewController* )controller_;
-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_;

@end
