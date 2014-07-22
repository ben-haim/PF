#import "PFNewsStoryViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFNewsStoryViewController ()

@property ( nonatomic, strong ) id< PFStory > story;

@end

@implementation PFNewsStoryViewController

@synthesize loadingView = _loadingView;
@synthesize webView = _webView;
@synthesize story = _story;

-(void)dealloc
{
   [ _loadingView release ];

   _webView.delegate = nil;
   [ _webView release ];

   [ _story release ];

   [ super dealloc ];
}

-(id)initWithStory:( id< PFStory > )story_
{
   self = [ super initWithNibName: @"PFNewsStoryViewController" bundle: nil ];

   if ( self )
   {
      self.title = story_.header;
      self.story = story_;
   }

   return self;
}

+(id)controllerWithStory:( id< PFStory > )story_
{
   return [ [ [ self alloc ] initWithStory: story_ ] autorelease ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.webView loadRequest: [ NSURLRequest requestWithURL: self.story.url ] ];
}

-(void)viewDidUnload
{
   self.loadingView = nil;

   self.webView.delegate = nil;
   self.webView = nil;

   [ super viewDidUnload ];
}

#pragma mark UIWebViewDelegate

-(void)webViewDidStartLoad:( UIWebView* )web_view_
{
   [ self.loadingView startAnimating ];
}

-(void)webViewDidFinishLoad:( UIWebView* )web_view_
{
   [ self.loadingView stopAnimating ];
}

-(void)webView:( UIWebView* )web_view_ didFailLoadWithError:( NSError* )error_
{
   [ self.loadingView stopAnimating ];
}

@end
