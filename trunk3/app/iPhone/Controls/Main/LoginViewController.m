
#import "LoginViewController.h"
#import "DemoWebController.h"
#import "SelectAccount.h"
#import "MySingleton.h"
#import "iTraderAppDelegate.h"
#import "ClientSettings.h"


@implementation LoginViewController
@synthesize login, password,storage, server, imgLogo, wobbleView;
@synthesize lblLogin, lblServer, lblPassword, btnOk, btnDemo, verNum, btnAccounts;

- (void)dealloc 
{
	[edtLogin dealloc];
	[edtPassword dealloc];
	[lblLogin dealloc];
	[lblServer dealloc];
	[lblPassword dealloc];
	[btnOk dealloc];
	[btnDemo dealloc];
	[verNum release];
	[btnAccounts release];
    [super dealloc]; 
}

- (IBAction) btnLogin_Clicked:(id)sender
{
	login = edtLogin.text;
	password = edtPassword.text;
	storage.login = login;
	storage.password = password;
	//storage.selected_server = edtServer.text;
	//edtLogin.text = [[NSString alloc] initWithFormat:@"%@ %@ credetials", login, pwd];

	/*[[[self view] window] performSelector:@selector(SwitchToProgressView:)
							   withObject:self
							   afterDelay:0.0];*/
	//[MainWnd login2main:self];
	id MainWnd = [[UIApplication sharedApplication] delegate];
	[MainWnd performSelector:@selector(any2progress:) withObject:self afterDelay:0.0];
}

- (IBAction) doneButton:(id)sender
{
	[self textFieldShouldReturn:edtLogin];
}


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }*/



/*// Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView 
 {
 }*/

-(void)HideAccountSelector
{
	if (storage.accounts == nil)
	{
		//[storage.accounts release];
		storage.accounts = [storage getSavedAccounts];
	}
	
	if ([storage.accounts count] == 0)
		btnAccounts.hidden = YES;
	else 
		btnAccounts.hidden = NO;	
}

-(void)viewWillAppear:(BOOL)animated
{
	[self HideAccountSelector];
	
	if (storage.clientSettings.demoRegistrationMode == DEMO_NONE)
	{
		[wobbleView removeFromSuperview];
	}
}

-(void)initialize
{
	lblLogin.text = NSLocalizedString(@"LOGIN_LOGIN", nil);
	lblPassword.text = NSLocalizedString(@"LOGIN_PASSWORD", nil);
	lblServer.text = NSLocalizedString(@"LOGIN_SERVER", nil);
	[btnOk setTitle:NSLocalizedString(@"LOGIN_BTN_LOGIN", nil) forState:UIControlStateNormal];
	[btnOk setTitle:NSLocalizedString(@"LOGIN_BTN_LOGIN", nil) forState:UIControlStateHighlighted];
	
	edtLogin.text = storage.login;
	edtPassword.text = storage.password;
	edtServer.text = storage.selected_server;
	
	verNum.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
	
	[self shakeButton];
	[self checkCredentials];
	
	[edtLogin addTarget:self action:@selector(checkCredentials) forControlEvents:UIControlEventAllEvents];
	[edtPassword addTarget:self action:@selector(checkCredentials) forControlEvents:UIControlEventAllEvents];
	[edtServer addTarget:self action:@selector(checkCredentials) forControlEvents:UIControlEventAllEvents];
	
}

- (void)demoWebDlgClosed:(NSNotification *)notification
{
	[self dismissModalViewControllerAnimated:YES];  
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	edtPassword.secureTextEntry = YES;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(serverDlgClosed:)
												 name:@"serverDlgClosed" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(accountDlgClosed:)
												 name:@"accountDlgClosed" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(demoDlgClosed:)
												 name:@"demoDlgClosed" object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(demoWebDlgClosed:)
												 name:@"demoWebDlgClosed" object:nil];
	
	[self initialize];
	
	//imgLogo.image = [UIImage imageNamed:@"logo.png"];

}

- (void)serverDlgClosed:(NSNotification *)notification
{
	[self dismissModalViewControllerAnimated:YES];  
	edtServer.text = [storage selected_server];
	
	storage.serverResult = nil;
	storage.tokkenResult = nil;
	
	[self checkCredentials];
}

- (void)accountDlgClosed:(NSNotification *)notification
{
	[self dismissModalViewControllerAnimated:YES];  
	edtServer.text = [storage selected_server];
	edtLogin.text = [storage login];
	edtPassword.text = [storage password];
	
	storage.serverResult = nil;
	storage.tokkenResult = nil;
	
	[self HideAccountSelector];
	[self checkCredentials];
}

- (void)demoDlgClosed:(NSNotification *)notification
{
	DemoRegistrationController *demoController = [notification object];
	if ([[demoController login] length] > 0 && [[demoController password] length] > 0)
	{
		[edtLogin setText:[demoController login]];
		[edtPassword setText:[demoController password]];
		[edtServer setText:[demoController serverName]];
		[storage setSelected_server:[demoController serverName]];
		
		storage.serverResult = nil;
		storage.tokkenResult = nil;
        
		[storage loadFavorites];
        
		[self checkCredentials];
	}
	[self dismissModalViewControllerAnimated:YES];  
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    // Return YES for supported orientations
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextBox
{
	[self shakeButton];
	
	[self checkCredentials];
	

	
	[aTextBox resignFirstResponder];
	//if (aTextBox == edtLogin)
	//	[edtPassword becomeFirstResponder];
	//else
	//if(aTextBox == edtPassword)
	//	[self btnLogin_Clicked:self];
    return YES;
}

- (IBAction) btnServer_Clicked:(id)sender
{
	SelectServer *serverDlg = [[SelectServer alloc] initWithNibName:@"SelectServer" bundle:nil];	
	
	[serverDlg SetServers:storage];
	[self presentModalViewController:serverDlg animated:YES];
	//[self dismissModalViewControllerAnimated:YES];
	[serverDlg release];	
}

- (IBAction) btnAccount_Clicked:(id)sender
{
	SelectAccount *accountDlg = [[SelectAccount alloc] initWithNibName:@"SelectAccount" bundle:nil];
	[accountDlg SetAccounts:storage];
	UINavigationController *navControll = [[UINavigationController alloc] initWithRootViewController:accountDlg];

	navControll.navigationBar.tintColor = [[MySingleton sharedMySingleton] tabColor];
	
	[accountDlg release];	
	
	[self presentModalViewController:navControll animated:YES];	
}

- (IBAction) btnDemo_Clicked:(id)sender
{
	if ([[storage clientSettings] demoRegistrationMode] == DEMO_FORM)
	{
		DemoRegistrationController *demoRegistration = [[DemoRegistrationController alloc] initWithNibName:@"DemoRegistration" bundle:nil];	
		demoRegistration.storage = self.storage;
		UINavigationController *navControll = [[UINavigationController alloc] initWithRootViewController:demoRegistration];
		
		[demoRegistration release];	
		
		[self presentModalViewController:navControll animated:YES];
	}
	else if ([[storage clientSettings] demoRegistrationMode] == DEMO_WEB)
	{
		DemoWebController *demoRegistration = [[DemoWebController alloc] init];	
		UINavigationController *navControll = [[UINavigationController alloc] initWithRootViewController:demoRegistration];
		[demoRegistration release];
		
		[self presentModalViewController:navControll animated:YES];	
		[navControll release];
		//[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.google.co.uk"]];
	}
	
	//UINavigationController *navControl = [self navigationController];
//	if (navControl != nil) 
//	{
//		[navControl pushViewController:demoRegistration animated:YES];
//	}
//	else 
//	{
//		//[[self view] addSubview:[demoRegistration view]];
//		[self presentModalViewController:demoRegistration animated:YES];
//	}
	
	
	
	
	//[[self view] addSubview:navControll.view];
	//[self.navigationController pushViewController:demoRegistration animated:YES];
	//[demoRegistration release];	
}

- (void)wobbleButton
{
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
	
	CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5.0));
	CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5.0));
	
	//[btnDemo view].transform = leftWobble;
	
	wobbleView.transform = leftWobble;  // starting point
	
	
	[UIView beginAnimations:@"wobble" context:wobbleView];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	[UIView setAnimationRepeatCount:FLT_MAX];
	
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
	
//	itemView.transform = rightWobble; // end here & auto-reverse
	
	wobbleView.transform = rightWobble;
	
	[UIView commitAnimations];
}

- (void)wobbleButtonStop
{
	CGAffineTransform centerWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
	
	//[btnDemo view].transform = leftWobble;

	[UIView beginAnimations:@"wobble" context:wobbleView];
	[UIView setAnimationRepeatAutoreverses:YES]; // important
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationRepeatCount:1];
	
	[UIView setAnimationDuration:0];
	[UIView setAnimationDelegate:self];
	
	wobbleView.transform = centerWobble;  
	
	[UIView commitAnimations];
	
}

- (void)shakeButton
{
	if (edtLogin == nil || edtLogin.text == nil)
		 [self wobbleButton];		
	else if (![edtLogin.text isEqualToString:@""])
		[self wobbleButtonStop];
	else 
		[self wobbleButton];
}

-(void) checkCredentials
{
	if (
		edtLogin == nil || edtLogin.text == nil ||
		edtPassword == nil || edtPassword.text == nil ||
		edtServer == nil || edtServer.text == nil ||
		[edtLogin.text isEqualToString:@""] || 
		[edtPassword.text isEqualToString:@""] || 
		[edtServer.text isEqualToString:@""]
		)
		[btnOk setEnabled:NO];
	else
		[btnOk setEnabled:YES];
}
	

@end
