
#import "GridControler.h"
#import "Grid.h"

@implementation GridViewController
@synthesize grid_view;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self.view setAutoresizesSubviews:YES];
	grid_view.delegate = self;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//[grid_view addSubview:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg.png"]] autorelease]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[grid_view RecalcScroll:false];
	[grid_view setNeedsDisplay];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	self.grid_view.contentView.transform = CGAffineTransformMakeScale(1, 1);
	return self.grid_view.contentView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if ([touches count] == 1 && [[touches anyObject] tapCount] == 2)
	{	
		//lastScale = 0.1;
		//[self RecalcScroll];
		//[self setNeedsDisplay];
		//[self scrollViewDidEndZooming:self withView:nil atScale:1];
		//[parent presentModalViewController:self animated:YES];
		//	TradeProgress *edit = [[TradeProgress alloc] initWithNibName:@"TradeProgress" bundle:nil];
		/* setup add or edit specific control values */
		//[self presentModalViewController:edit animated:YES];
		return;
	}
	[super touchesBegan:touches withEvent:event];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.grid_view setNeedsDisplay];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
