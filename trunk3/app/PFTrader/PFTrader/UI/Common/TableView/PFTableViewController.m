#import "PFTableViewController.h"

#import "PFTableView.h"
#import "PFLayoutManager.h"

#import "NSObject+KeyboardNotifications.h"

@interface PFTableViewController ()

@property ( nonatomic, assign ) BOOL keyboardVisible;

@end

@implementation PFTableViewController

@synthesize tableView = _tableView;

@synthesize keyboardVisible;

-(NSString*)nibName
{
   NSString* real_nib_name_ = [ super nibName ];
   
   return real_nib_name_ ? real_nib_name_ : @"PFTableViewController";
}


-(void)loadView
{
   if ( self.nibName )
   {
      [ super loadView ];
   }
   else
   {
      self.tableView = [ PFTableView new ];
      self.view = self.tableView;
   }
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.tableView.backgroundColor = [ UIColor clearColor ];
}

-(void)dealloc
{
   self.tableView = nil;
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( [ PFLayoutManager currentLayoutManager ].shouldShrinkOnKeyboard )
   {
      [ self subscribeKeyboardNotifications ];
   }
}

-(void)viewWillDisappear:( BOOL )animated_
{
   [ super viewWillDisappear: animated_ ];
   
   [ self unsubscribeKeyboardNotifications ];
}

-(void)setContentInsetToZero
{
   if ( !self.keyboardVisible )
   {
      self.tableView.contentInset = UIEdgeInsetsZero;
   }
}

-(void)didHideKeyboard
{
   //To prevent content jumping
   [ self performSelector: @selector( setContentInsetToZero ) withObject: nil afterDelay: 0.2 ];
   self.keyboardVisible = NO;
}

-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_
{
   self.keyboardVisible = YES;
   
   UIEdgeInsets content_inset_ = UIEdgeInsetsZero;
   content_inset_.bottom = height_;
   
   self.tableView.contentInset = content_inset_;
   
   [ self.tableView scrollToSelectedRowAnimated: YES ];
}

@end