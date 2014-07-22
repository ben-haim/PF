#import "PFEventBrowserViewController.h"

#import "PFEventHTMLFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFEventBrowserViewController () < PFSessionDelegate >

@property ( nonatomic, strong ) id< PFReportTable > report;

@end

@implementation PFEventBrowserViewController

@synthesize nextButton;
@synthesize previousButton;
@synthesize loadingView;
@synthesize browserView;

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
   
   [ self loadReport: self.report ];
}

-(void)updateNavigation
{
   NSArray* events_ = [ PFSession sharedSession ].events;
   NSUInteger index_ = [ events_ indexOfObject: self.report ];
   self.previousButton.enabled = index_ > 0;
   self.nextButton.enabled = index_ < [ events_ count ] - 1;
}

-(IBAction)nextAction:( id )sender_
{
   NSArray* events_ = [ PFSession sharedSession ].events;
   NSUInteger index_ = [ events_ indexOfObject: self.report ];
   [ self loadReport: [ events_ objectAtIndex: index_ + 1 ] ];
}

-(IBAction)previousAction:( id )sender_
{
   NSArray* events_ = [ PFSession sharedSession ].events;
   NSUInteger index_ = [ events_ indexOfObject: self.report ];
   [ self loadReport: [ events_ objectAtIndex: index_ - 1 ] ];
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

@end
