

#import "MailList.h"
#import "MailListCell.h"
#import "MailView.h"
#import "CP1251Decoder.h"
#import "ClientParams.h"

@implementation MailList


- (void)viewDidLoad 
{
	// Add the following line if you want the list to be editable
	// self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	self.tableView.rowHeight = 60;
	self.tableView.separatorColor = [UIColor clearColor];
	
	
	rowIconRead = [UIImage imageNamed:@"MailRead.png"];
	rowIconUnread = [UIImage imageNamed:@"MailUnread.png"];	
	
	self.navigationItem.title = NSLocalizedString(@"TABS_MAIL", nil);
	self.navigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	self.tabBarController.moreNavigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"logo_small" ofType:@"png"];
	if (filepath) 
	{
		UIImage *image = [UIImage imageNamed:@"logo_small.png"];
		self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
	}
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deleteMail:)
												 name:@"deleteMail" object:nil];
}

-(void) ProcessMail:(NSArray *)mail_args
{		
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
	ParamsStorage *ps = (ParamsStorage*)[wnd storage];
	
	if(ps.mailItems==nil)
		ps.mailItems = [[NSMutableArray alloc] init];
	
	if(date_format==nil)
	{
		date_format = [[NSDateFormatter alloc] init];
		[date_format setDateFormat:@"dd.MM.yyyy HH:mm"];
	}
    //TODO: parse the email (mail_args) using your protocol
	int ctime = 0;
	int sender_login = 0;
	NSString *from = @"from";
	NSString *subject = @"subject";
	NSString *text = @"text";
	
	NSLog(@"FROM: %@, SUBJECT: %@, TEXT: %@", from, subject, text);
	
	int gmt_delta = [[NSTimeZone localTimeZone] secondsFromGMT];
	
	
	MailItem* mail_item = [[MailItem alloc] init];
	mail_item.isRead = false;
	mail_item.sender_login = sender_login;
	NSDate *dt_news = [[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)ctime] addTimeInterval:(NSTimeInterval)-gmt_delta];
	mail_item.date = [date_format stringFromDate:dt_news];
	mail_item.sender = [[NSString alloc] initWithData:[Base64 decode:from] encoding:[ClientParams emailSubjectEncoding]];
	mail_item.subject= [[NSString alloc] initWithData:[Base64 decode:subject] encoding:[ClientParams emailSubjectEncoding]];
	mail_item.text= [[NSString alloc] initWithData:[Base64 decode:text] encoding:[ClientParams emailEncoding]];
	mail_item.data = [Base64 decode:text];
    
	if (mail_item.text == nil)
	{
		NSData *data = [Base64 decode:text];
		char temp[102400]={0};
		[data getBytes:temp];
		
		CP1251Decoder* decoder = [[CP1251Decoder alloc] init];
		mail_item.text = [decoder decode:temp andLength:[data length]];
		[decoder release];
	}	
	
	[mail_item autorelease];
	while([ps.mailItems count]>20)
		[ps.mailItems removeObjectAtIndex:[ps.mailItems count]-1];

	[ps.mailItems insertObject:mail_item atIndex:0];
	[ps SaveSettings];
	[self.tableView reloadData];


	return;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
	ParamsStorage *ps = (ParamsStorage*)[wnd storage];
	return [ps.mailItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
	ParamsStorage *ps = (ParamsStorage*)[wnd storage];
	
	static NSString *CellIdentifier = @"MailListCell";
	
	MailListCell *cell = (MailListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) 
	{
		//cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"MailListCell" 
									owner:nil 
									options:nil];
		
		for(id currentObject in topLevelObjects) 
		{
			if([currentObject isKindOfClass:[UITableViewCell class]])
			{
				cell = (MailListCell *)currentObject;
				break;
			}
		}
	}
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	MailItem *news_item = (MailItem*)[ps.mailItems objectAtIndex: storyIndex];
	cell.lblSubject.text =  news_item.subject; 
	cell.lblFrom.text =  news_item.sender;
	cell.lblDate.text = news_item.date;	
	
	UIImage* icon;
	if(news_item.isRead)
	{
		icon = rowIconRead;
	}
	else
	{
		icon = rowIconUnread;	
	}
	cell.imgIcon.image = icon;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Set up the cell
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	if((storyIndex%2)==0)  		
		cell.backgroundColor = [UIColor colorWithRed: 241.0/255.0 green: 244.0/255.0 blue: 247.0/255.0 alpha: 1];
	else
		cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Navigation logic
	
	iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
	ParamsStorage *ps = (ParamsStorage*)[wnd storage];
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	MailItem *mail_item = (MailItem*)[ps.mailItems objectAtIndex: storyIndex];
	mail_item.isRead = true;
	
	MailView *viewDlg = [[MailView alloc] initWithNibName:@"MailView" bundle:nil];	
	[self.navigationController pushViewController:viewDlg animated:YES];
    if(mail_item.data != nil)
    {
        [viewDlg showMailData:mail_item.data withIndex:storyIndex];
    }
    else
    {
        [viewDlg showMailBody:mail_item.text withIndex:storyIndex];
    }
	
	//NSLog(@"text: %@", mail_item.text);
	
	[viewDlg autorelease];
	
	[ps SaveSettings];

	[self.tableView reloadData];
	
	/*NSLog(@"----");
	NSLog(@"Mail Sender: %@", mail_item.sender);
	NSLog(@"Mail Sender login: %@", mail_item.sender_login);
	NSLog(@"Mail Subject: %@", mail_item.subject);
	NSLog(@"Mail Body: %@", mail_item.text);*/
	
}
-(void) rebind
{
	[self.tableView reloadData];
} 

- (void)deleteMail:(NSNotification *)notification
{
    NSNumber *mailIndexToDelete = [notification object];
    if ([mailIndexToDelete integerValue] > -1)
    {
        iTraderAppDelegate* wnd = (iTraderAppDelegate*)[[UIApplication sharedApplication] delegate];
        ParamsStorage *ps = (ParamsStorage*)[wnd storage];
        [ps.mailItems removeObjectAtIndex:[mailIndexToDelete integerValue]];
        [ps SaveSettings];
        [self rebind];
    }
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
} 






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	
	
	[super dealloc];
}

@end

