

#import "MailItem.h"


@implementation MailItem

@synthesize isRead;
@synthesize sender_login;
@synthesize sender;
@synthesize subject;
@synthesize text;
@synthesize date;
@synthesize data;

- (void)dealloc 
{
	if(sender!=nil)
		[sender release];
	if(subject!=nil)
		[subject release];
	if(text!=nil)
		[text release];
	if(date!=nil)
		[date release];
	subject = nil;
	sender = nil;
	text = nil;
	date = nil;
    [data release];
	[super dealloc];
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
	NSString *StrIsRead  = [[NSString alloc] initWithFormat:@"%d", isRead?1:0];
	[encoder encodeObject:StrIsRead forKey:@"isRead"];
	[StrIsRead autorelease];
	
	NSString *StrSenderLogin  = [[NSString alloc] initWithFormat:@"%d", self.sender_login];
	[encoder encodeObject:StrSenderLogin forKey:@"sender_login"];
	[StrSenderLogin autorelease];

	[encoder encodeObject:sender forKey:@"sender"];
	[encoder encodeObject:subject forKey:@"subject"];
	[encoder encodeObject:text forKey:@"text"];
	[encoder encodeObject:date forKey:@"date"];
    [encoder encodeObject:data forKey:@"data"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
	NSString *StrIsRead  = [decoder decodeObjectForKey:@"isRead"];
	NSString *StrSenderLogin  = [decoder decodeObjectForKey:@"sender_login"];
	self.isRead = [StrIsRead integerValue]>0;
	self.sender_login = [StrSenderLogin integerValue];
	self.sender = [decoder decodeObjectForKey:@"sender"];
	self.subject = [decoder decodeObjectForKey:@"subject"];
	self.text = [decoder decodeObjectForKey:@"text"];
	self.date = [decoder decodeObjectForKey:@"date"];
    self.data = [decoder decodeObjectForKey:@"data"];
	return self;
}

@end
