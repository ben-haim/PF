#import <UIKit/UIKit.h>

@class PFChartSettings;

@protocol PFActiveIndicatorsViewControllerDelegate;

@interface PFActiveIndicatorsViewController : UITableViewController

@property ( nonatomic, strong, readonly ) PFChartSettings* settings;

@property ( nonatomic, weak ) id< PFActiveIndicatorsViewControllerDelegate > delegate;

-(id)initWithSettings:( PFChartSettings* )settings_;

@end

@protocol PFActiveIndicatorsViewControllerDelegate< NSObject >

-(void)didCompleteIndicatorsController:( PFActiveIndicatorsViewController* )controller_;
-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_;

@end
