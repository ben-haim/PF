#import <UIKit/UIKit.h>
#import "MySingleton.h"


@interface Calendar : UIViewController<UIWebViewDelegate>
{
	IBOutlet UIWebView *webView;
	UIActivityIndicatorView *activity;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@property (nonatomic, retain) UIWebView *webView; 
@end
