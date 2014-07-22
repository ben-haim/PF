#import "AccountInfo.h"
#import "iTraderAppDelegate.h"


@implementation AccountInfo

@synthesize account, password, serverAlias;

-(void)saveAccount
{
	 if (account == nil)
		 account = @"";
	 if (password == nil)
		 password = @"";
	 if (serverAlias == nil)
		 serverAlias = @"";
	
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray *accounts = [[appDelegate storage] getSavedAccounts];
	 
	int pos = -1;
	for (int i=0; i<[accounts count]; i++)
	{
		NSArray *accInfo = [[accounts objectAtIndex:i] componentsSeparatedByString:@"\0"];	 
		
		if ([[accInfo objectAtIndex:0] isEqualToString:self.account] 
			 && [[accInfo objectAtIndex:2] isEqualToString:self.serverAlias])
		{
			pos = i;
		}
	}
	
	if (pos == -1)
	{
		[accounts addObject:[NSString stringWithFormat:@"%@\0%@\0%@\0", account, password, serverAlias]];
		[[appDelegate storage] saveAccounts:accounts];
	}
	else
	{
		[accounts removeObjectAtIndex:pos];
		[accounts insertObject:[NSString stringWithFormat:@"%@\0%@\0%@\0", account, password, serverAlias] atIndex:pos];
		[[appDelegate storage] saveAccounts:accounts];
	}

	//[accounts release];
	
}

-(void)dealloc
{
	[account release];
	[password release];
	[serverAlias release];
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
	[coder encodeObject:account forKey:@"account"];
	[coder encodeObject:password forKey:@"password"];
	[coder encodeObject:serverAlias forKey:@"serverAlias"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
	//self = [[AccountInfo alloc] init];
	//if (self != nil)
	//	{
	account = [coder decodeObjectForKey:@"account"];
	password = [coder decodeObjectForKey:@"password"];
	serverAlias = [coder decodeObjectForKey:@"serverAlias"];
	//	} 
	return self;
}

@end
