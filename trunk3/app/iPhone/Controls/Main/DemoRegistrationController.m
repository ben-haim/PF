
#import "DemoRegistrationController.h"
#import "MySingleton.h"
#import "ClientParams.h"
#import "iTraderAppDelegate.h"

#import "PFServerConnectionDelegate.h"

@interface DemoRegistrationController()< PFServerConnectionDelegate >

@end

@implementation DemoRegistrationController
@synthesize storage, btnServer, registrationMessage, background, login, password, investors, serverName;

- (void) viewDidLoad
{
	[super viewDidLoad];
	[self setTitle:NSLocalizedString(@"DEMO_TITLE", nil)];
    
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil)
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(cancel:)];
   

	[[self navigationItem] setLeftBarButtonItem:backButton];
	[backButton release];

	[registrationMessage setText:[[NSString alloc] initWithFormat:@"%@ (%@)", NSLocalizedString(@"DEMO_MESSAGE", nil), NSLocalizedString(@"DEMO_MANDATORY", nil)]];
	[registrationMessage setTextColor:[ClientParams demoMsgFontColor]];
	
	[btnServer setTitle:[[NSString alloc] initWithFormat:@"%@*", NSLocalizedString(@"DEMO_SERVER", nil)] forState:UIControlStateNormal];
	[btnServer setTitle:[[NSString alloc] initWithFormat:@"%@*", NSLocalizedString(@"DEMO_SERVER", nil)] forState:UIControlStateHighlighted];
   
    
    self.tabBarController.moreNavigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	self.navigationController.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];

     
	[background setImage:[ClientParams demoBackground]];
	
	serverURL = @"";
	login = @"";
	password = @"";
	investors = @"";
	serverName = @"";
	
		
	//registration vars
	wasConnected = NO;
	[self RegisterNotifications];
	
	[self registerForKeyboardNotifications];
	
	//setup form
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:999];
	CGFloat topPadding = 10;
	CGFloat height = 100;
	CGRect frame = [btnServer frame];
	height += frame.size.height;
	const NSArray * regFields = [[storage clientSettings] regFields];
	
	UITextField *textField;
	UIButton *buttonField;
	UIImage *buttonBackground;
	UIImage *buttonBackgroundPressed;
	for(id regField in regFields)
	{
		RegField * rf = regField;
		if(rf.status != FIELD_STATUS_INVISIBLE)
		{
			switch (rf.type) 
			{
				case FIELD_TYPE_TEXT:
					
					textField = [self textfieldWithTitle:[rf getFieldLabel]
												   frame:CGRectMake(frame.origin.x , frame.origin.y + frame.size.height + topPadding , frame.size.width, frame.size.height) 								
											  background:[UIImage imageNamed:@"login_edit_bg.png"]
												keyboard:[rf getKeyboardType]];
					[rf setFieldView:textField];
					frame = [textField frame];
					[scrollView addSubview: textField];
					[textField release];
					height += frame.size.height+topPadding;
					break;
				case FIELD_TYPE_SELECT:
					buttonBackground = [UIImage imageNamed:@"login_edit_bg.png"];
					buttonBackgroundPressed = [UIImage imageNamed:@"login_edit_bg.png"];
					buttonField = [self selectWithTitle:[rf getFieldLabel]
												 target:self
											   selector:@selector(showDropDownFor:)
												  frame:CGRectMake(frame.origin.x , frame.origin.y + frame.size.height + topPadding , frame.size.width, frame.size.height)
												  image:buttonBackground
										   imagePressed:buttonBackgroundPressed
										  darkTextColor:YES
													tag:rf.fieldId];
					[rf setFieldView:buttonField];
					frame = [buttonField frame];
					//[[self view] addSubview: buttonField];
					[buttonField release];
					height += frame.size.height+topPadding;
					break;
				default:
					break;
			}	
		}
	}
	
	 buttonBackground = [UIImage imageNamed:@"btn_login.png"];
	 buttonBackgroundPressed = [UIImage imageNamed:@"btn_login_down.png"];
	 btnRegister = [self buttonWithTitle:NSLocalizedString(@"DEMO_REGISTER", nil)
								target:self
								selector:@selector(initRegistration)
								 frame:CGRectMake(frame.origin.x , frame.origin.y + frame.size.height + topPadding , frame.size.width, frame.size.height + 5.0)
								 image:buttonBackground
						  imagePressed:buttonBackgroundPressed
						 darkTextColor:NO
								   tag:REG_FIELD_TOTAL];
	 
	[scrollView addSubview: btnRegister];
	frame = [btnRegister frame];
	height += frame.size.height;
	
	
	scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, height);
	[scrollView flashScrollIndicators];
}

-(IBAction) cancel:(id)sender
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"demoDlgClosed" object:self];
}

- (void)rowChosen:(NSInteger)row
{
	//[self dismissModalViewControllerAnimated:YES]; 
	[self.navigationController popViewControllerAnimated:YES];
	if ([openDropDown isEqual:btnServer]) 
	{
		ServerInfo *si = [[self demoServersFromServers:storage.Servers] objectAtIndex: row];
		serverURL = [si base_url];
		[btnServer setTitle: [si description] forState:UIControlStateNormal];
		//[btnServer setSelectedIndex:row];
		[self filterGroupsForServer:si];
	}
	else 
	{
		RegField *regField = [self getRegFieldWithView:openDropDown];
		if (regField != nil)
		{
			NSArray *values = [regField getValues];
			NSString *value = [NSString stringWithFormat:@"%@", [values objectAtIndex:row]];
			[((DropDown *)openDropDown) setTitle:value forState:UIControlStateNormal];
			
			//[values release];
		}
	}
	[((DropDown *)openDropDown) setSelectedIndex:row];
	[((UIButton *)openDropDown) setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)filterGroupsForServer:(ServerInfo *) serverInfo
{
	[[self getRegFieldWithId:REG_FIELD_GROUP] setFilter: [serverInfo alias]];
	[[self getRegFieldWithId:REG_FIELD_LEVERAGE] setFilter: [serverInfo alias]];
}

- (RegField *) getRegFieldWithId:(RegFields)fieldId
{
	const NSArray * regFields = [[storage clientSettings] regFields];
	for(RegField *regField in regFields)
	{
		if (regField.fieldId==fieldId) 
		{
			return regField;
		}
	}
	return nil;
}

- (NSString *) getRegFieldValueWithId:(RegFields)fieldId
{
	RegField *field = [self getRegFieldWithId:fieldId];
	if (field != nil) 
	{
		return [field getValue];
	}
	else 
	{
		return @"";
	}

}

- (RegField *) getRegFieldWithView:(UIView *)fieldView
{
	const NSArray * regFields = [[storage clientSettings] regFields];
	for(RegField *regField in regFields)
	{
		if ([regField.fieldView isEqual:fieldView]) 
		{
			return regField;
		}
	}
	return nil;
}

-(RegField *) getNextRegFieldWithView:(UIView *)fieldView
{
	const NSArray * regFields = [[storage clientSettings] regFields];
	BOOL fieldFound = NO;
	for(RegField *regField in regFields)
	{
		if (fieldFound)
		{
			return regField;
		}
		if ([regField.fieldView isEqual:fieldView]) 
		{
			
			fieldFound = YES;
		}
	}
	return nil;
}

- (IBAction) showDropDownFor:(id)sender
{
	const NSArray * regFields = [[storage clientSettings] regFields];

	for (int i=0; i<[regFields count]; i++)
	{
      RegField* reg_field_ = [regFields objectAtIndex:i];
		if ( [ reg_field_ type ] == FIELD_TYPE_TEXT )
		{
			[ reg_field_ focusOut ];
		}
	}

	openDropDown = sender;
	SelectionListViewController *controller = [[SelectionListViewController alloc] init];
	controller.delegate = self;
	RegField * rf = [self getRegFieldWithId:[sender tag]];
	controller.list = [rf getValues];
	controller.initialSelection = [((DropDown *)[rf fieldView]) selectedIndex];
	//[self presentModalViewController:controller animated:YES];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (IBAction) btnServer_Clicked:(id)sender
{
	openDropDown = btnServer;
	SelectionListViewController *controller = [[SelectionListViewController alloc] init];
	controller.delegate = self;
	controller.list = [self demoServersFromServers:storage.Servers];
	controller.initialSelection = [btnServer selectedIndex];
	//[self presentModalViewController:controller animated:YES];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (NSArray *)demoServersFromServers:(NSArray *)servers
{
	NSMutableArray *demoServers = [[NSMutableArray alloc] init];
	for(ServerInfo *server in servers)
	{
		if (server.demo)
		{
			[demoServers addObject:server];
		}
	}
	return [demoServers autorelease];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc 
{
	
    [super dealloc];
}

 - (UIButton *)buttonWithTitle:(NSString *)title
						target:(id)target
					  selector:(SEL)selector
						 frame:(CGRect)frame
						 image:(UIImage *)image
				  imagePressed:(UIImage *)imagePressed
				 darkTextColor:(BOOL)darkTextColor
						   tag:(RegFields)tag
 {
	 UIButton *button = [[UIButton alloc] initWithFrame:frame];
	 
	 button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	 button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	 
 	 [[button titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0]];
	 [button setTitle:title forState:UIControlStateNormal];
	 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	 [[button titleLabel] setShadowColor:[UIColor blackColor]];
	 [[button titleLabel] setShadowOffset:CGSizeMake(0.0, -1.0)];
	 
	 
	 UIImage *newImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	 [button setBackgroundImage:newImage forState:UIControlStateNormal];
	 
	 UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	 [button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	 
	 [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	 
	 // in case the parent view draws with a custom color or gradient, use a transparent color
	 button.backgroundColor = [UIColor clearColor];
	 
	 [button setTag:tag];
	 return button;
 }

- (UITextField *)textfieldWithTitle:(NSString *)title
                              frame:(CGRect)frame
                         background:(UIImage *)background_
                           keyboard:(UIKeyboardType)inputType
{
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	[textField setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	[textField setPlaceholder:title];
	[textField setBackground:background_];
	
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
	textField.leftView = paddingView;
	textField.leftViewMode = UITextFieldViewModeAlways;
	[textField setKeyboardType:inputType];
	[paddingView release];
	
	[textField setReturnKeyType:UIReturnKeyDone];
	[textField setDelegate:self];
	
	if (inputType == UIKeyboardTypeEmailAddress)
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	
	return textField;
}

- (DropDown *)selectWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
						  tag:(RegFields)tag
{
	DropDown *button = [[DropDown alloc] initWithFrame:frame];
	
	[button setContentEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	[[button titleLabel] setFont:[UIFont fontWithName:@"Helvetica" size:18.0]];
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	[button setTag:tag];
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:999];
	[scrollView addSubview:button];
	
	//add the arrow
	UIButton *arrow = [[UIButton alloc] initWithFrame:CGRectMake(frame.origin.x + frame.size.width - 30, frame.origin.y + 15, 20, 20)];
	arrow.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	arrow.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	
	[arrow setImage:[UIImage imageNamed:@"arrow_server.png"] forState:UIControlStateNormal];
	[arrow setImage:[UIImage imageNamed:@"arrow_server.png"] forState:UIControlStateHighlighted];	
	
	//[arrow addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	[scrollView addSubview:arrow];
	[arrow release];
	
	return button;
}

		 
 - (BOOL)textFieldShouldReturn:(UITextField*)aTextBox
{
	[aTextBox resignFirstResponder];
	RegField *nextField = [self getNextRegFieldWithView:aTextBox];
	if (nextField != nil)
	{
		[[nextField fieldView] becomeFirstResponder];
	}
	
	return YES;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
	
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:999];
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
	
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = scrollView.frame;
    aRect.size.height -= kbSize.height;
	CGPoint fieldOrigin =  activeField.frame.origin;
	fieldOrigin.y += 85;
    //if (!CGRectContainsPoint(aRect, fieldOrigin) ) 
	//{
        CGPoint scrollPoint = CGPointMake(0.0, fieldOrigin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    //}
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:999];
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (BOOL)validateFields
{
	BOOL allFieldsOK = YES;
	if ([serverURL length] == 0) 
	{
		allFieldsOK = NO;
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_VALIDATION_ERROR", nil)
														message:NSLocalizedString(@"DEMO_SELECT_SERVER", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
		return allFieldsOK;
	}
	const NSArray * regFields = [[storage clientSettings] regFields];
	for(RegField *regField in regFields)
	{
		int fieldValidation = [regField hasValidValue];
		if (fieldValidation > 0) 
		{
			allFieldsOK = NO;
			CustomAlert *alert = nil;
			//field is empty
			if (fieldValidation == 1)
			{
				[[regField fieldView] becomeFirstResponder];
				alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_VALIDATION_ERROR", nil)
																message: [[NSString alloc] initWithFormat:@"%@: \"%@\"", NSLocalizedString(@"DEMO_MANDATORY_FIELD", nil), [regField name] ]
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"OK", nil)
													  otherButtonTitles: nil];
			}
			//invalid value
			else if (fieldValidation == 2)
			{
				[[regField fieldView] becomeFirstResponder];
				alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_VALIDATION_ERROR", nil)
																message:[[NSString alloc] initWithFormat:@"%@: \"%@\"", NSLocalizedString(@"DEMO_INVALID_VALUE", nil), [regField name] ]
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"OK", nil)
													  otherButtonTitles: nil];
			}
			//else if (fieldValidation == 3)
//			{
//				alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_VALIDATION_ERROR", nil)
//																message:[[NSString alloc] initWithFormat:@"%@ %@", NSLocalizedString(@"DEMO_SELECT_VALUE", nil), [regField name] ]  
//															   delegate:self
//										 cancelButtonTitle:NSLocalizedString(@"OK", nil)
//													  otherButtonTitles: nil];
//			}
			[alert show];
			[alert release];
			break;
		}
	}
	return allFieldsOK;
}
//registration procedure
-(void)RegisterNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverResolved:)
												 name:@"serverResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverDidntResolve:)
												 name:@"serverDidntResolve" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tokenResolved:)
												 name:@"tokenResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tokenDidntResolve:)
												 name:@"tokenDidntResolve" object:nil];
	
/*	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsResolved:)
												 name:@"settingsResolved" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(settingsDidntResolve:)
												 name:@"settingsDidntResolve" object:nil];	*/
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverConnected:)
												 name:@"serverConnected" object:nil];		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverDisconnected:)
												 name:@"DisconnectWithError" object:nil];			
}

- (void) initRegistration
{	
    [serverConn Disconnect];
	
	iTraderAppDelegate *appDelegate = (iTraderAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([appDelegate notificationsRegistered])
	{
		[appDelegate UnRegisterNotification];
	}
	
	if (![self validateFields])
	{
		return;
	}
	shouldStopConnecting = NO;
	wasConnected = NO;
	if(gsServer!=nil)
	{
		[gsServer dealloc];
		gsServer = nil;
	}	
	
	if(gsToken!=nil)
	{
		[gsToken dealloc];
		gsToken = nil;
	}
	if (serverConn!=nil) 
	{
		//[serverConn Disconnect];
		[serverConn release];
		serverConn = nil;
	}
	serverConn = [[ServerConnection alloc] init];
	serverConn.delegate = self;
	
	[serverConn Disconnect];
	
	gsServer = [GetServer alloc];	
	
	registrationDialog = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_PROCESSING", nil)
													message:NSLocalizedString(@"PROGRESS_SEARCH_SERVER", nil)
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OPTIONS_CANCEL", nil)
										  otherButtonTitles: nil];
	[registrationDialog show];
	[gsServer initConnection:self withUrl:serverURL];
}


- (void)serverDidntResolve:(NSNotification *)notification
{
	[gsServer release];
	gsServer = nil;
	if ([registrationDialog isVisible]) 
	{
		[registrationDialog dismissWithClickedButtonIndex:[registrationDialog cancelButtonIndex] animated:NO];
		[registrationDialog release];
	}
	CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
													message:NSLocalizedString(@"PROGRESS_FAILED_TO_CONNECT", nil)
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", nil)
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)serverResolved:(NSNotification *)notification
{
	
	[gsServer release];
	gsServer = nil; 
	if(shouldStopConnecting)
	{
		[serverConn Disconnect];
		return;
	}
	
	if(serverHost!=nil)
	{
		[serverHost release];  
		serverHost = nil;
	}
    //TODO: you will need to handle the serverInfo if you have implemented the GetServer.m
	NSString *serverInfo = [notification object];
	if([serverInfo isEqualToString:@"none"])
	{
		if ([registrationDialog isVisible]) 
		{
			[registrationDialog dismissWithClickedButtonIndex:[registrationDialog cancelButtonIndex] animated:NO];
			[registrationDialog release];
		}
		CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
														message:NSLocalizedString(@"PROGRESS_FAILED_TO_CONNECT", nil) 
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"OK", nil)
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	
		return;
	}
	
	NSString *serverAddress = serverInfo;	
	
	NSArray *serverArgs = [serverAddress componentsSeparatedByString:@":"];	
	[serverAddress autorelease];
	if(serverArgs.count!=2)
	{	
		return;
	}
	
	serverHost = [[NSString alloc] initWithFormat:@"%@", [serverArgs objectAtIndex:0]];
	serverPort = [[serverArgs objectAtIndex:1] integerValue];
    NSLog(@"IP_connect: %@, %d", serverHost, serverPort);
	gsToken = [GetToken alloc];

	if (![registrationDialog isVisible]) 
	{
		[registrationDialog show];
	}
	[registrationDialog setMessage:NSLocalizedString(@"PROGRESS_SECURING_SESSION", nil)];	
	
	[gsToken initConnection:self withUrl:serverURL];
}

- (void)tokenDidntResolve:(NSNotification *)notification
{
	[gsToken release];
	gsToken = nil;
	if ([registrationDialog isVisible]) 
	{
		[registrationDialog dismissWithClickedButtonIndex:[registrationDialog cancelButtonIndex] animated:NO];
		[registrationDialog release];
	}
	CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
													message:NSLocalizedString(@"PROGRESS_FAILED_TO_CONNECT", nil) 
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"OK", nil)
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)tokenResolved:(NSNotification *)notification
{
	[gsToken release];
	gsToken = nil;
	if(shouldStopConnecting)
	{
		[serverConn Disconnect];
		return;
	}
	//TODO: you need to handle the token if have implemented the GetToken.m
	NSString *token = [notification object];
	char binChars[32];
	
	const char *tokenChars = [token UTF8String];
	const char *nextTokenChar = tokenChars;
	char *nextChar = binChars;
	for (NSUInteger i = 0; i < 32; i++)
	{
		unsigned int v;
		sscanf(nextTokenChar, "%2x", &v);
		*nextChar = (char)v;
		nextTokenChar += 2;
		nextChar++;
	}
	[serverConn.codec initWith:binChars];
	
	if (![registrationDialog isVisible]) 
	{
		[registrationDialog show];
	}
	[registrationDialog setMessage:NSLocalizedString(@"PROGRESS_CONNECT_SERVER", nil)];	
	
	[serverConn ConnectHost:serverHost AndPort:(UInt16)serverPort];
}

- (void)serverConnected:(NSNotification *)notification
{
	if(shouldStopConnecting)
	{
		[serverConn Disconnect];
		return;
	}
	
	if (![registrationDialog isVisible]) 
	{
		[registrationDialog show];
	}
	[registrationDialog setMessage:NSLocalizedString(@"DEMO_SENDING_DATA", nil)];	
	
	[serverConn SendDemoAccountRequestWithName:[self getRegFieldValueWithId:REG_FIELD_NAME]
									 withGroup:[self getRegFieldValueWithId:REG_FIELD_GROUP]
								   withCountry:[self getRegFieldValueWithId:REG_FIELD_COUNTRY]
									 withState:[self getRegFieldValueWithId:REG_FIELD_STATE]
									  withCity:[self getRegFieldValueWithId:REG_FIELD_CITY]
								   withZipcode:[self getRegFieldValueWithId:REG_FIELD_ZIPCODE]
								   withAddress:[self getRegFieldValueWithId:REG_FIELD_ADDRESS]
									 withPhone:[self getRegFieldValueWithId:REG_FIELD_PHONE]
									 withEmail:[self getRegFieldValueWithId:REG_FIELD_EMAIL]
								  withLeverage:[self getRegFieldValueWithId:REG_FIELD_LEVERAGE] 
								   withDeposit:[self getRegFieldValueWithId:REG_FIELD_DEPOSIT]];
}

- (void)serverDisconnected:(NSNotification *)notification
{
	if(shouldStopConnecting)
	{
		[serverConn Disconnect];
		return;
	}
	if ([registrationDialog isVisible]) 
	{
		[registrationDialog dismissWithClickedButtonIndex:[registrationDialog cancelButtonIndex] animated:NO];
		[registrationDialog release];
	}
	CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"ERROR", nil)
													message:NSLocalizedString(@"PROGRESS_FAILED_TO_CONNECT", nil) 
												   delegate:self
										  cancelButtonTitle:NSLocalizedString(@"OK", nil)
										  otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void)serverConnection:( ServerConnection* )connection_
      didReceiveMessage:( PFMessage* )message_
{
   
}

- (void)dataReceived:(NSArray *)cmdArgs
{
    //TODO: changeMe should be change with cmdArgs, changeMe is not the same everywhere in the code
    int changeMe = 0;
    //TODO: change demo, success with your protocol responses
	NSString *cmd = [cmdArgs objectAtIndex:changeMe];
	if([cmd compare:@"demo"]==0)
	{
		NSString* arg = [cmdArgs objectAtIndex:changeMe];
		if([arg compare:@"success"]==0)//successful
		{
			[self disconnectServers];
			login = [[cmdArgs objectAtIndex:changeMe] copy];
			password = [[cmdArgs objectAtIndex:changeMe] copy];
			investors = [[cmdArgs objectAtIndex:changeMe] copy];
			serverName = [[btnServer titleLabel] text];
			
			if ([registrationDialog isVisible]) 
			{
				[registrationDialog dismissWithClickedButtonIndex:[registrationDialog cancelButtonIndex] animated:NO];
				[registrationDialog release];
			}
			demoDialog = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"DEMO_REGISTRATION_SUCCESS", nil)
													message:[[NSString alloc] 
															 initWithFormat: @"%@\n%@ %@\n%@ %@\n%@ %@", NSLocalizedString(@"DEMO_SUCCESS_MSG", nil), NSLocalizedString(@"DEMO_SUCCESS_USERNAME", nil), login, NSLocalizedString(@"DEMO_SUCCESS_PASSWORD", nil), password, NSLocalizedString(@"DEMO_SUCCESS_INVESTOR", nil), investors]
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", nil)
										  otherButtonTitles: nil];
			[demoDialog show];
			[demoDialog release];
		} 
	}
}

- (void)disconnectServers
{
	if(gsServer!=nil)
	{
		[gsServer dealloc];
		gsServer = nil;
	}	
	
	if(gsToken!=nil)
	{
		[gsToken dealloc];
		gsToken = nil;
	}
	if (serverConn!=nil) 
	{
		[serverConn Disconnect];
		[serverConn release];
		serverConn = nil;
	}	
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView isEqual:demoDialog]) 
	{
		[self cancel:self];
	}
	else if([alertView isEqual:registrationDialog])
	{
		shouldStopConnecting = YES;
	}
}

@end
