#import "PFSettingsViewController.h"
#import "PFChangePasswordViewController.h"
#import "PFTableViewCategory+Settings.h"
#import "PFNavigationController.h"
#import "PFTableView.h"
#import "PFSettings.h"
#import "UIColor+Skin.h"

static NSMutableArray* settings_controllers_;

@interface PFSettingsViewController ()

@property ( nonatomic, strong, readonly ) PFSettings* settings;
@property ( nonatomic, strong ) NSArray* categories;

@end

@implementation PFSettingsViewController

@synthesize changePasswordButton;
@synthesize settings;
@synthesize categories = _categories;

-(NSArray*)categories
{
   if ( !_categories )
   {
      _categories = @[[ PFTableViewCategory settingsDefaultsCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory settingsConfirmationCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory settingsChartCategoryWithSettings: self.settings ]
                     , [ PFTableViewCategory settingsEnvironmentCategoryWithSettings: self.settings ]];
   }
   return _categories;
}

-(PFSettings*)settings
{
   return [ PFSettings sharedSettings ];
}

-(id)init
{
   //! bad solution (temp)
   self = [ super initWithNibName: @"PFSettingsViewController" bundle: nil ];

   if ( !settings_controllers_ )
      settings_controllers_ = [ NSMutableArray arrayWithCapacity: 2 ];

   if ( self )
   {
      self.title = NSLocalizedString( @"SETTINGS", nil );
      [ settings_controllers_ addObject: self ];
   }

   return self;
}

-(void)reloadCategories
{
   _categories = nil;
   self.tableView.categories = self.categories;
   [ self.tableView reloadData ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   [ self.changePasswordButton setTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil ) forState: UIControlStateNormal ];
   [ self reloadCategories ];
   self.contentSizeForViewInPopover = CGSizeMake( 320.f, self.tableView.contentSize.height );
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setDarkNavigationBar ];
      self.view.backgroundColor = [ UIColor backgroundLightColor ];
   }
}

-(void)viewWillDisappear:(BOOL)animated
{
   [ self.categories makeObjectsPerformSelector: @selector( performApplierForObject: )
                                     withObject: self.settings ];
   
   [ settings_controllers_ removeObject: self ];
   for ( PFSettingsViewController* settings_controller_ in settings_controllers_ )
   {
      [ settings_controller_ reloadCategories ];
   }
}

-(void)showChangePassword
{
   [ self.pfNavigationController pushViewController: [ [ PFChangePasswordViewController alloc ] initWithTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil )
                                                                                                 andSession: [ PFSession sharedSession ] ]
                                         animated: YES ];
}

-(IBAction)changePasswordAction:( id )sender_
{
   [ self showChangePassword ];
}

@end
