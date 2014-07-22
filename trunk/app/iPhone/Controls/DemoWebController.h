

#import <UIKit/UIKit.h>


@interface DemoWebController : UIViewController<UIWebViewDelegate>
{
	
	UIWebView *webView;
	UIActivityIndicatorView *activity;
}

@property (nonatomic, retain) UIWebView *webView;
@end
