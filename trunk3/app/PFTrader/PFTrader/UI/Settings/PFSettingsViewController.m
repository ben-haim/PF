#import "PFSettingsViewController.h"

#import "PFSettings.h"

#import "PFTableView.h"
#import "PFTableViewCategory+Settings.h"
#import "PFChangePasswordViewController.h"

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
       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
       {
          _categories = [ NSArray arrayWithObjects:
                         [ PFTableViewCategory settingsDefaultsCategoryWithSettings: self.settings ]
                         , [ PFTableViewCategory settingsConfirmationCategoryWithSettings: self.settings ]
                         , [ PFTableViewCategory settingsChartCategoryWithSettings: self.settings ]
                         , [ PFTableViewCategory settingsMarketPanelsCategoryWithSettings: self.settings ]
                         , [ PFTableViewCategory settingsEnvironmentCategoryWithSettings: self.settings ]
                         , nil ];
       }
      else
      {
         _categories = [ NSArray arrayWithObjects:
                        [ PFTableViewCategory settingsDefaultsCategoryWithSettings: self.settings ]
                        , [ PFTableViewCategory settingsConfirmationCategoryWithSettings: self.settings ]
                        , [ PFTableViewCategory settingsChartCategoryWithSettings: self.settings ]
                        , [ PFTableViewCategory settingsEnvironmentCategoryWithSettings: self.settings ]
                        , nil ];
      }
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

-(void)dealloc
{
   self.changePasswordButton = nil;
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
   [ self.navigationController pushViewController: [ [ PFChangePasswordViewController alloc ] initWithTitle: NSLocalizedString( @"CHANGE_PASSWORD_TITLE", nil )
                                                                                                 andSession: [ PFSession sharedSession ] ]
                                         animated: YES ];
}

-(IBAction)changePasswordAction:( id )sender_
{
   [ self showChangePassword ];
}

@end
