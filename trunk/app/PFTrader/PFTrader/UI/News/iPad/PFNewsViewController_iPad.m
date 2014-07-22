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
   PFNewsViewController* news_controller_ = [ PFNewsViewController new ];
   news_controller_.delegate = self;
   self.masterController = news_controller_;

   [ super viewDidLoad ];
}

#pragma mark PFNewsViewControllerDelegate

-(void)newsViewController:( PFNewsViewController* )controller_
           didSelectStory:( id< PFStory > )story_
{
   self.detailController = [ [ PFNewsBrowserViewController alloc ] initWithStory: story_ ];
}

@end
