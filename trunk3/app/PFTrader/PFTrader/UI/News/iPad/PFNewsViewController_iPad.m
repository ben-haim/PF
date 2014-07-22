#import "PFNewsViewController_iPad.h"

#import "PFNewsViewController.h"
#import "PFNewsBrowserViewController.h"

@interface PFNewsViewController_iPad ()< PFNewsViewControllerDelegate >

@end

@implementation PFNewsViewController_iPad

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"NEWS", nil );
   }
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   PFNewsViewController* news_controller_ = [ PFNewsViewController new ];
   news_controller_.delegate = self;
   self.masterController = news_controller_;
}

#pragma mark PFNewsViewControllerDelegate

-(void)newsViewController:( PFNewsViewController* )controller_
           didSelectStory:( id< PFStory > )story_
{
   PFNewsBrowserViewController* news_browser_ = [ [ PFNewsBrowserViewController alloc ] initWithStory: story_ ];
   news_browser_.view.backgroundColor = [ UIColor clearColor ];
   
   self.detailController = news_browser_;
}

@end
