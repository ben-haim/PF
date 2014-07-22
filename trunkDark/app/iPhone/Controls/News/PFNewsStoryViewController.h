#import <UIKit/UIKit.h>

@protocol PFStory;

@interface PFNewsStoryViewController : UIViewController 

@property ( nonatomic, strong ) IBOutlet UIActivityIndicatorView* loadingView;
@property ( nonatomic, strong ) IBOutlet UIWebView* webView;

+(id)controllerWithStory:( id< PFStory > )story_;

@end
