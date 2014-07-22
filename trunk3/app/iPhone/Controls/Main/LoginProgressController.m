#import "LoginProgressController.h"

#import "../XColoredProgress.h"

@interface LoginProgressController ()

@property ( nonatomic, assign ) NSUInteger stepIndex;

@end

@implementation LoginProgressController
@synthesize isCanceled;

@synthesize MainWnd = _MainWnd;
@synthesize lblStatus = _lblStatus;
@synthesize btnCancel = _btnCancel;
@synthesize pbProgress = _pbProgress;
@synthesize logo = _logo;
@synthesize bg = _bg;

@synthesize stepIndex;
@synthesize stepsCount;

- (void)dealloc 
{
   [_MainWnd release];
	[_lblStatus release];
	[_btnCancel release];
	[_pbProgress release];
	[_logo release];
	[_bg release];

    [super dealloc];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)stepCompletedWithDescription:( NSString* )description_
{
   self.stepIndex++;

	NSString * msgText = [ description_ stringByAppendingFormat: @" (%d/%d)", self.stepIndex, self.stepsCount ];
	self.lblStatus.text = msgText;

	self.pbProgress.progress = (double)self.stepIndex/self.stepsCount;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
   [super viewDidLoad];

	[self.btnCancel setTitle:NSLocalizedString(@"OPTIONS_CANCEL", nil) forState:UIControlStateNormal];
	[self.btnCancel setTitle:NSLocalizedString(@"OPTIONS_CANCEL", nil) forState:UIControlStateHighlighted];

	[self.pbProgress setTintColor:HEXCOLOR(0xff0000FF)];	
}  

-(void)viewDidUnload
{
   [ super viewDidUnload ];
   
   self.MainWnd = nil;
   self.lblStatus = nil;
   self.btnCancel = nil;
   self.pbProgress = nil;
   self.logo = nil;
   self.bg = nil;
}

- (IBAction) btnCancel_Clicked:(id)sender
{
	isCanceled = YES;
	if(self.stepIndex>2)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCanceled" object:nil];	
}

-(void)reset
{
   self.stepIndex = 0;
}

@end
