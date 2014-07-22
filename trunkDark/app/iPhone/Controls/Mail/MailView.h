

#import <UIKit/UIKit.h>
#import "iFXWebView.h"


@interface MailView : UIViewController 
{
	IBOutlet UIWebView *webView;
    NSInteger mailIndex;
}

@property (nonatomic, retain) UIWebView *webView; 
@property (nonatomic, assign) NSInteger mailIndex;

- (void)deleteMail;
-(void) showMailBody:(NSString*)htmlBody withIndex:(NSInteger)index;
-(void) showMailData:(NSData*)htmlBody withIndex:(NSInteger)index;

@end
