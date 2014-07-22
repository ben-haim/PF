#import "PFEventBrowserViewController.h"
#import "PFEventHTMLFormatter.h"
#import "PFModalWindow.h"

#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFEventBrowserViewController () < PFSessionDelegate, UIGestureRecognizerDelegate >

@property ( nonatomic, strong ) id< PFReportTable > report;
@property ( nonatomic, assign ) BOOL allowsLeftSwipe;
@property ( nonatomic, assign ) BOOL allowsRightSwipe;

@end

@implementation PFEventBrowserViewController

@synthesize nextButton;
@synthesize previousButton;
@synthesize loadingView;
@synthesize browserView;
@synthesize allowsLeftSwipe;
@synthesize allowsRightSwipe;

@synthesize report;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
   self.browserView.delegate = nil;
}

-(id)initWithReport:( id< PFReportTable > )report_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"EVENT_BROWSER", nil );
      self.report = report_;
   }
   
   return self;
}

-(void)loadReport:( id< PFReportTable > )report_
{
   self.report = report_;
   
   [ self updateNavigation ];
   
   self.browserView.hidden = YES;
   
   [ self.browserView loadHTMLString: [ [ PFEventHTMLFormatter new ] toHTMLReport: self.report ] baseURL: nil ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];

   UISwipeGestureRecognizer* left_swipe_ = [ [ UISwipeGestureRecognizer alloc ] initWithTarget: self
                                                                                        action: @selector( swipeLeft ) ];
   left_swipe_.direction = UISwipeGestureRecognizerDirectionLeft;
   left_swipe_.delegate = self;

   UISwipeGestureRecognizer* right_swipe_ = [ [ UISwipeGestureRecognizer alloc ] initWithTarget: self
                                                                                         action: @selector( swipeRight ) ];
   right_swipe_.direction = UISwipeGestureRecognizerDirectionRight;
   right_swipe_.delegate = self;

   [ self.browserView addGestureRecognizer: left_swipe_ ];
   [ self.browserView addGestureRecognizer: right_swipe_ ];

   [ self loadReport: self.report ];
   self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [ UIColor backgroundDarkColor ] : [ UIColor backgroundLightColor ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setLightNavigationBar ];
   }
   else
   {
      [ self setDarkNavigationBar ];
   }

}

-(void)swipeLeft
{
   if ( self.allowsLeftSwipe )
   {
      NSArray* events_ = [ PFSession sharedSession ].events;
      NSUInteger index_ = [ events_ indexOfObject: self.report ];
      [ self loadReport: [ events_ objectAtIndex: index_ + 1 ] ];
   }
}

-(void)swipeRight
{
   if ( self.allowsRightSwipe )
   {
      NSArray* events_ = [ PFSession sharedSession ].events;
      NSUInteger index_ = [ events_ indexOfObject: self.report ];
      [ self loadReport: [ events_ objectAtIndex: index_ - 1 ] ];
   }
}

-(void)updateNavigation
{
   NSArray* events_ = [ PFSession sharedSession ].events;
   NSUInteger index_ = [ events_ indexOfObject: self.report ];
   self.allowsRightSwipe = index_ > 0;
   self.allowsLeftSwipe = index_ < [ events_ count ] - 1;
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
   [ self.loadingView startAnimating ];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   self.browserView.hidden = NO;
   [ self.loadingView stopAnimating ];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   self.browserView.hidden = NO;
   [ self.loadingView stopAnimating ];
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories
{
   [ self updateNavigation ];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:( UIGestureRecognizer* )gesture_recognizer_
shouldRecognizeSimultaneouslyWithGestureRecognizer:( UIGestureRecognizer* )other_gesture_recognizer_
{
   return YES;
}

@end
