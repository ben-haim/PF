#import "PFViewController.h"
#import "PFSystemHelper.h"

#import "UIColor+Skin.h"

@interface PFViewController ()

@end

@implementation PFViewController

@synthesize backgroundView;

+(UIImage*)backgroundImage
{
   static UIImage* main_background_image_ = nil;
   
   if ( !main_background_image_ )
   {
      main_background_image_ = [ UIImage imageNamed: @"PFBackground" ];
   }
   
   return main_background_image_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ PFViewController backgroundImage ] ];
   self.backgroundView.frame = self.view.bounds;
   self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   self.backgroundView.contentMode = UIViewContentModeScaleToFill;

   [ self.view addSubview: self.backgroundView ];
   [ self.view sendSubviewToBack: self.backgroundView ];
   
   if ( useFlatUI() )
   {
      self.edgesForExtendedLayout = UIRectEdgeNone;
   }
}

-(void)dealloc
{
   self.backgroundView.image = nil;
   self.backgroundView = nil;
}

@end
