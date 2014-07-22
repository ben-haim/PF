#import <UIKit/UIKit.h>

@class PFLoginViewController;
@class PFLoadViewController;

@class PFServerInfo;

@interface PFLayoutManager : NSObject

@property ( nonatomic, strong, readonly ) UIViewController* menuViewController;
@property ( nonatomic, strong, readonly ) PFLoginViewController* loginViewController;

@property ( nonatomic, assign, readonly ) BOOL isPaginalGridView;
@property ( nonatomic, assign, readonly ) BOOL shouldShrinkOnKeyboard;

-(PFLoadViewController*)loadViewControllerWithLogin:( NSString* )login_
                                           password:( NSString* )password_
                                         serverInfo:( PFServerInfo* )server_info_;
-(void)updateMenuItems;

+(PFLayoutManager*)currentLayoutManager;

@end
