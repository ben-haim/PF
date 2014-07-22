#import "PFNewsBrowserViewController.h"
#import "PFStoryHTMLFormatter.h"
#import "PFModalWindow.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFFMessageBox/JFFMessageBox.h>

@interface PFNewsBrowserViewController () < PFSessionDelegate, UIGestureRecognizerDelegate >

@property ( nonatomic, strong ) id< PFStory > story;
@property ( nonatomic, assign ) BOOL allowsLeftSwipe;
@property ( nonatomic, assign ) BOOL allowsRightSwipe;

@end

@implementation PFNewsBrowserViewController

@synthesize loadingView;
@synthesize browserView;
@synthesize allowsLeftSwipe;
@synthesize allowsRightSwipe;

@synthesize story;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
   self.browserView.delegate = nil;
}

-(id)initWithStory:( id< PFStory > )story_
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
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
          [ [ UIApplication sharedApplication ] openURL: self.story.url ];
       }
    } ];
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
   
   [ self loadStory: self.story ];
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
      id< PFStories > stories_ = [ PFSession sharedSession ].stories;
      NSUInteger index_ = [ stories_ indexOfStory: self.story ];
      [ self loadStory: (stories_.stories)[index_ + 1] ];
   }
}

-(void)swipeRight
{
   if ( self.allowsRightSwipe )
   {
      id< PFStories > stories_ = [ PFSession sharedSession ].stories;
      NSUInteger index_ = [ stories_ indexOfStory: self.story ];
      [ self loadStory: (stories_.stories)[index_ - 1] ];
   }
}

-(void)updateNavigation
{
   id< PFStories > stories_ = [ PFSession sharedSession ].stories;
   NSUInteger index_ = [ stories_ indexOfStory: self.story ];
   self.allowsRightSwipe = index_ > 0;
   self.allowsLeftSwipe = index_ < [ stories_ count ] - 1;
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
