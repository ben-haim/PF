#import "PFTableViewController.h"

typedef void (^PFChangePasswordDoneBlock)( BOOL changed_ );

@class PFSession;

@interface PFChangePasswordViewController : PFTableViewController

-(id)initWithTitle:( NSString* )title_
        andSession:( PFSession* )current_session_;

+(id)createAutoresetPasswordControllerWithSession:( PFSession* )current_session_
                                     andDoneBlock:( PFChangePasswordDoneBlock )done_block_;

@property ( nonatomic, weak ) IBOutlet UIButton* changeButton;

-(IBAction)changeAction:(id)sender_;

@end
