#import "PFViewController.h"

@class PFServerInfo;

@protocol PFLoadViewControllerDelegate;

@interface PFLoadViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UILabel* statusLabel;

@property ( nonatomic, assign ) id< PFLoadViewControllerDelegate > delegate;

-(id)initWithLogin:( NSString* )login_
          password:( NSString* )password_
        serverInfo:( PFServerInfo* )server_info_;

-(IBAction)cancelAction:( id )sender_;

@end

@class PFSession;

@protocol PFLoadViewControllerDelegate <NSObject>

-(void)loadViewController:( PFLoadViewController* )controller_
          didLogonSession:( PFSession* )session_;

-(void)loadViewController:( PFLoadViewController* )controller_
         didFailWithError:( NSError* )error_;

-(void)loadViewController:( PFLoadViewController* )controller_
didChangePasswordForLogin:( NSString* )login_;

-(void)didCancelLoadViewController:( PFLoadViewController* )controller_;

@end
