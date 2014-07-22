#import "PFNewsBrowserViewController.h"

#import "PFStoryHTMLFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <JFFMessageBox/JFFMessageBox.h>

@interface PFNewsBrowserViewController ()< PFSessionDelegate >

@property ( nonatomic, strong ) id< PFStory > story;

@end

@implementation PFNewsBrowserViewController

@synthesize nextButton;
@synthesize previousButton;
@synthesize refreshButton;
@synthesize loadingView;
@synthesize browserView;

@synthesize story;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];

   self.browserView.delegate = nil;
}

-(id)initWithStory:( id< PFStory > )story_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   if (self)
   {
      self.title = NSLocalizedString( @"NEWS_BROWSER", nil );
      self.story = story_;
   }
   return self;
}

-(void)loadStory:( id< PFStory > )story_
{
   self.story = story_;

   [ self updateNavigation ];

   self.refreshButton.enabled = NO;
   self.browserView.hidden = YES;

   [ story_ detailsWithDoneBlock: ^( id< PFStoryDetails > details_, NSError* error_ )
    {
       if ( self.story != story_ )
          return;

       if ( error_ )
       {
          [ error_ showAlertWithTitle: nil ];
       }
       else if ( [ details_.contentLines count ] > 0 )
       {
          [ self.browserView loadHTMLString: [ [ PFStoryHTMLFormatter new ] toHTMLStory: self.story ] baseURL: nil ];
       }
       else
       {
          self.refreshButton.enabled = YES;
          self.browserView.hidden = NO;
          [ self.browserView loadRequest: [ NSURLRequest requestWithURL: self.story.url ] ];
       }
    }];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ [ PFSession sharedSession ] addDelegate: self ];
   
   [ self loadStory: self.story ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateNavigation
{
   id< PFStories > stories_ = [ PFSession sharedSession ].stories;
   NSUInteger index_ = [ stories_ indexOfStory: self.story ];
   self.previousButton.enabled = index_ > 0;
   self.nextButton.enabled = index_ < [ stories_ count ] - 1;
}

-(IBAction)nextAction:( id )sender_
{
   id< PFStories > stories_ = [ PFSession sharedSession ].stories;
   NSUInteger index_ = [ stories_ indexOfStory: self.story ];
   [ self loadStory: [ stories_.stories objectAtIndex: index_ + 1 ] ];
}

-(IBAction)previousAction:( id )sender_
{
   id< PFStories > stories_ = [ PFSession sharedSession ].stories;
   NSUInteger index_ = [ stories_ indexOfStory: self.story ];
   [ self loadStory: [ stories_.stories objectAtIndex: index_ - 1 ] ];
}

-(IBAction)refreshAction:( id )sender_
{
   [ self.browserView reload ];
}

#pragma mark UIWebViewDelegate

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

#pragma mark PFSessionDelegate

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories
{
   [ self updateNavigation ];
}

@end
