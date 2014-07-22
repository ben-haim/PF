

#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "../../Classes/iTraderAppDelegate.h"
#import "MySingleton.h"

@interface Contacts : UIViewController<UIWebViewDelegate>
{
	
	IBOutlet UIWebView *webView;
	UIActivityIndicatorView *activity;
}

@property (nonatomic, retain) UIWebView *webView;
@end
