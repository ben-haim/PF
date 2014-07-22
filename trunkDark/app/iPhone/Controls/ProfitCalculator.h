

#import <UIKit/UIKit.h>


@interface ProfitCalculator : UIViewController <UIWebViewDelegate>
{
	IBOutlet UIWebView *webView;
	UIActivityIndicatorView *activity;
}
@property (nonatomic, retain) UIWebView *webView; 
@end

