

#import <UIKit/UIKit.h>
#import "../../Code/ParamsStorage.h"
#import "../../Classes/iTraderAppDelegate.h"
#import "../../Code/MailItem.h"
#import "Base64.h"
#import "MySingleton.h"

@class ParamsStorage;

@interface MailList : UITableViewController 
{
	NSDateFormatter *date_format;
	NSString *last_title; 
	UIImage *rowIconRead;
	UIImage * rowIconUnread;
}

-(void) clear;
-(void) ProcessMail:(NSArray *)mail_args;
-(void) ShowNews:(NSString *)news_body;
- (void)deleteMail;

@end
