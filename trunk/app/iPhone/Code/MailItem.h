
#import <Foundation/Foundation.h>


@interface MailItem : NSObject 
{
	bool		isRead;
	int			sender_login;
	NSString *	sender;
	NSString *	subject;
	NSString *	text;
	NSString *	date; 
    NSData   *  data;
}
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

@property( assign) bool isRead;
@property( assign) int sender_login;
@property( nonatomic, retain) NSString *sender;
@property( nonatomic, retain) NSString *subject;
@property( nonatomic, retain) NSString *text;
@property( nonatomic, retain) NSString *date;
@property( nonatomic, retain) NSData *data;
@end

