#import "PFTableViewController.h"

#import <UIKit/UIKit.h>

@protocol PFRegistrationViewControllerDelegate;
@class PFServerInfo;

@interface PFRegistrationViewController : PFTableViewController

@property ( nonatomic, weak ) id< PFRegistrationViewControllerDelegate > delegate;

-(id)initWithServerInfo:( PFServerInfo* )server_info_;

@end

@protocol PFDemoAccount;

@protocol PFRegistrationViewControllerDelegate <NSObject>

-(void)registrationController:( PFRegistrationViewController* )registration_controller_
         didCreateDemoAccount:( id< PFDemoAccount > )demo_account_;

-(void)didCancelRegistrationController:( PFRegistrationViewController* )registration_controller_;

@end
