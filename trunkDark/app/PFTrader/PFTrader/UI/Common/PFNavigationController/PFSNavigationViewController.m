#import "PFSNavigationViewController.h"
#import "PFNavigationController.h"
#import "PFModalWindow.h"
#import "PFSystemHelper.h"
#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"
#import "UIImage+Skin.h"

@interface PFSNavigationViewController ()

@property ( nonatomic, strong ) UIViewController* currentController;
@property ( nonatomic, strong ) NSString* previousTitle;

@end

@implementation PFSNavigationViewController

@synthesize navigationView;
@synthesize contentView;
@synthesize previousTitleLabel;
@synthesize currentTitleLabel;
@synthesize arrowImage;
@synthesize currentTitle;
@synthesize isFirstInStack;
@synthesize currentController;
@synthesize previousTitle;

-(void)dealloc
{
   [ self.currentController.view removeFromSuperview ];
   
   self.currentController = nil;
   self.previousTitle = nil;
}

-(id)initWithRootController:( UIViewController* )controller_
    previousControllerTitle:( NSString* )previous_title_
{
   self = [ self initWithNibName: NSStringFromClass( [ PFSNavigationViewController class ] )
                          bundle: nil ];
   
   if ( self )
   {
      self.currentController = controller_;
      self.currentTitle = controller_.title;
      self.previousTitle = previous_title_;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( useFlatUI() )
   {
      [ self setNeedsStatusBarAppearanceUpdate ];
   }
   
   if ( self.currentController.pfNavigationController.useCloseButton )
   {
      self.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                   style: UIBarButtonItemStylePlain
                                                                                  target: self
                                                                                  action: @selector( close ) ];
   }
   else
   {
      self.navigationItem.leftBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFMenuIcon.png" ]
                                                                                  style: UIBarButtonItemStylePlain
                                                                                 target: self
                                                                                 action: @selector( showMenu ) ];
   }
   
   self.currentController.view.frame = self.contentView.bounds;
   self.currentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self.currentController.view removeFromSuperview ];
   [ self.contentView addSubview: self.currentController.view ];
   
   [ self.previousTitleLabel addGestureRecognizer: [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                              action: @selector( popAction ) ] ];
   
   self.arrowImage.image = [ UIImage tableAccessoryIndicatorImageFlipped ];
   
   self.previousTitleLabel.textColor = [ UIColor blueTextColor ];
   self.currentTitleLabel.textColor = [ UIColor mainTextColor ];
   self.previousTitleLabel.text = self.previousTitle;
   self.currentTitleLabel.text = self.currentTitle;
   
   if ( self.isFirstInStack )
   {
      self.navigationView.hidden = YES;
      
      CGRect content_frame_ = self.contentView.frame;
      content_frame_.origin.y = 0.f;
      content_frame_.size.height += self.navigationView.frame.size.height;
      self.contentView.frame = content_frame_;
   }
   
   self.navigationView.image = [ UIImage secondBarBackground ];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
   return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear:animated_ ];
   [ self.currentController viewWillAppear: animated_ ];
}

-(void)viewDidAppear:(BOOL)animated_
{
   [ super viewDidAppear: animated_ ];
   [ self.currentController viewDidAppear: animated_ ];
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   [ self.currentController viewWillDisappear: animated_ ];
}

-(void)viewDidDisappear:( BOOL )animated_
{
   [ super viewDidDisappear: animated_ ];
   [ self.currentController viewDidDisappear: animated_ ];
}

-(void)close
{
   [ self.navigationController.formSheetController mz_dismissFormSheetControllerAnimated: YES
                                                                       completionHandler: nil ];
}

-(void)showMenu
{
   [ self dismissViewControllerAnimated: YES completion: nil ];
}

-(void)popAction
{
   [ self.navigationController popViewControllerAnimated: YES ];
}

@end
