#import "PFScriptsViewController.h"

#import "PFScriptsServerInfo.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFScriptsViewController

@synthesize scriptsView;
@synthesize loadingIndicator;

-(void)dealloc
{
   self.scriptsView.delegate = nil;
   self.scriptsView = nil;
   self.loadingIndicator = nil;
}

-(id)init
{
   self = [ super init ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"SCRIPTS", nil );
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   PFScriptsServerInfo* server_info_ = [ PFScriptsServerInfo new ];

   NSURLRequest* scripts_request_ = [ NSURLRequest requestWithURL: [ server_info_ scriptsURLForSession: [ PFSession sharedSession ] ] ];

   [ self.scriptsView loadRequest: scripts_request_ ];

   [ self.loadingIndicator startAnimating ];
}

+(BOOL)isAvailable
{
   PFScriptsServerInfo* server_info_ = [ PFScriptsServerInfo new ];
   return server_info_ != nil;
}

#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:( UIWebView* )web_view_
{
   [ self.loadingIndicator stopAnimating ];
}

-(void)webView:( UIWebView* )web_view_ didFailLoadWithError:( NSError* )error_
{
   [ self.loadingIndicator stopAnimating ];
}

@end
